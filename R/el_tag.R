#' Element UI Tag
#'
#' Creates a styled tag/chip component. Tracks click and close events as
#' Shiny inputs.
#'
#' @param id Tag ID. Auto-generated UUID if `NULL`.
#' @param label Tag text.
#' @param type Tag colour: `NULL` (default blue), `"success"`, `"info"`,
#'   `"warning"`, `"danger"`.
#' @param closable Whether to show a close button. Default `FALSE`. When
#'   `TRUE`, `input$<id>_closed` fires once when the user closes the tag.
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param effect Visual effect: `"light"` (default), `"dark"`, `"plain"`.
#' @param color Custom background colour (CSS string). `NULL` for themed colour.
#' @param hit Whether to show a solid border. Default `FALSE`.
#' @param disable_transitions Disable the zoom-in-center animation. Default `FALSE`.
#' @param round Whether Tag is rounded. Element Plus's `round` (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed tag component.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the number of clicks on the tag's body, as
#'   [shiny::actionButton()] reports it: 0 on load, treated by
#'   `observeEvent()` and `req()` as not yet clicked.
#' - `input$<id>_closed` — set to `1` when the user clicks the close button
#'   (only meaningful when `closable = TRUE`).
#'
#' @examples
#' el_tag("tag1", "Success", type = "success")
#' el_tag("tag2", "Closable", closable = TRUE)
#'
#' @export
el_tag <- function(
    id                   = NULL,
    label                = "Tag",
    type                 = NULL,
    closable             = FALSE,
    size                 = NULL,
    effect               = "light",
    color                = NULL,
    hit                  = FALSE,
    disable_transitions  = FALSE,
    round = NULL,
    width                = NULL,
    slots                = NULL,
    session              = NULL
) {
  .el_check_choices("el_tag", environment())
  if (is.null(id)) id <- paste0("el_tag_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  tag_attrs <- list(
    ":type"                = "type",
    ":closable"            = "closable",
    ":effect"             = "effect",
    ":hit"                 = "hit",
    ":disable-transitions" = "disableTransitions",
    "@click"               = "handleClick",
    "@close"               = "handleClose"
  )
  tag_attrs[[":size"]] <- .el_optional_bind("size")
  tag_attrs[[":color"]] <- .el_optional_bind("color")
  el_widget(
    props = .el_props(list(
      round = round)),
    id     = ns_id,
    markup = htmltools::tag("el-tag", c(tag_attrs, list("{{label}}"))),
    data = list(
      label              = label,
      type               = type,
      closable           = closable,
      size               = size,
      effect             = effect,
      color              = color,
      hit                = hit,
      disableTransitions = disable_transitions,
      count              = 0L
    ),
    methods = list(
      handleClick = JS(sprintf(paste0(
        "function() { this.count++; ",
        "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s:shiny.action', this.count); }"),
        ns_id)),
      handleClose = JS(sprintf(
        "function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_closed', 1, {priority: 'event'}); }",
        ns_id
      ))
    ),
    # Clicks counted as an action button's are
    mounted    = .el_mounted_init(stats::setNames("count", ns_id)),
    type       = "shiny.action",
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Tag
#'
#' Server-side update for [el_tag()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Tag ID (un-namespaced).
#' @param label New label text.
#' @param type New colour type.
#' @param closable New closable state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_tag(session, "status", label = "done", type = "success")
#'   })
#' }
#' @export
update_el_tag <- function(session = shiny::getDefaultReactiveDomain(), id, label = NULL, type = NULL,
                          closable = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(label))    msg$label    <- label
  if (!is.null(type))     msg$type     <- type
  if (!is.null(closable)) msg$closable <- closable
  .el_send_update(session, msg)
  invisible(NULL)
}


