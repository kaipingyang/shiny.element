#' Element UI Checkbox
#'
#' One box, ticked or not -- Shiny's [shiny::checkboxInput()], drawn by
#' Element. For several choices, [el_checkbox_group()].
#'
#' @param id Checkbox ID. Auto-generated if `NULL`.
#' @param label The box's text, as for [shiny::checkboxInput()].
#' @param value Whether the box starts ticked. Default `FALSE`.
#' @param indeterminate Show the box half-ticked -- the "check all" box
#'   above a partly checked group. Only the look: `value` is unchanged.
#' @param disabled Whether the box is disabled.
#' @param border Draw the box with a border.
#' @param size `"medium"`, `"small"` or `"mini"`; only with `border = TRUE`.
#' @param true_label,false_label Values to report instead of `TRUE` and
#'   `FALSE`.
#' @param name Native `name` attribute.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents; the default slot
#'   replaces `label`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- `TRUE` or `FALSE` (or `true_label` and `false_label`),
#'   on load and on change.
#'
#' @return A Shiny UI element.
#' @examples
#' el_checkbox("agree", "I agree to the terms")
#'
#' # The "check all" box above a group
#' el_checkbox("all", "Check all", indeterminate = TRUE)
#'
#' el_checkbox("remember", "Remember me", value = TRUE, border = TRUE)
#' @export
el_checkbox <- function(id = NULL,
                        label = NULL,
                        value = FALSE,
                        indeterminate = NULL,
                        disabled = NULL,
                        border = NULL,
                        size = NULL,
                        true_label = NULL,
                        false_label = NULL,
                        name = NULL,
                        width = NULL,
                        slots = NULL,
                        session = NULL) {
  .el_check_choices("el_checkbox", environment())
  if (is.null(id)) id <- paste0("el_checkbox_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list("v-model" = "value", "@change" = "handleChange")
  fields <- list(indeterminate = indeterminate, disabled = disabled, border = border,
                 size = size, trueLabel = true_label, falseLabel = false_label,
                 name = name)
  for (f in names(fields)) attrs[[paste0(":", .el_kebab_case(f))]] <- .el_optional_bind(f)

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-checkbox", c(attrs, list("{{ text }}"))),
    data   = c(list(value = value, text = if (is.null(label)) "" else label),
               lapply(fields, .el_or_na)),
    methods = list(
      handleChange = JS(sprintf(
        "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }", ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width   = width,
    slots   = slots
  )
}


#' Update Element UI Checkbox
#'
#' Server-side update for [el_checkbox()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateCheckboxInput()].
#' @param id Checkbox ID (un-namespaced).
#' @param value Whether the box is ticked.
#' @param label The box's new text.
#' @param indeterminate,disabled New states; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function: the "check all" box follows the group
#'   observeEvent(input$cities, {
#'     n <- length(input$cities)
#'     update_el_checkbox(session, "all", value = n == 4,
#'                        indeterminate = n > 0 && n < 4)
#'   }, ignoreNULL = FALSE)
#' }
#' @export
update_el_checkbox <- function(session = shiny::getDefaultReactiveDomain(), id,
                               value = NULL, label = NULL, indeterminate = NULL,
                               disabled = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value))         msg$value         <- value
  if (!is.null(label))         msg$text          <- label
  if (!is.null(indeterminate)) msg$indeterminate <- indeterminate
  if (!is.null(disabled))      msg$disabled      <- disabled
  .el_send_update(session, msg)
  invisible(NULL)
}
