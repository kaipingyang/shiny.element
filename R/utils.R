# 工具函数示例
#' Placeholder for an unset optional prop
#'
#' A field left out of the Vue instance's `data` is not reactive, so
#' `update_el_*()` can never set it later. Unset optional props are therefore
#' declared as `NA`, which serialises to `null`, and read back through
#' [.el_optional_bind()], which turns that `null` into `undefined` so Element
#' applies its own default.
#'
#' @param x A value, or `NULL` when the user did not supply one.
#' @return `x`, or `NA` when `x` is `NULL`.
#' @keywords internal
.el_or_na <- function(x) {
  if (is.null(x)) NA else x
}

#' @keywords internal
el_ns <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) session$ns(id) else id
}

#' Build a Vue `mounted` hook that reports initial values to Shiny
#'
#' Element UI components only emit `@change` on user interaction, and Vue
#' `watch` handlers do not fire on mount. Without this hook the corresponding
#' `input$<id>` stays `NULL` until the user first touches the widget, unlike
#' standard Shiny inputs which report their value immediately.
#'
#' The send is deferred until `shiny:connected` when the socket is not up yet:
#' htmlwidgets' `renderValue()` runs before the Shiny WebSocket is established,
#' and `Shiny.setInputValue()` called then is silently dropped.
#'
#' @param bindings Named character vector. Names are fully namespaced Shiny
#'   input ids, values are Vue data field names read off the instance, e.g.
#'   `c(my_slider = "value")`.
#' @return An [htmlwidgets::JS()] object for the Vue `mounted` option.
#' @keywords internal
.el_mounted_init <- function(bindings) {
  js_str <- function(x) {
    vapply(x, function(e) as.character(jsonlite::toJSON(e, auto_unbox = TRUE)),
           character(1), USE.NAMES = FALSE)
  }

  sends <- paste(
    sprintf("Shiny.setInputValue(%s, self.%s);", js_str(names(bindings)), bindings),
    collapse = " "
  )

  htmlwidgets::JS(paste0(
    "function() { var self = this; ",
    "var send = function() { ", sends, " }; ",
    "if (window.Shiny && Shiny.shinyapp && ",
    "typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) ",
    "{ send(); } else { $(document).one('shiny:connected', send); } }"
  ))
}

#' Normalise `choices` into option configs
#'
#' Accepts a named vector (`c(Label = value)`), an unnamed vector, or a list
#' already shaped as `list(value = , label = )` items, and returns the list
#' form that `el-option` / `el-radio` / `el-checkbox` iterate over.
#'
#' The named branch deliberately does not require a character vector. It used
#' to, so `c(Beijing = 1, Shanghai = 2)` fell through to the unnamed branch:
#' the labels were lost (rendered as "1" and "2") and the surviving names
#' turned the serialised JSON into an object rather than the array `v-for`
#' expects.
#'
#' @param choices A named vector, an unnamed vector, or a list of configs.
#' @return An unnamed list of `list(value = , label = )` items.
#' @keywords internal
.el_normalize_choices <- function(choices) {
  # A list is assumed to be in option shape already.
  if (is.list(choices)) return(choices)

  if (!is.null(names(choices))) {
    return(mapply(
      function(label, value) list(value = value, label = label),
      names(choices), unname(choices),
      SIMPLIFY = FALSE, USE.NAMES = FALSE
    ))
  }

  lapply(choices, function(x) list(value = x, label = as.character(x)))
}

#' Build a component's JS handler dependency
#'
#' Every handler is paired with el-update.js, the shared updater it calls.
#' htmltools de-duplicates the shared entry, so listing it here rather than
#' relying on `el_page()` guarantees it is present and loaded first, whatever
#' the page is built from.
#'
#' @param name The component's handler name, e.g. `"input"` for
#'   `el-input-handler.js`.
#' @return A list of htmlDependency objects.
#' @keywords internal
.el_handler_dependency <- function(name) {
  js <- system.file("js", package = "shiny.element")

  list(
    htmltools::htmlDependency(
      name      = "el-update",
      version   = "1.0.0",
      src       = js,
      script    = "el-update.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name      = paste0("el-", name, "-handler"),
      version   = "1.0.0",
      src       = js,
      script    = paste0("el-", name, "-handler.js"),
      all_files = FALSE
    )
  )
}

#' Inline style for a component's Vue mount point
#'
#' Vue mounts onto the `<div id="…_container">` each component renders, but it
#' does not remove that div: it stays in the document as a block-level box.
#' Every component therefore started on its own line, so two buttons or two
#' tags could never sit side by side without wrapping them in a grid.
#'
#' `display: contents` makes the box itself generate no layout, leaving the
#' component to take part in the surrounding flow with its own display — inline
#' for a button, block for an alert. The style is inline rather than in a
#' stylesheet so it cannot be switched off with `el_page(theme_css = NULL)`.
#'
#' @return A CSS declaration string.
#' @keywords internal
.el_host_style <- function() {
  "display: contents"
}

#' Vue binding for a prop that may be unset
#'
#' Element UI's props fall back to their own defaults when passed `undefined`,
#' but treat `null` as a value: an `el-select` bound to a null placeholder
#' renders an empty one instead of "请选择". R has no way to send `undefined`
#' through JSON, so an unsupplied field arrives as `null` and the expression
#' has to map it back.
#'
#' A conditional is used rather than `??` because a template expression is
#' evaluated at runtime, where a polyfill cannot help with syntax.
#'
#' @param field Name of the Vue data field.
#' @return A template expression yielding the field, or `undefined` when unset.
#' @keywords internal
.el_optional_bind <- function(field) {
  sprintf("%1$s === null ? undefined : %1$s", field)
}
