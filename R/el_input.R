#' Element UI Input with Vue Instance
#'
#' Creates an Element UI input component (`<el-input>`) with a Vue instance,
#' supporting text, textarea, and password modes, plus clearable, prefix/suffix
#' icons, word-limit display, and autosize textarea.
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param value Initial input value. Default `""`.
#' @param placeholder Placeholder text. `NULL` means no placeholder attribute.
#' @param type Input type: `"text"` (default), `"textarea"`, `"password"`.
#' @param size Input size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param disabled Whether the input is disabled. Default `FALSE`.
#' @param readonly Whether the input is read-only. Default `FALSE`.
#' @param clearable Whether to show a clear button. Default `FALSE`.
#' @param show_password Whether to show the password toggle icon.
#'   Only meaningful when `type = "password"`. Default `FALSE`.
#' @param show_word_limit Whether to show a word-count badge.
#'   Requires `maxlength` to be set. Default `FALSE`.
#' @param maxlength Maximum character count. `NULL` means no limit.
#' @param rows Number of rows for `type = "textarea"`. `NULL` uses the default.
#' @param autosize Whether to auto-size the textarea height. Either `TRUE`/`FALSE`
#'   or a named list `list(minRows = 2, maxRows = 4)`. Default `FALSE`.
#' @param prefix_icon Icon class for the prefix slot (e.g. `"el-icon-search"`).
#'   `NULL` means no icon.
#' @param suffix_icon Icon class for the suffix slot (e.g. `"el-icon-date"`).
#'   `NULL` means no icon.
#' @param label ARIA `label` attribute for accessibility. `NULL` omits it.
#' @param session Shiny session for module support.
#' @param autocomplete Native `autocomplete` attribute. Default `"off"`.
#' @param autofocus Whether the input takes focus on page load. Default `FALSE`.
#' @param name Native `name` attribute.
#' @param form Native `form` attribute.
#' @param minlength Minimum input length.
#' @param max Native `max` attribute, for number-like types.
#' @param min Native `min` attribute, for number-like types.
#' @param step Native `step` attribute, for number-like types.
#' @param resize Resize behaviour of a textarea: `"none"`, `"both"`, `"horizontal"` or `"vertical"`.
#' @param tabindex Tab index of the input.
#' @param validate_event Whether a change triggers form validation. Default `TRUE`.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `blur()` -- Blur the input element
#' - `focus()` -- Focus the input element
#' - `select()` -- Select the text in input element
#'
#' @return An `htmltools` tagList with a Vue-managed input component.
#'
#' @section Shiny input:
#' `input$<id>` — string value of the input, updated on `change` event
#' (triggered on blur or Enter key press).
#'
#' @examples
#' # Basic text input
#' el_input("name", placeholder = "Enter your name")
#'
#' # Clearable search input with icon
#' el_input("search", placeholder = "Search...",
#'          clearable = TRUE, prefix_icon = "el-icon-search")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_input("txt", placeholder = "Type something"),
#'     verbatimTextOutput("val")
#'   )
#'   server <- function(input, output, session) {
#'     output$val <- renderPrint(input$txt)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_input <- function(
    id              = NULL,
    value           = "",
    placeholder     = NULL,
    type            = "text",
    size            = NULL,
    disabled        = FALSE,
    readonly        = FALSE,
    clearable       = FALSE,
    show_password   = FALSE,
    show_word_limit = FALSE,
    maxlength       = NULL,
    rows            = NULL,
    autosize        = FALSE,
    prefix_icon     = NULL,
    suffix_icon     = NULL,
    label           = NULL,
    autocomplete    = NULL,
    autofocus       = NULL,
    name            = NULL,
    form            = NULL,
    minlength       = NULL,
    max             = NULL,
    min             = NULL,
    step            = NULL,
    resize          = NULL,
    tabindex        = NULL,
    validate_event  = NULL,
    width           = NULL,
    slots           = NULL,
    session         = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_input_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Always-present Vue binding attributes
  input_attrs <- list(
    "v-model"          = "value",
    ":type"            = "type",
    ":disabled"        = "disabled",
    ":readonly"        = "readonly",
    ":clearable"       = "clearable",
    ":show-password"   = "showPassword",
    ":show-word-limit" = "showWordLimit",
    ":autosize"        = "autosize",
    ":prefix-icon"     = "prefixIcon",
    ":suffix-icon"     = "suffixIcon",
    "@change"          = "handleChange"
  )

  # Conditional attributes (only add when not NULL)
  input_attrs[[":size"]] <- .el_optional_bind("size")
  input_attrs[[":maxlength"]] <- .el_optional_bind("maxlength")
  input_attrs[[":rows"]] <- .el_optional_bind("rows")
  input_attrs[[":placeholder"]] <- .el_optional_bind("placeholder")
  input_attrs[[":label"]] <- .el_optional_bind("label")
  input_attrs[[":autocomplete"]] <- .el_optional_bind("autocomplete")
  input_attrs[[":autofocus"]] <- .el_optional_bind("autofocus")
  input_attrs[[":name"]] <- .el_optional_bind("name")
  input_attrs[[":form"]] <- .el_optional_bind("form")
  input_attrs[[":minlength"]] <- .el_optional_bind("minlength")
  input_attrs[[":max"]] <- .el_optional_bind("max")
  input_attrs[[":min"]] <- .el_optional_bind("min")
  input_attrs[[":step"]] <- .el_optional_bind("step")
  input_attrs[[":resize"]] <- .el_optional_bind("resize")
  input_attrs[[":tabindex"]] <- .el_optional_bind("tabindex")
  input_attrs[[":validate-event"]] <- .el_optional_bind("validateEvent")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "input",
    "blur",
    "focus",
    "clear"
  ))
  input_attrs <- c(input_attrs, events$attrs)
  # Always-present Vue data fields
  vue_data <- list(
    value         = value,
    type          = type,
    disabled      = disabled,
    readonly      = readonly,
    clearable     = clearable,
    showPassword  = show_password,
    showWordLimit = show_word_limit,
    autosize      = autosize,
    prefixIcon    = prefix_icon,
    suffixIcon    = suffix_icon
  )

  # Conditional data fields (only add when not NULL)
  vue_data$size <- if (is.null(size)) NA else size
  vue_data$maxlength <- .el_or_na(maxlength)
  vue_data$rows <- .el_or_na(rows)
  vue_data$placeholder <- if (is.null(placeholder)) NA else placeholder
  vue_data$label <- .el_or_na(label)
  vue_data$autocomplete <- .el_or_na(autocomplete)
  vue_data$autofocus <- .el_or_na(autofocus)
  vue_data$name <- .el_or_na(name)
  vue_data$form <- .el_or_na(form)
  vue_data$minlength <- .el_or_na(minlength)
  vue_data$max <- .el_or_na(max)
  vue_data$min <- .el_or_na(min)
  vue_data$step <- .el_or_na(step)
  vue_data$resize <- .el_or_na(resize)
  vue_data$tabindex <- .el_or_na(tabindex)
  vue_data$validateEvent <- .el_or_na(validate_event)
  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-input", input_attrs),
    data    = vue_data,
    methods = c(events$methods, list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(value) { Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    )),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots,
    dependency = el_input_handler_dependency()
  )
}


