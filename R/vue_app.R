# The Vue layer: Vue components in Shiny, knowing no component library.
#
# A component is Vue's Options API written in R -- the options under Vue's
# own names -- plus three things Shiny and htmltools need: `id` (where Vue
# would `mount('#app')`), `input` (which field is `input$<id>`) and
# `dependencies`; `use` is Vue's `app.use()`.

# Vue 3's component options. Multi-word ones also answer to snake_case.
.vue_option_names <- c(
  "template",
  "render",
  "data",
  "props",
  "emits",
  "setup",
  "computed",
  "methods",
  "watch",
  "expose",
  "components",
  "directives",
  "provide",
  "inject",
  "mixins",
  "extends",
  "name",
  "inheritAttrs",
  "compilerOptions",
  "beforeCreate",
  "created",
  "beforeMount",
  "mounted",
  "beforeUpdate",
  "updated",
  "beforeUnmount",
  "unmounted",
  "errorCaptured",
  "renderTracked",
  "renderTriggered",
  "activated",
  "deactivated",
  "serverPrefetch"
)

#' Vue's option names from the R spelling
#'
#' A snake_case spelling of one of Vue's multi-word options becomes Vue's
#' (`before_unmount` -> `beforeUnmount`); every other name is left exactly as
#' written. Two spellings of one option with different values are an error.
#'
#' @param opts A named list of options.
#' @return The list, named as Vue names its options.
#' @keywords internal
.vue_option_aliases <- function(opts) {
  if (!length(opts)) {
    return(opts)
  }
  nms <- names(opts)
  camel <- vapply(nms, .vue_camel, "")
  known <- grepl("_", nms) & camel %in% .vue_option_names
  nms[known] <- camel[known]
  dup <- unique(nms[duplicated(nms)])
  for (d in dup) {
    vals <- opts[nms == d]
    if (!all(vapply(vals, identical, logical(1), vals[[1]]))) {
      stop(
        "`",
        d,
        "` is given twice, under two spellings, with different values.",
        call. = FALSE
      )
    }
  }
  names(opts) <- nms
  opts[!duplicated(nms)]
}

#' The `use` of a component as the bridge reads it
#'
#' @param use `c("PluginA", "PluginB")`, or a list naming a plugin with its
#'   options: `list(PluginA = list(size = "small"), "PluginB")`.
#' @return A list of names and `list(name =, options =)`.
#' @keywords internal
.vue_use <- function(use) {
  if (!length(use)) {
    return(NULL)
  }
  if (inherits(use, "JS_EVAL")) {
    use <- list(use)
  }
  nms <- names(use) %||% rep("", length(use))
  I(unname(Map(
    function(p, nm) {
      if (nzchar(nm)) {
        list(name = nm, options = p)
      } else if (inherits(p, "JS_EVAL")) {
        # a plugin written here, revived in the browser: list(plugin = ...)
        list(plugin = p)
      } else {
        as.character(p)
      }
    },
    as.list(use),
    nms
  )))
}

#' A rate policy, as Shiny's InputBinding gives one
#'
#' @param rate `NULL`, `"debounce"` or `"throttle"` (250 ms), or
#'   `list(policy =, delay =)`.
#' @return `NULL` or `list(policy, delay)`.
#' @noRd
.vue_rate <- function(rate) {
  if (is.null(rate)) {
    return(NULL)
  }
  if (is.character(rate) && length(rate) == 1L) {
    rate <- list(policy = rate, delay = 250)
  }
  if (
    !is.list(rate) ||
      !isTRUE(rate$policy %in% c("debounce", "throttle")) ||
      !(is.null(rate$delay) || (is.numeric(rate$delay) && rate$delay >= 0))
  ) {
    stop(
      "`rate` must be \"debounce\" or \"throttle\", or ",
      "`list(policy = \"debounce\", delay = 250)`.",
      call. = FALSE
    )
  }
  list(policy = rate$policy, delay = rate$delay %||% 250)
}

