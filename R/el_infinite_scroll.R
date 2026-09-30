#' Element UI Infinite Scroll
#'
#' A scrolling area that asks the server for more as the user nears the
#' bottom. Element implements this as a directive rather than a component, so
#' the area is a container you put content into.
#'
#' @param id Container ID. Auto-generated if `NULL`.
#' @param ... Content of the scrolling area. Markup only -- raw Element tags
#'   from [el], or ordinary Shiny UI. It cannot contain another shiny.element
#'   component: the container compiles this into its own Vue instance, which
#'   would discard a mounted one.
#' @param height Height of the area, as a CSS unit. Needed for it to scroll at
#'   all. Default `"300px"`.
#' @param disabled Whether loading is suspended. Set it from the server while
#'   a request is in flight, and again when there is nothing left to fetch.
#' @param delay Throttle between checks, in milliseconds. Default `200`.
#' @param distance How near the bottom to get before asking, in pixels.
#'   Default `0`.
#' @param immediate Whether to ask once on load, in case the content does not
#'   fill the area. Default `TRUE`.
#' @param width Component width, as a CSS unit.
#' @param session Shiny session for module support.
#'
#' @section Shiny inputs:
#' - `input$<id>_load` -- rises by one each time more content is wanted.
#'   Observe it, fetch the next page, and render it into a [shiny::uiOutput()]
#'   inside the area.
#'
#' @return A Shiny UI element.
#' @examples
#' el_infinite_scroll("feed", shiny::uiOutput("rows"), height = "400px")
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'
#'   ui <- el_page(el_infinite_scroll("feed", uiOutput("rows")))
#'
#'   server <- function(input, output, session) {
#'     shown <- reactiveVal(20)
#'     observeEvent(input$feed_load, {
#'       shown(min(shown() + 20, nrow(iris)))
#'     })
#'     output$rows <- renderUI({
#'       lapply(seq_len(shown()), function(i) tags$p(paste("Row", i)))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_infinite_scroll <- function(id = NULL,
                               ...,
                               height = "300px",
                               disabled = NULL,
                               delay = NULL,
                               distance = NULL,
                               immediate = NULL,
                               width = NULL,
                               session = shiny::getDefaultReactiveDomain()) {
  content <- .el_reject_widgets(list(...), "...", "el_infinite_scroll")

  if (is.null(id)) id <- paste0("el_infinite_scroll_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  attrs <- list(
    "v-infinite-scroll"           = "handleLoad",
    ":infinite-scroll-disabled"   = "disabled",
    ":infinite-scroll-delay"      = .el_optional_bind("delay"),
    ":infinite-scroll-distance"   = .el_optional_bind("distance"),
    ":infinite-scroll-immediate"  = .el_optional_bind("immediate"),
    style = paste0("overflow: auto; height: ", shiny::validateCssUnit(height))
  )

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("div", c(attrs, list(content))),
    data   = list(
      disabled  = if (is.null(disabled)) FALSE else disabled,
      delay     = .el_or_na(delay),
      distance  = .el_or_na(distance),
      immediate = .el_or_na(immediate),
      count     = 0L
    ),
    methods = list(
      handleLoad = htmlwidgets::JS(sprintf(
        "function() { this.count++; Shiny.setInputValue('%s_load', this.count); }",
        ns_id
      ))
    ),
    width      = width,
    dependency = el_infinite_scroll_handler_dependency()
  )
}


#' Update Element UI Infinite Scroll
#'
#' Server-side update for [el_infinite_scroll()]. Setting `disabled` is how a
#' feed stops asking once everything has been sent.
#'
#' @param session Shiny session object.
#' @param id Container ID (un-namespaced).
#' @param disabled,delay,distance New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$feed_load, {
#'     if (all_rows_sent()) {
#'       update_el_infinite_scroll(session, "feed", disabled = TRUE)
#'     }
#'   })
#' }
#' @export
update_el_infinite_scroll <- function(session, id, disabled = NULL,
                                      delay = NULL, distance = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(delay))    msg$delay    <- delay
  if (!is.null(distance)) msg$distance <- distance
  session$sendCustomMessage("updateElInfiniteScroll", msg)
  invisible(NULL)
}


#' @keywords internal
el_infinite_scroll_handler_dependency <- function() {
  .el_handler_dependency("infinite-scroll")
}
