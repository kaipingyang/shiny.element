#' Element UI Button with Vue Instance
#'
#' Creates an Element UI button with Vue instance, supporting all Element UI
#' button variants including `plain`, `round`, `circle`, and `loading` states.
#'
#' @param id Button ID. Auto-generated UUID if `NULL`.
#' @param label Button text. Ignored (and defaults to `""`) when `circle = TRUE`.
#' @param type Button type: `"default"`, `"primary"`, `"success"`, `"warning"`,
#'   `"danger"`, `"info"`, `"text"`.
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param plain Whether to use the plain (hollow) style. Default `FALSE`.
#' @param round Whether to use rounded corners. Default `FALSE`.
#' @param circle Whether to render as a circle button (icon only, no label).
#'   Default `FALSE`.
#' @param loading Whether to show loading spinner. Disables click while active.
#'   Default `FALSE`.
#' @param disabled Whether the button is disabled. Default `FALSE`.
#' @param icon Either an Element icon class name such as `"el-icon-search"`,
#'   which Element renders itself and [update_el_button()] can change, or a tag
#'   (for example from [el_icon()]), which is inserted as button content.
#' @param native_type HTML native button type: `"button"` (default), `"submit"`,
#'   `"reset"`.
#' @param auto_insert_space Automatically insert a space between two chinese
#'   characters(this will only take effect when the text length is 2 and all
#'   characters are in Chinese.). Element Plus's `auto-insert-space`
#'   (boolean).
#' @param bg Determine whether the text button background color is always on.
#'   Element Plus's `bg` (boolean).
#' @param color Custom button color, automatically calculate `hover` and
#'   `active` color. Works with `link`/`text` buttons since. Element
#'   Plus's `color` (string).
#' @param dark Dark mode, which automatically converts `color` to dark mode
#'   colors. Element Plus's `dark` (boolean).
#' @param dashed Determine whether it's a dashed button. Element Plus's
#'   `dashed` (boolean).
#' @param link Determine whether it's a link button. Element Plus's `link`
#'   (boolean).
#' @param loading_icon Customize loading icon component. Element Plus's
#'   `loading-icon` (string / Component). An icon's name, such as `"Search"`.
#' @param tag Custom element tag. Element Plus's `tag` (string / Component).
#'   An icon's name, such as `"Search"`.
#' @param text Determine whether it's a text button. Element Plus's `text`
#'   (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param autofocus Whether the button takes focus on page load. Default `FALSE`.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed button component.
#'
#' @section Shiny inputs:
#' `input$<id>` -- the number of clicks, as [shiny::actionButton()] reports
#' it: 0 on load, and counted only while neither `disabled` nor `loading` is
#' `TRUE`. It carries the same class, so `observeEvent()` and `req()` treat 0
#' as not yet clicked.
#'
#' @examples
#' # Basic usage
#' el_button("btn_primary", "Primary", type = "primary")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_button("btn1", "Primary", type = "primary"),
#'     verbatimTextOutput("count")
#'   )
#'   server <- function(input, output, session) {
#'     output$count <- renderPrint(input$btn1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_button <- function(
    id          = NULL,
    auto_insert_space = NULL,
    bg = NULL,
    color = NULL,
    dark = NULL,
    dashed = NULL,
    link = NULL,
    loading_icon = NULL,
    tag = NULL,
    text = NULL,
    label       = "Button",
    type        = "default",
    size        = NULL,
    plain       = FALSE,
    round       = FALSE,
    circle      = FALSE,
    loading     = FALSE,
    disabled    = FALSE,
    icon        = NULL,
    native_type = "button",
    autofocus   = FALSE,
    width       = NULL,
    slots       = NULL,
    session     = NULL
) {
  .el_check_choices("el_button", environment())
  if (is.null(id)) id <- paste0("el_button_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  # circle buttons show no label
  if (circle) label <- ""

  # Vue binding attributes
  btn_attrs <- list(
    ":type"        = "type",
    ":plain"       = "plain",
    ":round"       = "round",
    ":circle"      = "circle",
    ":loading"     = "loading",
    ":disabled"    = "disabled",
    ":native-type" = "native_type",
    "@click"       = "handleClick"
  )
  btn_attrs[[":size"]] <- .el_optional_bind("size")
  # Upstream's `icon` is an Element icon class name. A tag is accepted too, and
  # goes in as content, which is how a fontawesome icon from el_icon() lands
  # here -- but only a class name can be changed later by update_el_button().
  btn_attrs[[":icon"]] <- .el_optional_bind("icon")
  btn_attrs[[":autofocus"]] <- .el_optional_bind("autofocus")
  btn_content <- shiny::tagList(
    if (inherits(icon, "shiny.tag")) icon,
    "{{label}}"
  )

  el_widget(
    props = .el_props(list(
      auto_insert_space = auto_insert_space,
      bg = bg,
      color = color,
      dark = dark,
      dashed = dashed,
      link = link,
      loading_icon = .el_icon_name(loading_icon),
      tag = .el_icon_name(tag),
      text = text)),
    id     = ns_id,
    markup = htmltools::tag("el-button", append(btn_attrs, btn_content)),
    data = list(
      label       = label,
      type        = type,
      size        = size,
      plain       = plain,
      round       = round,
      circle      = circle,
      loading     = loading,
      disabled    = disabled,
      native_type = native_type,
      icon        = if (is.character(icon)) icon else NA,
      count       = 0L,
      autofocus   = .el_or_na(autofocus)
    ),
    methods = list(
      # The binding reports the count; this send is for when the button is
      # absorbed into a wrapper and has no binding of its own
      handleClick = JS(sprintf(paste0(
        "function() { if (this.disabled || this.loading) return; this.count++; ",
        "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s:shiny.action', this.count); }"),
        ns_id))
    ),
    # An action button, as actionButton() is: 0 on load, classed so that
    # observeEvent() and req() treat 0 as not yet clicked
    mounted    = .el_mounted_init(stats::setNames("count", ns_id)),
    type       = "shiny.action",
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Button
#'
#' Server-side update for [el_button()]. Supports all visual states including
#' `size`, `plain`, `round`, and `loading`.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Button ID (un-namespaced).
#' @param label New label text.
#' @param type New button type.
#' @param size New button size.
#' @param plain New plain state.
#' @param round New round state.
#' @param loading New loading state.
#' @param disabled New disabled state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_button(session, "save", loading = TRUE)
#'   })
#' }
#' @export
update_el_button <- function(
    session = shiny::getDefaultReactiveDomain(),
    id,
    label    = NULL,
    type     = NULL,
    size     = NULL,
    plain    = NULL,
    round    = NULL,
    loading  = NULL,
    disabled = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(label))    msg$label    <- label
  if (!is.null(type))     msg$type     <- type
  if (!is.null(size))     msg$size     <- size
  if (!is.null(plain))    msg$plain    <- plain
  if (!is.null(round))    msg$round    <- round
  if (!is.null(loading))  msg$loading  <- loading
  if (!is.null(disabled)) msg$disabled <- disabled
  .el_send_update(session, msg)
  invisible(NULL)
}