#' Shiny UI in a template, taken out of it: islands
#'
#' Vue compiles a template and owns the elements it draws: it drops
#' `<script>`s, and re-creates what `v-if` and `v-for` show, so a Shiny input
#' in a template loses its binding when Vue draws it again, an htmlwidget
#' its data, a component of its own (a host) its template. Such UI is taken
#' out: rendered beside the template, as Shiny renders it, in a hidden
#' holder, and the template gets `<shiny-island name="k">` in its place,
#' which moves the UI in while Vue shows it and back out -- suspended, its
#' state kept -- when Vue removes it. Scripts and styles found loose in the
#' template go to the holder too.
#'
#' An island is a tag with a Shiny input's, output's or htmlwidget's class,
#' a component of its own (`data-shiny-vue`), a `conditionalPanel()`
#' (`data-display-if`), or a tag marked `data-shiny-island`.
#'
#' @param template A tag, or a list of them.
#' @param components Whether components of their own (hosts) and tags marked
#'   `data-shiny-island` are islands too. A component library that folds
#'   its components into one another, and places its containers itself,
#'   leaves them in the template: `FALSE`.
#' @return A list: `template`, with placeholders; `holder`, a tag or `NULL`.
#' @keywords internal
.vue_islands <- function(template, components = TRUE) {
  islands <- list()
  loose <- list()
  island_class <- paste0(
    "(^|\\s)(shiny-input-container|action-button|action-link|",
    "shiny-[a-z-]*-output|shiny-tab-input|html-widget|html-widget-output|",
    "bslib-task-button)(\\s|$)"
  )
  is_island <- function(x) {
    a <- x$attribs
    cls <- paste(unlist(a[names(a) == "class"]), collapse = " ")
    marks <- c(
      "data-display-if",
      if (components) c("data-shiny-vue", "data-shiny-island")
    )
    any(marks %in% names(a)) || grepl(island_class, cls)
  }
  island <- function(node) {
    k <- as.character(length(islands) + 1L)
    islands[[k]] <<- htmltools::tags$div(
      `data-shiny-island-of` = k,
      style = "display: contents",
      node
    )
    htmltools::tag("shiny-island", list(name = k))
  }
  walk <- function(node) {
    # an htmlwidget as it stands: its data travels in a script
    if (inherits(node, "htmlwidget")) {
      return(island(node))
    }
    # any other object drawn by as.tags() -- a component's specification
    if (
      components &&
        is.object(node) &&
        !inherits(
          node,
          c("shiny.tag", "shiny.tag.list", "html", "html_dependency")
        ) &&
        !is.null(utils::getS3method(
          "as.tags",
          class(node)[1],
          optional = TRUE,
          envir = asNamespace("htmltools")
        ))
    ) {
      node <- htmltools::as.tags(node)
    }
    if (inherits(node, "shiny.tag")) {
      if (is_island(node)) {
        return(island(node))
      }
      if (tolower(node$name) %in% c("script", "style", "link")) {
        loose[[length(loose) + 1L]] <<- node
        return(NULL)
      }
      node$children <- lapply(node$children, walk)
      return(node)
    }
    if (is.list(node) && !inherits(node, "html_dependency")) {
      kept <- attributes(node)
      node <- lapply(node, walk)
      attributes(node) <- kept
      return(node)
    }
    node
  }
  template <- walk(template)
  holder <- if (length(islands) || length(loose)) {
    htmltools::tags$div(
      `data-shiny-vue-islands` = NA,
      style = "display: none",
      unname(islands),
      loose
    )
  }
  list(template = template, holder = holder)
}

