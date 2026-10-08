#' Element Plus Config Provider
#'
#' Settings for the components inside it: their size, the button and link
#'   defaults, the card's, the dialog's and message's, the empty values, and
#'   their language. The page's own -- its locale, size, z-index -- are
#'   el_page()'s.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param locale The language of the components inside it, as
#'   [el_locale_dependency()] names one (`"zh-cn"`), where `el_page(locale =)`
#'   sets the page's. Element Plus's `locale`.
#' @param card Card related configuration: `list(shadow = "hover")`, for the
#'   cards inside it that set no shadow of their own. Element Plus's `card`.
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
  locale = NULL,
  size = NULL,
  button = NULL,
  link = NULL,
  dialog = NULL,
  message = NULL,
  experimental_features = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  table = NULL,
  card = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_config_provider", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_config_provider")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  # The provider's own scope: el_card() and el_dialog() are markup, which
  # Element's ConfigProvider does not reach, and take its card and dialog
  # settings from these attributes (el-events.js)
  scope <- htmltools::tags$div(
    class = "el-provider-scope",
    style = "display: contents",
    `:data-card-shadow` = "card && card.shadow ? card.shadow : ''",
    `:data-dialog` = "dialog ? JSON.stringify(dialog) : ''",
    ...
  )
  widget <- .el_wrap_widget(
    "el-config-provider",
    ns_id,
    list(scope),
    attrs = list(":locale" = "$elLocale(locale)"),
    data = list(locale = if (is.null(locale)) NA else tolower(locale)),
    props = .el_props(list(
      card = card,
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
  # the locale's file, and English's, to go back to with an update
  if (is.null(locale)) {
    return(widget)
  }
  htmltools::attachDependencies(
    widget,
    lapply(unique(c(tolower(locale), "en")), .el_locale_file),
    append = TRUE
  )
}

#' A locale's file alone, English's included
#'
#' [el_locale_dependency()] also makes the locale the page's; a config
#' provider needs only the object the file defines, `ElementPlusLocaleZhCn`.
#' @param code A locale code, `"zh-cn"`.
#' @return An htmlDependency.
#' @keywords internal
.el_locale_file <- function(code) {
  root <- system.file("element-plus", package = "shiny.element")
  if (
    !file.exists(file.path(root, "dist", "locale", paste0(code, ".min.js")))
  ) {
    stop(
      "No bundled locale '",
      code,
      "'. Element Plus ships these: ",
      paste(el_locales(), collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  htmltools::htmlDependency(
    name = paste0("element-plus-locale-", code),
    version = "2.14.7",
    src = root,
    script = paste0("dist/locale/", code, ".min.js"),
    all_files = FALSE
  )
}


#' @rdname el_config_provider
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @section Updating from the server:
#' `update_el_config_provider()` changes the component from the server: every argument of
#' [el_config_provider()] that can change once it is drawn, under the same name. One left
#' `NULL` stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_config_provider()` is called for its side effect and returns `NULL` invisibly.
#' @export
update_el_config_provider <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  locale = NULL,
  card = NULL,
  size = NULL,
  button = NULL,
  link = NULL,
  dialog = NULL,
  message = NULL,
  experimental_features = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  table = NULL
) {
  .el_check_session(session)
  # a locale whose file is on the page: the one el_config_provider() was
  # given, or English
  if (!is.null(locale)) {
    .el_send_update(
      session,
      list(id = session$ns(id), locale = tolower(locale))
    )
  }
  .el_send_props_update(
    session,
    id,
    "el_config_provider",
    list(
      card = card,
      size = size,
      button = button,
      link = link,
      dialog = dialog,
      message = message,
      experimental_features = experimental_features,
      empty_values = empty_values,
      value_on_clear = value_on_clear,
      table = table
    )
  )
}