#' Update Element UI Input
#'
#' Server-side update for [el_input()]. Sends a custom message to update
#' named fields on the Vue instance.
#'
#' @param session Shiny session object.
#' @param id Input ID (un-namespaced).
#' @param value New value string.
#' @param placeholder New placeholder text.
#' @param disabled New disabled state.
#' @param readonly New readonly state.
#' @param type New input type.
#' @param size New input size.
#' @param clearable New clearable state.
#' @param show_password New show-password toggle state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_input(session, "name", value = "Ada")
#'   })
#' }
#' @export
update_el_input <- function(
    session,
    id,
    value        = NULL,
    placeholder  = NULL,
    disabled     = NULL,
    readonly     = NULL,
    type         = NULL,
    size         = NULL,
    clearable    = NULL,
    show_password = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))        msg$value        <- value
  if (!is.null(placeholder))  msg$placeholder  <- placeholder
  if (!is.null(disabled))     msg$disabled     <- disabled
  if (!is.null(readonly))     msg$readonly     <- readonly
  if (!is.null(type))         msg$type         <- type
  if (!is.null(size))         msg$size         <- size
  if (!is.null(clearable))    msg$clearable    <- clearable
  if (!is.null(show_password)) msg$showPassword <- show_password
  session$sendCustomMessage("updateElInput", msg)
  invisible(NULL)
}


#' Input Handler Dependency
#' @keywords internal
el_input_handler_dependency <- function() {
  .el_handler_dependency("input")
}