#' A host: the element a component mounts on, carrying its template and spec
#'
#' @param id The host's id.
#' @param template The template, as HTML.
#' @param spec What the bridge reads: `options`, `input`, `use`, ...
#' @param dependencies htmlDependencies to attach beside the Vue layer's.
#' @return A tag with its dependencies.
#' @keywords internal
.vue_host <- function(
  id,
  template,
  spec,
  dependencies = list(),
  islands = NULL
) {
  # The template travels as a script, which the browser does not parse: no
  # flash of raw tags before Vue runs, and camelCase attribute names survive
  template <- gsub("</script", "<\\/script", template, ignore.case = TRUE)
  host <- htmltools::tags$div(
    id = id,
    `data-shiny-vue` = NA,
    style = "display: contents",
    htmltools::tags$script(
      type = "text/x-template",
      `data-shiny-vue-template` = NA,
      htmltools::HTML(template)
    ),
    htmltools::tags$script(
      type = "application/json",
      `data-shiny-vue-options` = NA,
      htmltools::HTML(.vue_json(spec))
    ),
    # Shiny UI taken out of the template (.vue_islands())
    islands
  )
  host <- htmltools::attachDependencies(
    host,
    c(.vue_dependencies(), dependencies)
  )
  # what an output compares from render to render, to send only the data
  # that changed (.vue_output_patch()): the islands are part of the template
  attr(host, "vue_host") <- list(
    template = paste0(
      template,
      if (!is.null(islands)) as.character(htmltools::renderTags(islands)$html)
    ),
    spec = spec
  )
  host
}

#' A template, tags or a string, as HTML and the dependencies it carries
#' @noRd
.vue_template <- function(template) {
  if (is.null(template)) {
    return(list(html = "", dependencies = list()))
  }
  if (is.character(template) && !inherits(template, "html")) {
    return(list(html = paste(template, collapse = "\n"), dependencies = list()))
  }
  r <- htmltools::renderTags(template)
  list(html = as.character(r$html), dependencies = r$dependencies)
}

#' Child components: their names checked, their dependencies collected
#'
#' A name is used as written, and one in snake_case answers to its
#' kebab-case form too (the bridge registers both), so `todo_item` and
#' `todo-item` cannot both be given. The dependencies are those of every
#' child's template and its own `dependencies`, children of children
#' included.
#' @noRd
.vue_components <- function(components) {
  if (!length(components)) {
    return(list())
  }
  nms <- names(components)
  if (is.null(nms) || any(!nzchar(nms))) {
    stop(
      "`components` must be named: `list(todo_item = vue_component(...))`.",
      call. = FALSE
    )
  }
  kebab <- gsub("_", "-", nms, fixed = TRUE)
  clash <- unique(kebab[duplicated(kebab)])
  if (length(clash)) {
    stop(
      "`components` names ",
      paste(sQuote(clash), collapse = ", "),
      " twice, in snake_case and kebab-case.",
      call. = FALSE
    )
  }
  unlist(
    lapply(components, function(child) {
      # a vue_component() carries its children's already
      deps <- attr(child, "dependencies")
      if (is.null(deps) && is.list(child)) {
        .vue_components(child$components)
      } else {
        deps
      }
    }),
    recursive = FALSE,
    use.names = FALSE
  )
}

