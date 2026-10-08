#' Element Plus Infinite Scroll
#'
#' A scrolling area that asks the server for more as the user nears the
#' bottom. Element implements this as a directive rather than a component, so
#' the area is a container you put content into.
#'
#' @param id Container ID. Auto-generated if `NULL`.
#' @param ... Content of the scrolling area. Any Shiny UI, including
#'   shiny.element components -- those are folded into this container's Vue
#'   instance rather than nested inside it, so their inputs keep reporting.
#'   Their `update_el_*()` no longer reaches them, though.
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
#' @param session In `el_infinite_scroll()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_infinite_scroll()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
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
el_infinite_scroll <- function(
  id = NULL,
  ...,
  height = "300px",
  disabled = NULL,
  delay = NULL,
  distance = NULL,
  immediate = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  # Each piece of content is absorbed on its own, so several components
  # may sit in the same scrolling area.
  inners <- lapply(list(...), .el_absorb)

  if (is.null(id)) {
    id <- .el_auto_id("el_infinite_scroll")
  }
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    "v-infinite-scroll" = "handleLoad",
    ":infinite-scroll-disabled" = "scrollDisabled",
    ":infinite-scroll-delay" = .el_optional_bind("scrollDelay"),
    ":infinite-scroll-distance" = .el_optional_bind("scrollDistance"),
    ":infinite-scroll-immediate" = .el_optional_bind("scrollImmediate"),
    style = paste0("overflow: auto; height: ", shiny::validateCssUnit(height))
  )

  own <- list(
    markup = NULL,
    data = list(
      scrollDisabled = if (is.null(disabled)) FALSE else disabled,
      scrollDelay = .el_or_na(delay),
      scrollDistance = .el_or_na(distance),
      scrollImmediate = .el_or_na(immediate),
      scrollCount = 0L
    ),
    methods = list(
      handleLoad = JS(sprintf(
        "function() { this.scrollCount++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_load', this.scrollCount); }",
        ns_id
      ))
    ),
    watch = list(),
    computed = list(),
    mounted = NULL,
    dependencies = list()
  )
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  el_widget(
    id = ns_id,
    markup = htmltools::tag("div", c(attrs, merged$markups[-1])),
    data = merged$data,
    absorbed = merged$absorbed,
    methods = merged$methods,
    watch = merged$watch,
    computed = merged$computed,
    mounted = merged$mounted,
    width = width,
    slots = slots,
    dependency = merged$dependencies
  )
}


#' @rdname el_infinite_scroll
#' @section Updating from the server:
#' Server-side update for [el_infinite_scroll()]. Setting `disabled` is how a
#' feed stops asking once everything has been sent.
#'
#' `update_el_infinite_scroll()` is called for its side effect and returns `NULL` invisibly.
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
update_el_infinite_scroll <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  delay = NULL,
  distance = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  # The area's fields carry a prefix, kept apart from its content's
  if (!is.null(disabled)) {
    msg$scrollDisabled <- disabled
  }
  if (!is.null(delay)) {
    msg$scrollDelay <- delay
  }
  if (!is.null(distance)) {
    msg$scrollDistance <- distance
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
