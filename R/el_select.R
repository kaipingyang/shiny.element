
# Private dependency loader (not exported)

#' Element UI Select Component
#'
#' Creates an Element UI `<el-select>` component backed by a Vue instance.
#' Supports single and multiple selection, filtering, and all standard
#' Element UI select props.
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param choices,options The choices: a named character vector
#'   (`c(Label = value)`), a list of `list(value = ..., label = ...)`, or
#'   a named list of those for option groups. Unnamed vectors are allowed;
#'   the element is used as both value and label. `choices` is Shiny's name
#'   for it, `options` Element's; give either. Empty by default, for a
#'   select whose options arrive later (`remote = TRUE`).
#' @param selected,value Initially selected value(s); a character vector for
#'   multiple selection. `selected` is Shiny's name, `value` Element's
#'   (its `v-model`); give either.
#' @param multiple Whether multiple items can be selected. Default `FALSE`.
#' @param placeholder Placeholder text shown when nothing is selected.
#' @param disabled Whether the select is disabled. Default `FALSE`.
#' @param clearable Whether to show a clear button. Default `FALSE`.
#' @param filterable Whether typing filters the options. Default `FALSE`.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`.
#' @param multiple_limit Maximum number of items that can be selected when
#'   `multiple = TRUE`. `0` means unlimited. Default `0`.
#' @param collapse_tags Whether to collapse selected tags into a summary when
#'   `multiple = TRUE`. Default `FALSE`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param value_key Key that identifies an option when values are objects. Default `"value"`.
#' @param name Native `name` attribute.
#' @param autocomplete Native `autocomplete` attribute. Default `"off"`.
#' @param automatic_dropdown Whether a filterable select opens its menu on focus.
#' @param allow_create Whether the user may create options not in the list. Needs `filterable = TRUE`.
#' @param loading Whether to show the loading state while options are being fetched.
#' @param loading_text Text shown while loading. Default `"Loading"`.
#' @param no_match_text Text shown when filtering matches nothing.
#' @param no_data_text Text shown when there are no options at all.
#' @param popper_class Extra class name for the dropdown panel.
#' @param popper_append_to_body Whether the dropdown is appended to `body`. Default `TRUE`.
#' @param reserve_keyword Whether a multiple filterable select keeps the search term after selecting.
#' @param default_first_option Whether Enter picks the first matching option.
#' @param remote Whether options are fetched from the server as the user
#'   types. Needs `filterable = TRUE`; see "Shiny inputs".
#' @param filter_method `JS()` function filtering the options as the user types.
#' @param remote_method `JS()` function fetching options in the
#'   browser instead of from the server. Needs `remote = TRUE`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `blur()` -- Blur the Input component, and hide the dropdown
#' - `focus()` -- Focus the Input component
#'
#' @return An `htmltools` tagList containing the Vue-managed select component.
#'
#' @section Shiny inputs:
#' `input$<id>` -- string (single) or character vector (multiple), updated on
#' each change.
#'
#' With `remote = TRUE`, `filterable = TRUE` and no `remote_method` of your
#' own, the server does the search, as `selectizeInput()`'s server mode
#' does: `input$<id>_query` is the text typed, and [update_el_select()]
#' with the matching `choices` answers it -- the select shows Element's
#' loading text until then.
#'
#' @examples
#' # Single-select from a named vector
#' el_select("sel1",
#'   choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'   selected = "banana"
#' )
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_select("fruit",
#'       choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'       selected = "apple",
#'       clearable = TRUE
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$fruit)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_select <- function(
    id             = NULL,
    choices        = NULL,
    selected       = NULL,
    multiple       = FALSE,
    placeholder    = NULL,
    disabled       = FALSE,
    clearable      = FALSE,
    filterable     = FALSE,
    size           = NULL,
    multiple_limit = 0,
    collapse_tags  = FALSE,
    value_key      = NULL,
    name           = NULL,
    autocomplete   = NULL,
    automatic_dropdown = NULL,
    allow_create   = NULL,
    loading        = NULL,
    loading_text   = NULL,
    no_match_text  = NULL,
    no_data_text   = NULL,
    popper_class   = NULL,
    popper_append_to_body = NULL,
    reserve_keyword = NULL,
    default_first_option = NULL,
    remote         = NULL,
    filter_method  = NULL,
    remote_method  = NULL,
    label = NULL,
    label_position = c("top", "left", "right"),
    label_width = NULL,
    label_suffix = NULL,
    required = FALSE,
    error = NULL,
    show_message = TRUE,
    inline_message = FALSE,
    width          = NULL,
    slots          = NULL,
    value          = NULL,
    options        = NULL,
    session        = NULL
) {
  .el_check_choices("el_select", environment())
  selected <- .el_alias(selected, value, "selected", "value")
  choices  <- .el_alias(choices, options, "choices", "options")
  if (is.null(choices)) choices <- list()
  if (is.null(id)) id <- paste0("el_select_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  # Options are rendered with v-for so update_el_select() can replace them.
  # Each carries its own `disabled`: the select's `disabled` argument turns off
  # the whole control, not one choice.
  option_tag <- function(each) htmltools::tag("el-option", list(
    "v-for"     = each,
    ":key"      = "opt.value",
    ":value"    = "opt.value",
    ":label"    = "opt.label",
    ":disabled" = "opt.disabled"
  ))
  option_slot <- list(
    option_tag("opt in options"),
    htmltools::tag("el-option-group", list(
      "v-for"     = "g in groups",
      ":key"      = "g.label",
      ":label"    = "g.label",
      ":disabled" = "g.disabled",
      option_tag("opt in g.options")
    ))
  )

  # Build el-select attributes
  select_attrs <- list(
    "v-model"         = "value",
    ":multiple"       = "multiple",
    ":disabled"       = "disabled",
    ":clearable"      = "clearable",
    ":filterable"     = "filterable",
    ":multiple-limit" = "multipleLimit",
    ":collapse-tags"  = "collapseTags",
    "@change"         = "handleChange"
  )
  select_attrs[[":placeholder"]] <- .el_optional_bind("placeholder")
  select_attrs[[":size"]] <- .el_optional_bind("size")
  select_attrs[[":value-key"]] <- .el_optional_bind("valueKey")
  select_attrs[[":name"]] <- .el_optional_bind("name")
  select_attrs[[":autocomplete"]] <- .el_optional_bind("autocomplete")
  select_attrs[[":automatic-dropdown"]] <- .el_optional_bind("automaticDropdown")
  select_attrs[[":allow-create"]] <- .el_optional_bind("allowCreate")
  select_attrs[[":loading"]] <- .el_optional_bind("loading")
  select_attrs[[":loading-text"]] <- .el_optional_bind("loadingText")
  select_attrs[[":no-match-text"]] <- .el_optional_bind("noMatchText")
  select_attrs[[":no-data-text"]] <- .el_optional_bind("noDataText")
  select_attrs[[":popper-class"]] <- .el_optional_bind("popperClass")
  select_attrs[[":popper-append-to-body"]] <- .el_optional_bind("popperAppendToBody")
  select_attrs[[":reserve-keyword"]] <- .el_optional_bind("reserveKeyword")
  select_attrs[[":default-first-option"]] <- .el_optional_bind("defaultFirstOption")
  select_attrs[[":remote"]] <- .el_optional_bind("remote")
  select_attrs[[":filter-method"]] <- .el_optional_bind("filterMethod")
  # The server answers by default: input$<id>_query, then update_el_select()
  select_attrs[[":remote-method"]] <- "remoteMethod === null ? elRemoteQuery : remoteMethod"

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "visible-change",
    "remove-tag",
    "clear",
    "blur",
    "focus"
  ))
  select_attrs <- c(select_attrs, events$attrs)
  # Build Vue data
  vue_data <- list(
    value        = if (is.null(selected)) (if (multiple) list() else "") else selected,
    options      = .el_select_choices(choices)$options,
    groups       = .el_select_choices(choices)$groups,
    multiple     = multiple,
    disabled     = disabled,
    clearable    = clearable,
    filterable   = filterable,
    multipleLimit = multiple_limit,
    collapseTags  = collapse_tags
  )
  vue_data$placeholder <- if (is.null(placeholder)) NA else placeholder
  vue_data$size <- .el_or_na(size)
  vue_data$valueKey <- .el_or_na(value_key)
  vue_data$name <- .el_or_na(name)
  vue_data$autocomplete <- .el_or_na(autocomplete)
  vue_data$automaticDropdown <- .el_or_na(automatic_dropdown)
  vue_data$allowCreate <- .el_or_na(allow_create)
  vue_data$loading <- .el_or_na(loading)
  vue_data$loadingText <- .el_or_na(loading_text)
  vue_data$noMatchText <- .el_or_na(no_match_text)
  vue_data$noDataText <- .el_or_na(no_data_text)
  vue_data$popperClass <- .el_or_na(popper_class)
  vue_data$popperAppendToBody <- .el_or_na(popper_append_to_body)
  vue_data$reserveKeyword <- .el_or_na(reserve_keyword)
  vue_data$defaultFirstOption <- .el_or_na(default_first_option)
  vue_data$remote <- .el_or_na(remote)
  vue_data$filterMethod <- .el_or_na(filter_method)
  vue_data$remoteMethod <- .el_or_na(remote_method)
  el_widget(
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = htmltools::tag("el-select", c(select_attrs, option_slot)),
    data    = vue_data,
    methods = c(events$methods, list(
      elRemoteQuery = JS(sprintf(paste0(
        "function(query) {\n",
        "  if (!(window.Shiny && Shiny.setInputValue)) return;\n",
        "  this.loading = true;\n",
        "  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_query', query, {priority: 'event'});\n",
        "}"), ns_id)),
      handleChange = JS(sprintf(
        "function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    )),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Select
#'
#' Server-side update for [el_select()]. Sends a custom message to update
#' reactive fields on the underlying Vue instance.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Select input ID (un-namespaced).
#' @param selected,value New selected value(s). `selected` is Shiny's name,
#'   `value` Element's; give either.
#' @param choices,options New choices, in any form [el_select()] takes.
#'   `choices` is Shiny's name, `options` Element's; give either.
#' @param disabled,placeholder,clearable,filterable,multiple_limit New
#'   values for these props.
#' @param loading,loading_text,no_match_text,no_data_text The remote-search
#'   state: show the spinner while options are fetched, and the messages for
#'   no match and no data.
#'
#' @param label New label text, as for [shiny::updateTextInput()]. Only a
#'   component built with a `label` has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_select(session, "city", selected = "sh")
#'   })
#' }
#' @export
update_el_select <- function(
    session = shiny::getDefaultReactiveDomain(),
    id,
    selected       = NULL,
    choices        = NULL,
    disabled       = NULL,
    placeholder    = NULL,
    clearable      = NULL,
    filterable     = NULL,
    multiple_limit = NULL,
    loading        = NULL,
    loading_text   = NULL,
    no_match_text  = NULL,
    no_data_text   = NULL,
    value          = NULL,
    options        = NULL,
    label = NULL, error = NULL) {
  .el_check_session(session)
  selected <- .el_alias(selected, value, "selected", "value")
  choices  <- .el_alias(choices, options, "choices", "options")
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(selected))    msg$value       <- selected
  if (!is.null(choices)) {
    parts <- .el_select_choices(choices)
    msg$options <- parts$options
    msg$groups  <- parts$groups
    # New choices answer a remote search, so it is no longer loading
    if (is.null(loading)) msg$loading <- FALSE
  }
  if (!is.null(disabled))    msg$disabled    <- disabled
  if (!is.null(placeholder)) msg$placeholder <- placeholder
  if (!is.null(clearable))   msg$clearable   <- clearable
  if (!is.null(filterable))  msg$filterable  <- filterable
  if (!is.null(multiple_limit)) msg$multipleLimit <- multiple_limit
  if (!is.null(loading))       msg$loading       <- loading
  if (!is.null(loading_text))  msg$loadingText   <- loading_text
  if (!is.null(no_match_text)) msg$noMatchText   <- no_match_text
  if (!is.null(no_data_text))  msg$noDataText    <- no_data_text
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}


#' Split a select's choices into loose options and option groups
#'
#' Groups are written the way `shiny::selectInput()` takes them -- a named
#' list whose elements are vectors, `list(East = c("NY", "NJ"))` -- or as
#' `list(label =, disabled =, options =)` when a group needs its own
#' `disabled`. Anything else is an ungrouped choice.
#'
#' @param choices The choices as given.
#' @return A list of `options` and `groups`.
#' @keywords internal
.el_select_choices <- function(choices) {
  if (!is.list(choices) || !length(choices)) {
    return(list(options = .el_normalize_choices(choices), groups = list()))
  }
  nms <- names(choices) %||% rep("", length(choices))
  is_group <- function(x, nm) {
    (is.list(x) && !is.null(x$options)) || (nzchar(nm) && is.atomic(x) && length(x) > 0 &&
      !(identical(names(x), c("value", "label"))))
  }
  flags <- mapply(is_group, choices, nms)
  if (!any(flags)) return(list(options = .el_normalize_choices(choices), groups = list()))

  groups <- Map(function(x, nm) {
    if (is.list(x) && !is.null(x$options)) {
      list(label = x$label %||% nm, disabled = isTRUE(x$disabled),
           options = .el_normalize_choices(x$options))
    } else {
      list(label = nm, disabled = FALSE, options = .el_normalize_choices(x))
    }
  }, choices[flags], nms[flags])
  loose <- choices[!flags]
  list(options = if (length(loose)) .el_normalize_choices(unname(loose)) else list(),
       groups = unname(groups))
}

`%||%` <- function(a, b) if (is.null(a)) b else a
