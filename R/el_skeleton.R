#' Element UI Skeleton
#'
#' Grey placeholder shapes shown while content is on its way, then the content
#' itself. In Shiny the usual pattern is to start with `loading = TRUE` and
#' switch it off from the server once the work is done.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param ... The real content, shown once `loading` is `FALSE`. A
#'   shiny.element component here is absorbed, not nested.
#' @param loading Whether to show the placeholder. Default `TRUE`.
#' @param rows Number of placeholder lines. Default `3`.
#' @param animated Whether the placeholder shimmers.
#' @param count How many copies of the placeholder to show.
#' @param throttle Delay in milliseconds before the placeholder appears, so
#'   a fast load does not flash it.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. `template` replaces the
#'   placeholder's shape; build it from `el$skeleton_item(variant = ...)`.
#' @param session Shiny session for module support.
#'
#' @return A Shiny UI element.
#' @examples
#' el_skeleton("report", rows = 4, animated = TRUE,
#'             shiny::tableOutput("summary"))
#'
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(el_skeleton("report", animated = TRUE, tableOutput("summary")))
#'   server <- function(input, output, session) {
#'     output$summary <- renderTable({
#'       Sys.sleep(2)
#'       on.exit(update_el_skeleton(session, "report", loading = FALSE))
#'       head(mtcars)
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_skeleton <- function(id = NULL,
                        ...,
                        loading = TRUE,
                        rows = NULL,
                        animated = NULL,
                        count = NULL,
                        throttle = NULL,
                        width = NULL,
                        slots = NULL,
                        session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_skeleton_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  own <- list(
    markup = NULL,
    data = list(
      skLoading  = loading,
      skRows     = .el_or_na(rows),
      skAnimated = .el_or_na(animated),
      skCount    = .el_or_na(count),
      skThrottle = .el_or_na(throttle)
    ),
    methods = list(), watch = list(), computed = list(), mounted = NULL,
    dependencies = list()
  )
  inners <- lapply(list(...), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  attrs <- list(
    ":loading"  = "skLoading",
    ":rows"     = .el_optional_bind("skRows"),
    ":animated" = .el_optional_bind("skAnimated"),
    ":count"    = .el_optional_bind("skCount"),
    ":throttle" = .el_optional_bind("skThrottle")
  )
  content <- merged$markups[-1]
  children <- if (length(content)) list(htmltools::tag("div", content)) else list()

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-skeleton", c(attrs, children)),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots    = slots,
    dependency = c(el_skeleton_handler_dependency(), merged$dependencies)
  )
}


#' Update Element UI Skeleton
#'
#' Server-side update for [el_skeleton()]. `loading = FALSE` swaps the
#' placeholder for the real content.
#'
#' @param session Shiny session object.
#' @param id Component ID (un-namespaced).
#' @param loading,rows New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(result(), {
#'     update_el_skeleton(session, "report", loading = FALSE)
#'   })
#' }
#' @export
update_el_skeleton <- function(session, id, loading = NULL, rows = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(loading)) msg$skLoading <- loading
  if (!is.null(rows))    msg$skRows    <- rows
  session$sendCustomMessage("updateElSkeleton", msg)
  invisible(NULL)
}


#' @keywords internal
el_skeleton_handler_dependency <- function() {
  .el_handler_dependency("skeleton")
}
