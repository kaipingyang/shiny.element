#' Element Plus Skeleton
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
#' @param class,style Extra classes and inline style on the skeleton, as
#'   Element passes them to its root: `style = "display: flex; gap: 8px"`
#'   lays several copies of the placeholder side by side.
#' @param slots Named list of Element slot contents. `template` replaces the
#'   placeholder's shape; build it from [el_skeleton_item()].
#' @param session In `el_skeleton()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_skeleton()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @template on
#' @return A Shiny UI element.
#' @examples
#' el_skeleton("report", rows = 4, animated = TRUE, shiny::tableOutput("summary"))
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
el_skeleton <- function(
  id = NULL,
  ...,
  loading = TRUE,
  rows = NULL,
  animated = NULL,
  count = NULL,
  throttle = NULL,
  width = NULL,
  class = NULL,
  style = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- .el_auto_id("el_skeleton")
  }
  ns_id <- .el_ui_id(id, session)

  own <- list(
    markup = NULL,
    data = list(
      skLoading = loading,
      skRows = .el_or_na(rows),
      skAnimated = .el_or_na(animated),
      skCount = .el_or_na(count),
      skThrottle = .el_or_na(throttle)
    ),
    methods = list(),
    watch = list(),
    computed = list(),
    mounted = NULL,
    dependencies = list()
  )
  inners <- lapply(list(...), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  attrs <- list(
    ":loading" = "skLoading",
    ":rows" = .el_optional_bind("skRows"),
    ":animated" = .el_optional_bind("skAnimated"),
    ":count" = .el_optional_bind("skCount"),
    ":throttle" = .el_optional_bind("skThrottle"),
    class = class,
    style = style
  )
  content <- merged$markups[-1]
  children <- if (length(content)) {
    list(htmltools::tag("div", content))
  } else {
    list()
  }

  el_widget(
    id = ns_id,
    markup = htmltools::tag("el-skeleton", c(attrs, children)),
    data = merged$data,
    absorbed = merged$absorbed,
    methods = merged$methods,
    watch = merged$watch,
    computed = merged$computed,
    mounted = merged$mounted,
    width = width,
    slots = slots,
    dependency = merged$dependencies,
    on = on
  )
}


#' @rdname el_skeleton
#' @section Updating from the server:
#' Server-side update for [el_skeleton()]. `loading = FALSE` swaps the
#' placeholder for the real content.
#'
#' `update_el_skeleton()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(result(), {
#'     update_el_skeleton(session, "report", loading = FALSE)
#'   })
#' }
#' @export
update_el_skeleton <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  loading = NULL,
  rows = NULL,
  animated = NULL,
  count = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(loading)) {
    msg$skLoading <- loading
  }
  if (!is.null(rows)) {
    msg$skRows <- rows
  }
  if (!is.null(animated)) {
    msg$skAnimated <- animated
  }
  if (!is.null(count)) {
    msg$skCount <- count
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
