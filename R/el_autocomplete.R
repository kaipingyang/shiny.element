#' Element UI Autocomplete
#'
#' A text input that suggests as you type.
#'
#' @param id Input ID. Auto-generated if `NULL`.
#' @param value Initial text.
#' @param suggestions Suggestions to offer, as a character vector or a list of
#'   `list(value =, ...)`. Filtered in the browser on what has been typed.
#'   For suggestions that come from the server, leave this empty and use
#'   `fetch_suggestions`.
#' @param fetch_suggestions `htmlwidgets::JS()` function
#'   `function(queryString, callback)` that calls `callback(results)`. Use it
#'   when the list cannot be sent up front.
#' @param placeholder Placeholder text.
#' @param clearable Whether to show a clear button.
#' @param disabled Whether the input is disabled.
#' @param value_key Field of a suggestion object to display. Default
#'   `"value"`.
#' @param debounce Debounce while typing, in milliseconds. Default `300`.
#' @param placement Where the list appears: `"bottom-start"` (default),
#'   `"bottom-end"`, `"top-start"`, `"top-end"`.
#' @param trigger_on_focus Whether to suggest as soon as the input is focused.
#'   Default `TRUE`.
#' @param select_when_unmatched Whether to fire `select` when nothing matched.
#' @param highlight_first_item Whether to preselect the first suggestion.
#' @param hide_loading Whether to hide the loading spinner.
#' @param icon,prefix_icon,suffix_icon Icon classes.
#' @param label A label shown with the component, as Shiny's inputs have:
#'   text or a tag. `NULL`, the default, shows none. It is the component's
#'   accessible name too.
#' @param label_position `"top"` (the default, as Shiny's labels sit) or
#'   `"left"`, beside the component as in a horizontal Element form.
#' @param name Native `name` attribute.
#' @param popper_class Extra class name for the suggestion list.
#' @param popper_append_to_body Whether the list is appended to `body`.
#' @param width Component width, as a CSS unit.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the current text.
#' - `input$<id>_select` -- the suggestion just picked.
#' - `input$<id>_change` -- fires when the text changes.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `focus()` -- focus the input
#'
#' @return A Shiny UI element.
#' @examples
#' el_autocomplete("city", suggestions = c("Beijing", "Shanghai", "Shenzhen"))
#'
#' el_autocomplete("city",
#'   suggestions = c("Beijing", "Shanghai"),
#'   placeholder = "Where to?", clearable = TRUE, width = 260
#' )
#' @export
el_autocomplete <- function(id = NULL,
                            value = "",
                            suggestions = NULL,
                            fetch_suggestions = NULL,
                            placeholder = NULL,
                            clearable = NULL,
                            disabled = NULL,
                            value_key = NULL,
                            debounce = NULL,
                            placement = NULL,
                            trigger_on_focus = NULL,
                            select_when_unmatched = NULL,
                            highlight_first_item = NULL,
                            hide_loading = NULL,
                            icon = NULL,
                            prefix_icon = NULL,
                            suffix_icon = NULL,
                            label = NULL,
                            name = NULL,
                            popper_class = NULL,
                            popper_append_to_body = NULL,
                            label_position = c("top", "left"),
                            width = NULL,
                            slots   = NULL,
                            session = NULL) {
  .el_check_choices("el_autocomplete", environment())
  if (is.null(id)) id <- paste0("el_autocomplete_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  # Local filtering over `suggestions` unless the caller supplies their own
  fetcher <- if (!is.null(fetch_suggestions)) {
    fetch_suggestions
  } else {
    htmlwidgets::JS(
      "function(queryString, callback) {",
      "  var all = this.suggestions || [];",
      "  var q = (queryString || '').toLowerCase();",
      "  callback(q ? all.filter(function(s) {",
      "    return String(s.value).toLowerCase().indexOf(q) === 0;",
      "  }) : all);",
      "}"
    )
  }

  attrs <- list(
    "v-model"                = "value",
    ":fetch-suggestions"     = "fetchSuggestions",
    ":placeholder"           = .el_optional_bind("placeholder"),
    ":clearable"             = .el_optional_bind("clearable"),
    ":disabled"              = .el_optional_bind("disabled"),
    ":value-key"             = .el_optional_bind("valueKey"),
    ":debounce"              = .el_optional_bind("debounce"),
    ":placement"             = .el_optional_bind("placement"),
    ":trigger-on-focus"      = .el_optional_bind("triggerOnFocus"),
    ":select-when-unmatched" = .el_optional_bind("selectWhenUnmatched"),
    ":highlight-first-item"  = .el_optional_bind("highlightFirstItem"),
    ":hide-loading"          = .el_optional_bind("hideLoading"),
    ":icon"                  = .el_optional_bind("icon"),
    ":prefix-icon"           = .el_optional_bind("prefixIcon"),
    ":suffix-icon"           = .el_optional_bind("suffixIcon"),
    ":label"                 = .el_optional_bind("label"),
    ":name"                  = .el_optional_bind("name"),
    ":popper-class"          = .el_optional_bind("popperClass"),
    ":popper-append-to-body" = .el_optional_bind("popperAppendToBody")
  )
  events <- .el_event_bindings(ns_id, c("select", "change"))
  attrs <- c(attrs, events$attrs)

  el_widget(
    # Reported as the value changes, debounced, as Shiny's own inputs are
    rate = list(policy = "debounce", delay = 250),
    label = label, label_position = label_position,
    id     = ns_id,
    markup = htmltools::tag("el-autocomplete", attrs),
    data   = list(
      value               = value,
      suggestions         = .el_autocomplete_suggestions(suggestions),
      placeholder         = .el_or_na(placeholder),
      clearable           = .el_or_na(clearable),
      disabled            = .el_or_na(disabled),
      valueKey            = .el_or_na(value_key),
      debounce            = .el_or_na(debounce),
      placement           = .el_or_na(placement),
      triggerOnFocus      = .el_or_na(trigger_on_focus),
      selectWhenUnmatched = .el_or_na(select_when_unmatched),
      highlightFirstItem  = .el_or_na(highlight_first_item),
      hideLoading         = .el_or_na(hide_loading),
      icon                = .el_or_na(icon),
      prefixIcon          = .el_or_na(prefix_icon),
      suffixIcon          = .el_or_na(suffix_icon),
      label               = .el_or_na(label),
      name                = .el_or_na(name),
      popperClass         = .el_or_na(popper_class),
      popperAppendToBody  = .el_or_na(popper_append_to_body)
    ),
    methods = c(events$methods, list(
      fetchSuggestions = fetcher,
      handleInput = htmlwidgets::JS(sprintf(
        "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }", ns_id
      ))
    )),
    watch = list(
      value = htmlwidgets::JS(sprintf(
        "function(newVal) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', newVal); }", ns_id
      ))
    ),
    mounted    = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Normalise autocomplete suggestions
#'
#' Element reads each suggestion's `value` field, so a character vector is
#' turned into one object per entry.
#'
#' @param suggestions A character vector, or a list of objects.
#' @return A list of objects, each with at least a `value`.
#' @keywords internal
.el_autocomplete_suggestions <- function(suggestions) {
  if (is.null(suggestions) || !length(suggestions)) return(list())
  if (is.list(suggestions)) return(unname(suggestions))
  lapply(as.character(suggestions), function(x) list(value = x))
}


#' Update Element UI Autocomplete
#'
#' Server-side update for [el_autocomplete()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Input ID (un-namespaced).
#' @param value,suggestions,placeholder,disabled New values; `NULL` leaves one
#'   unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$country, {
#'     update_el_autocomplete(session, "city", suggestions = cities_of(input$country))
#'   })
#' }
#' @export
update_el_autocomplete <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL,
                                   suggestions = NULL, placeholder = NULL,
                                   disabled = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(value))       msg$value       <- value
  if (!is.null(suggestions)) msg$suggestions <- .el_autocomplete_suggestions(suggestions)
  if (!is.null(placeholder)) msg$placeholder <- placeholder
  if (!is.null(disabled))    msg$disabled    <- disabled
  .el_send_update(session, msg)
  invisible(NULL)
}