#' A Vue component, as Shiny UI
#'
#' `vue_app()` writes a Vue 3 component in R and places it on the page: the
#' arguments are Vue's own options, under Vue's own names, and the browser
#' creates and mounts it with `Vue.createApp()`. Three things are added, as
#' Shiny needs them: `id`, where it goes and what the server calls it;
#' `input`, the field that is `input$<id>`; and `dependencies`. `use` is
#' Vue's `app.use()`.
#'
#' @section What goes where:
#' | Vue | Here |
#' |---|---|
#' | `createApp(options).mount('#app')` | `vue_app(id, ...)` |
#' | `data()`, `methods`, `computed`, `watch`, `setup()`, `emits`, hooks | the same names; functions as [JS()] |
#' | `beforeUnmount`, `inheritAttrs`, ... | Vue's name, or snake_case: `before_unmount` |
#' | `app.use(Plugin, options)` | `use = list(Plugin = options)` |
#' | `v-model` on the component (its value) | `input = "<field>"`: `input$<id>` |
#' | `this.$emit("picked", x)` | `input$<id>_picked`, for an event in `emits` |
#'
#' Every function -- a method, a watcher, `setup()` -- is JavaScript, given
#' with [JS()]. `data` is the initial state, as R writes it: a list becomes
#' an object, a data.frame its rows. After that the component changes it,
#' and the server does with [update_vue()] or [render_vue()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the `input` field, on load, on change and after an
#'   update; several fields give one value, a named list of them.
#' - `input$<id>_<event>` -- each event in `emits`, sent with `$emit()`:
#'   one argument as it is, several as a list (`arg1`, `arg2`, ...), none as
#'   `TRUE`.
#'
#' @section Data from users:
#' Show it through `data` -- `{{ field }}`, `:prop="field"` -- which Vue
#' renders as text. Never paste it into the template: a template is code,
#' and `{{ }}` in it runs.
#'
#' @param id The component's id: `input$<id>`, and what [update_vue()] and
#'   [call_vue()] name. Inside a module, `ns("id")`.
#' @param template The template: htmltools tags, or a string.
#' @param data Named list: the initial state. A data.frame in it is rows.
#'   A vector of one
#'   element travels as a single value, as in Shiny; wrap it in `I()` to
#'   keep it an array: `tags = I("red")`.
#' @param methods,computed,watch Named lists of [JS()] functions.
#' @param emits Names of the events the component sends with `$emit()`.
#' @param setup A [JS()] function: Vue's Composition API.
#' @param components Named list of [vue_component()]s, for the template.
#' @param ... Any other option of Vue's, by Vue's name or its snake_case:
#'   `mounted = JS(...)`, `before_unmount = JS(...)`, `provide = JS(...)`.
#' @param input The field whose value is `input$<id>`, or several, for one
#'   value made of them. `NULL`: the component reports no value.
#' @param outputs Ids of outputs the component's `data` follows, rendered
#'   with [render_vue_data()]: each render sets the fields it names, which
#'   must be in `data` (or `setup()`'s state). Inside a module,
#'   `ns("stats")`. While Shiny recalculates one, `$recalculating.<id>` is
#'   `true` in templates.
#' @param type An input handler for the value, as Shiny's inputs have:
#'   the name given to [shiny::registerInputHandler()], which converts the
#'   value on its way into R -- `"shiny.date"` makes a `"2026-01-31"` a
#'   `Date`.
#' @param rate How often the value is sent while it changes: `"debounce"`
#'   or `"throttle"` (250 ms), or `list(policy = "debounce", delay = 500)`,
#'   as Shiny's `textInput()` debounces. `NULL` sends every change.
#' @param use Vue plugins to install: by the global name each is loaded
#'   under, `"MyPlugin"`, or with options, `list(MyPlugin = list(...))`; or
#'   written here, `JS("{ install(app) { app.config.errorHandler = ... } }")`
#'   -- the way to reach the app's own configuration.
#' @param dependencies [htmltools::htmlDependency()]s the component needs:
#'   the plugins' scripts and stylesheets.
#' @param events Events of the template's root -- a library's component
#'   there, or a DOM event -- each reported as `input$<id>_<event>`, by its
#'   name in snake_case or Vue's: `events = "row_click"`. Arguments travel
#'   as `emits`' do -- one as itself, several as `list(arg1, arg2, ...)`, a
#'   key pressed as `list(key, code, ctrl, shift, alt, meta)`, DOM objects
#'   dropped. The template must then be one tag.
#' @param on Handlers of your own for events of the template's root: a
#'   named list of [JS()] functions, each called with `report` and the
#'   event's arguments; `report(name, value)` sets `input$<id>_<name>`.
#' @return A tag, with its dependencies.
#' @seealso [vue_component()], [vue_store()], [update_vue()], [call_vue()],
#'   [render_vue()].
#' @examples
#' counter <- vue_app(
#'   "counter",
#'   template = htmltools::tags$button(`@click` = "n++", "Clicked {{ n }} times"),
#'   data = list(n = 0),
#'   input = "n"
#' )
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     fluidPage(counter, textOutput("n")),
#'     function(input, output) output$n <- renderText(input$counter)
#'   )
#' }
#' @export
vue_app <- function(
  id,
  template,
  data = list(),
  methods = NULL,
  computed = NULL,
  watch = NULL,
  emits = NULL,
  setup = NULL,
  components = NULL,
  ...,
  input = NULL,
  type = NULL,
  rate = NULL,
  outputs = NULL,
  use = NULL,
  dependencies = NULL,
  events = NULL,
  on = NULL
) {
  child_deps <- .vue_components(components)
  # events and handlers on the template's root: a library's component
  # there forwards its events, as the package's own components do
  if (length(events) || length(on)) {
    if (!inherits(template, "shiny.tag")) {
      stop(
        "`events` and `on` go on the template's root tag: give the ",
        "template as one tag, `tags$div(...)` or a library's.",
        call. = FALSE
      )
    }
    if (length(events)) {
      .vue_events_check(events, known = gsub("_", "-", events), what = id)
    }
    bound <- .vue_event_bindings(
      id,
      unique(gsub("_", "-", as.character(events))),
      on = on
    )
    template <- .vue_on_attach(template, list(attrs = bound$attrs))
    methods <- c(methods, bound$methods)
  }
  .vue_app_spec(
    id = id,
    template = template,
    data = data,
    options = c(
      Filter(
        Negate(is.null),
        list(
          methods = methods,
          computed = computed,
          watch = watch,
          emits = if (length(emits)) I(emits),
          setup = setup,
          components = components
        )
      ),
      list(...)
    ),
    input = input,
    type = type,
    rate = rate,
    outputs = outputs,
    use = use,
    dependencies = c(.vue_dependency_list(dependencies), child_deps)
  )
}

