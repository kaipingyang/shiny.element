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
  nms <- names(use) %||% rep("", length(use))
  I(unname(Map(
    function(p, nm) {
      if (nzchar(nm)) list(name = nm, options = p) else as.character(p)
    },
    as.list(use),
    nms
  )))
}

#' A host: the element a component mounts on, carrying its template and spec
#'
#' @param id The host's id.
#' @param template The template, as HTML.
#' @param spec What the bridge reads: `options`, `input`, `use`, ...
#' @param dependencies htmlDependencies to attach beside the Vue layer's.
#' @return A tag with its dependencies.
#' @keywords internal
.vue_host <- function(id, template, spec, dependencies = list()) {
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
    )
  )
  host <- htmltools::attachDependencies(
    host,
    c(.vue_dependencies(), dependencies)
  )
  # what an output compares from render to render, to send only the data
  # that changed (.vue_output_patch())
  attr(host, "vue_host") <- list(template = template, spec = spec)
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
#' @param outputs Fields the server fills, each from an output it renders
#'   with [render_vue_data()]: `c(stats = "stats")`, field = output id, or
#'   `"stats"` for both. Inside a module, `c(stats = ns("stats"))`. A field
#'   not in `data` starts `NULL`. Each render sets the field; while Shiny
#'   recalculates it, `$recalculating.<output id>` is `true` in templates.
#' @param use Vue plugins to install, by the global name each is loaded
#'   under: `"MyPlugin"`, or with options, `list(MyPlugin = list(...))`.
#' @param dependencies [htmltools::htmlDependency()]s the component needs:
#'   the plugins' scripts and stylesheets.
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
  outputs = NULL,
  use = NULL,
  dependencies = NULL
) {
  child_deps <- .vue_components(components)
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
  outputs = NULL
) {
  if (!is.character(id) || length(id) != 1L || !nzchar(id)) {
    stop("`id` must be a single string.", call. = FALSE)
  }
  tpl <- .vue_template(template)
  data <- lapply(data, .vue_rows)
  outputs <- .vue_outputs_arg(outputs)
  # a field an output fills starts empty, if not given
  for (field in setdiff(names(outputs), names(data))) {
    data[field] <- list(NULL)
  }
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
  spec$use <- .vue_use(use)
  if (length(outputs)) {
    spec$outputs <- as.list(outputs)
  }
  if (isTRUE(store)) {
    spec$store <- TRUE
  }
  dependencies <- .vue_dependency_list(dependencies)
  .vue_host(id, tpl$html, spec, c(dependencies, tpl$dependencies))
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
#' @param outputs Fields filled by outputs, as for [vue_app()].
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
