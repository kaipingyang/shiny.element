#' A Vue component as a Shiny UI object (prototype)
#'
#' The Vue layer's instance: Vue's Options API written in R. `template`,
#' `data`, `methods`, `computed`, `watch`, `emits` and the lifecycle hooks
#' are Vue's own options. Two Shiny words are added, and only where Shiny
#' needs them:
#'
#' * `model`: the component's value, `input$<id>` -- one field, or several
#'   (`c("from", "to")`), then one value that is a named list of them, as
#'   `dateRangeInput()` gives one value of two dates.
#' * Everything else a component sends out it sends as Vue does, with
#'   `this.$emit("name", value)` for an event declared in `emits`; each
#'   arrives as `input$<id>_<name>`, as Element's own events do.
#'
#' `plugins` names Vue plugins on the page to install (`"ElementPlus"`). It
#' loads Vue and the bridge only -- nothing of Element.
#'
#' Prototype: not exported yet (see `.claude/plans/vue-layer-2026-10-04.md`).
#'
#' @param id The host's id: `input$<id>` when `model` is given, and every
#'   emitted event's prefix.
#' @param template Tags or a string.
#' @param data Named list: the initial state.
#' @param methods,computed,watch Named lists of [JS()] functions.
#' @param emits Names of the events the component sends with `$emit()`.
#' @param ... Other Vue options, snake_case or as Vue spells them:
#'   `mounted = JS(...)`, `before_unmount = JS(...)`, `components = list(...)`.
#' @param model The field, or fields, that are `input$<id>`.
#' @param plugins Global names of Vue plugins to `app.use()`, or a named
#'   list giving one its options: `list(MyPlugin = list(size = "small"))`.
#' @param dependencies htmlDependencies the template needs.
#' @return A tag list.
#' @keywords internal
#' @noRd
vue_app <- function(
  id,
  template,
  data = list(),
  methods = NULL,
  computed = NULL,
  watch = NULL,
  emits = NULL,
  ...,
  model = NULL,
  plugins = NULL,
  dependencies = NULL,
  .store = FALSE
) {
  rendered <- if (is.character(template) && !inherits(template, "html")) {
    list(html = template, dependencies = list())
  } else {
    htmltools::renderTags(template)
  }
  # a data.frame is rows, as v-for walks it
  data <- lapply(data, function(v) {
    if (is.data.frame(v)) .el_table_rows(v) else v
  })
  extra <- list(...)
  names(extra) <- vapply(names(extra), .el_camel_case, "")
  options <- c(
    list(data = data),
    Filter(
      Negate(is.null),
      list(
        methods = methods,
        computed = computed,
        watch = watch,
        emits = if (length(emits)) I(emits)
      )
    ),
    extra
  )
  # state set up in setup() is not in data: it can be reported all the same
  if (length(model) && is.null(extra$setup) && !all(model %in% names(data))) {
    stop("`model` must name fields of `data`.", call. = FALSE)
  }
  input <- NULL
  if (length(model) == 1 && model %in% names(data)) {
    data[model] <- list(.el_restore(id, data[[model]]))
    options$data <- data
    input <- model
  } else if (length(model) == 1) {
    options$data <- data
    input <- model
  } else if (length(model) > 1) {
    # one value of several fields: the binding reads an expression
    input <- sprintf(
      "({%s})",
      paste(sprintf("%s: %s", model, model), collapse = ", ")
    )
  }
  spec <- list(options = options, input = input)
  if (length(plugins)) {
    # c("A", "B"), or list(A = list(<options>), "B")
    nms <- names(plugins) %||% rep("", length(plugins))
    spec$plugins <- I(unname(Map(
      function(p, nm) {
        if (nzchar(nm)) list(name = nm, options = p) else as.character(p)
      },
      as.list(plugins),
      nms
    )))
  }
  if (isTRUE(.store)) {
    spec$store <- TRUE
  }
  template <- gsub("</script", "<\\/script", rendered$html, ignore.case = TRUE)
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
      htmltools::HTML(.el_vue_json(spec))
    )
  )
  htmltools::attachDependencies(
    host,
    c(
      .vue_dependencies(),
      if (inherits(dependencies, "html_dependency")) {
        list(dependencies)
      } else {
        dependencies
      },
      rendered$dependencies
    )
  )
}

#' State shared by components: a store (prototype)
#'
#' Vue's guide answers "state shared between components" with one
#' `reactive()` object they all refer to. Each component here is an app of
#' its own, so a store is that object, registered by id: every template
#' reads and writes it as `$store.<id>.<field>`, at once and without the
#' server. It is also a component of the bridge, so the Shiny side comes for
#' free and only when asked for: `model` makes fields `input$<id>`, an
#' update sets them, a bookmark restores them.
#'
#' @param id The store's id: `$store.<id>` in templates, `input$<id>` with
#'   `model`.
#' @param data Named list: the initial state.
#' @param model Fields reported as `input$<id>`, as for [vue_app()].
#' @return A tag list: an empty host that registers the store.
#' @noRd
vue_store <- function(id, data = list(), model = NULL) {
  vue_app(
    id,
    htmltools::tags$span(hidden = NA),
    data = data,
    model = model,
    .store = TRUE
  )
}