#' One dependency or a list of them, as a list
#' @noRd
.vue_dependency_list <- function(dependencies) {
  if (inherits(dependencies, "html_dependency")) {
    list(dependencies)
  } else {
    dependencies
  }
}

#' The body of vue_app() and vue_store()
#' @noRd
.vue_app_spec <- function(
  id,
  template,
  data,
  options,
  input,
  use,
  dependencies,
  store = FALSE,
  outputs = NULL,
  type = NULL,
  rate = NULL
) {
  if (!is.character(id) || length(id) != 1L || !nzchar(id)) {
    stop("`id` must be a single string.", call. = FALSE)
  }
  islands <- NULL
  if (
    inherits(template, c("shiny.tag", "shiny.tag.list")) ||
      (is.list(template) && !inherits(template, "html"))
  ) {
    taken <- .vue_islands(template)
    template <- taken$template
    islands <- taken$holder
  }
  tpl <- .vue_template(template)
  data <- lapply(data, .vue_rows)
  outputs <- .vue_outputs_arg(outputs)
  options <- .vue_option_aliases(options)
  spec <- list(options = c(list(data = data), options))
  in_setup <- !is.null(options$setup)
  if (length(input)) {
    if (!is.character(input)) {
      stop("`input` must name a field, or several.", call. = FALSE)
    }
    missing_fields <- setdiff(input, names(data))
    if (length(missing_fields) && !in_setup) {
      stop(
        "`input` names ",
        paste(sQuote(missing_fields), collapse = ", "),
        ", not a field of `data`.",
        call. = FALSE
      )
    }
    if (length(input) == 1L) {
      spec$input <- input
      if (input %in% names(data)) {
        # a bookmark brings the value back into the data
        spec$options$data[input] <- list(.vue_restore(id, data[[input]]))
      } else {
        restored <- shiny::restoreInput(id = id, default = NULL)
        if (!is.null(restored)) spec$restored <- restored
      }
    } else {
      # one value of several fields: the binding reads an expression
      spec$input <- sprintf(
        "({%s})",
        paste(sprintf("%s: %s", input, input), collapse = ", ")
      )
    }
  }
  if (!is.null(type) || !is.null(rate)) {
    if (!length(input)) {
      stop("`type` and `rate` apply to the value: give `input`.", call. = FALSE)
    }
    if (!is.null(type) && (!is.character(type) || length(type) != 1L)) {
      stop("`type` must name an input handler, one string.", call. = FALSE)
    }
    spec$type <- type
    spec$rate <- .vue_rate(rate)
  }
  spec$use <- .vue_use(use)
  if (length(outputs)) {
    spec$outputs <- I(outputs)
  }
  if (isTRUE(store)) {
    spec$store <- TRUE
  }
  dependencies <- .vue_dependency_list(dependencies)
  .vue_host(
    id,
    tpl$html,
    spec,
    c(dependencies, tpl$dependencies),
    islands = islands
  )
}

