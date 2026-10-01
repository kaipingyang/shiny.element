#' Element UI Button with Vue Instance
#'
#' Creates an Element UI button with Vue instance, supporting all Element UI
#' button variants including `plain`, `round`, `circle`, and `loading` states.
#'
#' @param id Button ID. Auto-generated UUID if `NULL`.
#' @param label Button text. Ignored (and defaults to `""`) when `circle = TRUE`.
#' @param type Button type: `"default"`, `"primary"`, `"success"`, `"warning"`,
#'   `"danger"`, `"info"`, `"text"`.
#' @param size Button size: `NULL`, `"medium"`, `"small"`, `"mini"`.
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
#' @param session Shiny session for module support.
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
#' @section Shiny input:
#' `input$<id>` — click count (integer), incremented on each click when neither
#' `disabled` nor `loading` is `TRUE`.
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
    session     = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_button_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
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
      handleClick = htmlwidgets::JS(sprintf(
        "function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('%s', this.count); } }",
        ns_id
      ))
    ),
    width      = width,
    slots      = slots,
    dependency = el_button_handler_dependency()
  )
}


#' Update Element UI Button
#'
#' Server-side update for [el_button()]. Supports all visual states including
#' `size`, `plain`, `round`, and `loading`.
#'
#' @param session Shiny session object.
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
    session,
    id,
    label    = NULL,
    type     = NULL,
    size     = NULL,
    plain    = NULL,
    round    = NULL,
    loading  = NULL,
    disabled = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(label))    msg$label    <- label
  if (!is.null(type))     msg$type     <- type
  if (!is.null(size))     msg$size     <- size
  if (!is.null(plain))    msg$plain    <- plain
  if (!is.null(round))    msg$round    <- round
  if (!is.null(loading))  msg$loading  <- loading
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElButton", msg)
  invisible(NULL)
}
