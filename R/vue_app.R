#' A Vue component as a Shiny UI object (prototype)
#'
#' The Vue layer's instance: Vue's Options API written in R. `template`,
#' `data`, `methods`, `computed`, `watch` and the lifecycle hooks are Vue's
#' own options; `model` names the field that is `input$<id>`, `inputs`
#' reports other fields under ids of their own, and `plugins` names Vue
#' plugins on the page to install (`"ElementPlus"`). It loads Vue and the
#' bridge only -- nothing of Element.
#'
#' Prototype: not exported yet (see `.claude/plans/vue-layer-2026-10-04.md`).
#'
#' @param id The host's id; `input$<id>` when `model` is given.
#' @param template Tags or a string.
#' @param data Named list: the initial state.
#' @param methods,computed,watch Named lists of [JS()] functions.
#' @param ... Other Vue options, snake_case or as Vue spells them:
#'   `mounted = JS(...)`, `before_unmount = JS(...)`, `components = list(...)`.
#' @param model The field reported as `input$<id>`.
#' @param inputs Other fields to report, `c(<field> = <inputId>)`.
#' @param plugins Global names of Vue plugins to `app.use()`.
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
  ...,
  model = NULL,
  inputs = NULL,
  plugins = NULL,
  dependencies = NULL
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
      list(methods = methods, computed = computed, watch = watch)
    ),
    extra
  )
  if (!is.null(model) && !model %in% names(data)) {
    stop("`model` must name a field of `data`.", call. = FALSE)
  }
  if (length(inputs)) {
    report <- .el_mounted_init(stats::setNames(names(inputs), unname(inputs)))
    options$mounted <- if (is.null(options$mounted)) {
      report
    } else {
      JS(sprintf(
        "function() { (%s).call(this); (%s).call(this); }",
        report,
        options$mounted
      ))
    }
    for (field in names(inputs)) {
      options$watch[[field]] <- JS(sprintf(
        "{handler: function(v) { window.Shiny && Shiny.setInputValue(%s, v); }, deep: true}",
        jsonlite::toJSON(unname(inputs[[field]]), auto_unbox = TRUE)
      ))
    }
  }
  if (!is.null(model)) {
    data[model] <- list(.el_restore(id, data[[model]]))
    options$data <- data
  }
  spec <- list(options = options, input = model)
  if (length(plugins)) {
    spec$plugins <- I(as.character(plugins))
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

#' Set fields of the page's shared Vue state, `$shared` in any template
#' (prototype)
#' @noRd
update_vue_shared <- function(
  session = shiny::getDefaultReactiveDomain(),
  ...
) {
  .el_check_session(session)
  session$sendCustomMessage("shinyVueShared", list(...))
  invisible(NULL)
}