#' A Vue child component, for a template to use
#'
#' Vue's component options for one component that [vue_app()] registers
#' under `components =`: `components = list(todo_item = vue_component(...))`
#' is `<todo-item>` in the template, and `<todo_item>` as written. As in Vue, a child takes `props` and
#' sends `emits` to its parent's template (`@toggle="..."`); `data` gives
#' each instance its own copy.
#'
#' @param template The child's template: tags or a string.
#' @param props Names of its props, or Vue's object form as a list.
#' @param emits Names of the events it sends with `$emit()`.
#' @param data Named list: each instance's initial state.
#' @param methods,computed,watch Named lists of [JS()] functions.
#' @param setup A [JS()] function: Vue's Composition API.
#' @param ... Any other option of Vue's, by Vue's name or its snake_case --
#'   `components` for children of its own.
#' @param dependencies [htmltools::htmlDependency()]s the child needs; the
#'   [vue_app()] that registers it attaches them, with those its template
#'   carries.
#' @return A list of Vue options, of class `vue_component`.
#' @examples
#' item <- vue_component(
#'   template = "<li @click=\"$emit('toggle')\">{{ text }}</li>",
#'   props = "text",
#'   emits = "toggle"
#' )
#' @export
vue_component <- function(
  template,
  props = NULL,
  emits = NULL,
  data = NULL,
  methods = NULL,
  computed = NULL,
  watch = NULL,
  setup = NULL,
  ...,
  dependencies = NULL
) {
  tpl <- .vue_template(template)
  opts <- c(
    list(template = tpl$html),
    Filter(
      Negate(is.null),
      list(
        props = if (is.character(props)) I(props) else props,
        emits = if (length(emits)) I(emits),
        # each instance its own copy: data is a function in a component
        data = if (length(data)) {
          JS(paste0(
            "function() { return ",
            jsonlite::toJSON(
              lapply(data, .vue_rows),
              auto_unbox = TRUE,
              null = "null",
              na = "null",
              digits = NA
            ),
            "; }"
          ))
        },
        methods = methods,
        computed = computed,
        watch = watch,
        setup = setup
      )
    ),
    list(...)
  )
  opts <- .vue_option_aliases(opts)
  structure(
    opts,
    class = c("vue_component", "list"),
    dependencies = c(
      .vue_dependency_list(dependencies),
      tpl$dependencies,
      .vue_components(opts$components)
    )
  )
}

#' State shared by Vue components: a store
#'
#' Each [vue_app()] is an application of its own, so Vue's `provide` and
#' `inject` cannot reach from one to another. Vue's guide answers shared
#' state with a store, one `reactive()` object every component refers to,
#' and this is that: every template reads and writes it as
#' `$store.<id>.<field>`, at once and in the browser. It is also a component
#' of the bridge, so the server reaches it the way it reaches any other:
#' `input` makes fields `input$<id>`, [update_vue()] sets them -- and every
#' template showing them follows -- and a bookmark restores them.
#'
#' A store can be anywhere on the page; stores are set up before the
#' components that read them.
#'
#' @param id The store's id: `$store.<id>` in templates.
#' @param data Named list: the initial state.
#' @param input Fields reported as `input$<id>`, as for [vue_app()].
#' @param outputs Outputs the store's data follows, as for [vue_app()].
#' @return A tag: a hidden host that holds the store.
#' @examples
#' vue_store("cart", data = list(count = 0), input = "count")
#' vue_app("add", htmltools::tags$button(`@click` = "$store.cart.count++", "Add"))
#' vue_app("show", htmltools::tags$span("{{ $store.cart.count }} in the cart"))
#' @export
vue_store <- function(id, data = list(), input = NULL, outputs = NULL) {
  .vue_app_spec(
    id = id,
    template = htmltools::tags$span(hidden = NA),
    data = data,
    options = list(),
    input = input,
    outputs = outputs,
    use = NULL,
    dependencies = NULL,
    store = TRUE
  )
}
