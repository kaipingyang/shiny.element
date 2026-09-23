# 工具函数示例
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
