#' Element Plus Config Provider
#'
#' Settings for the components inside it: their size, the button and link
#'   defaults, the dialog's and message's, the empty values. The page's own --
#'   locale, size, z-index -- are el_page()'s.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param size Global component size. Element Plus's `size` ('large' |
#'   'default' | 'small').
#' @param button Button related configuration, see the following table.
#'   Element Plus's `button` (object).
#' @param link Link related configuration, see the following table. Element
#'   Plus's `link` (`{type?: string, underline?: boolean | string}`).
#' @param dialog Dialog related configuration, see the following table.
#'   Element Plus's `dialog` (object).
#' @param message Message related configuration, see the following table.
#'   Element Plus's `message` (`{max?: number}`).
#' @param experimental_features Features at experimental stage to be added,
#'   all features are default to be set to false. Element Plus's
#'   `experimental-features` (object).
#' @param empty_values Global empty values of components. Element Plus's
#'   `empty-values` (array).
#' @param value_on_clear Global clear return value. Element Plus's
#'   `value-on-clear` (string / number / boolean / Function). Give it as
#'   [JS()].
#' @param table Table related configuration, see the following table. Element
#'   Plus's `table` (object). Give it as [JS()].
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' None: it reports nothing.
#'
#' @return A Shiny UI element.
#' @examples
#' el_config_provider(
#'   size = "small",
#'   button = list(autoInsertSpace = TRUE),
#'   el_button("a", "OK"),
#'   el_input("b")
#' )
#' @export
el_config_provider <- function(
  ...,
  id = NULL,
  size = NULL,
  button = NULL,
  link = NULL,
  dialog = NULL,
  message = NULL,
  experimental_features = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  table = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_config_provider", environment())
  if (is.null(id)) {
    id <- paste0("el_config_provider_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  .el_wrap_widget(
    "el-config-provider",
    ns_id,
    list(...),
    props = .el_props(list(
      size = size,
      button = button,
      link = link,
      dialog = dialog,
      message = message,
      experimental_features = experimental_features,
      empty_values = empty_values,
      value_on_clear = value_on_clear,
      table = table
    )),
    events = events,
    width = width,
    slots = slots
  )
}
