#' Element Plus Autocomplete
#'
#' A text input that suggests as you type.
#'
#' @param id Input ID. Auto-generated if `NULL`.
#' @param value Initial text.
#' @param suggestions Suggestions to offer, as a character vector or a list of
#'   `list(value =, ...)`. Filtered in the browser on what has been typed.
#'   For suggestions that come from the server, use `remote = TRUE`.
#' @param remote Ask the server for suggestions as the user types, as
#'   Element's `fetch-suggestions` asks a function: the text arrives as
#'   `input$<id>_query`, and [update_el_autocomplete()] with `suggestions`
#'   answers it -- the list shows what the server sent.
#' @param fetch_suggestions [JS()] function
#'   `function(queryString, callback)` that calls `callback(results)`, to
#'   fetch in the browser instead.
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
#' @param name Native `name` attribute.
#' @param popper_class Extra class name for the suggestion list.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param append_to Which select dropdown appends to. Element Plus's
#'   `append-to` (CSSSelector / HTMLElement).
#' @param aria_label Native `aria-label` attribute. Element Plus's
#'   `aria-label` (string).
#' @param fit_input_width Whether the width of the dropdown is the same as the
#'   input. Element Plus's `fit-input-width` (boolean).
#' @param loop_navigation Whether keyboard navigation loops from end to start.
#'   Element Plus's `loop-navigation` (boolean).
#' @param popper_options Popper.js parameters. Element Plus's `popper-options`
#'   (object).
#' @param popper_style Custom style for autocomplete's dropdown. Element
#'   Plus's `popper-style` (string / object).
#' @param show_arrow Whether the dropdown has an arrow. Element Plus's
#'   `show-arrow` (boolean).
#' @param teleported Whether select dropdown is teleported to the body.
#'   Element Plus's `teleported` (boolean).
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
#' - `input$<id>_query` -- with `remote = TRUE`, the text to suggest for.
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
#' el_autocomplete(
#'   "city",
#'   suggestions = c("Beijing", "Shanghai"),
#'   placeholder = "Where to?",
#'   clearable = TRUE,
#'   width = 260
#' )
#' @export
el_autocomplete <- function(
  id = NULL,
  value = "",
  suggestions = NULL,
  remote = FALSE,
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
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  append_to = NULL,
  aria_label = NULL,
  fit_input_width = NULL,
  loop_navigation = NULL,
  popper_options = NULL,
  popper_style = NULL,
  show_arrow = NULL,
  teleported = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_autocomplete", environment())
  if (is.null(id)) {
    id <- paste0("el_autocomplete_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)

  # Local filtering over `suggestions` unless the caller supplies their own
  fetcher <- if (!is.null(fetch_suggestions)) {
    fetch_suggestions
  } else if (isTRUE(remote)) {
    # The callback waits for the server's suggestions; the watcher below
    # hands them over when they arrive. The server answers queries in the
    # order they were asked, so the latest callback is kept until every
    # answer is in -- the last one is the answer to the last query. A query
    # with no answer at all settles empty after shinyVue.askTimeout.
    JS(sprintf(
      paste0(
        "function(queryString, callback) {",
        "  if (!(window.Shiny && Shiny.setInputValue)) { callback([]); return; }",
        "  var self = this;",
        "  this._elPending = callback;",
        "  this._elAsked = (this._elAsked || 0) + 1;",
        "  clearTimeout(this._elQueryTimer);",
        "  this._elQueryTimer = setTimeout(function() {",
        "    var cb = self._elPending;",
        "    if (!cb) return;",
        "    self._elPending = null; self._elAnswered = self._elAsked;",
        "    console.warn('[shiny.element] no answer to input$%s_query within ' + window.shinyVue.askTimeout / 1000 + ' s');",
        "    cb([]);",
        "  }, window.shinyVue.askTimeout);",
        "  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_query', queryString || '', {priority: 'event'});",
        "}"
      ),
      ns_id,
      ns_id
    ))
  } else {
    JS(
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
    "v-model" = "value",
    ":fetch-suggestions" = "fetchSuggestions",
    ":placeholder" = .el_optional_bind("placeholder"),
    ":clearable" = .el_optional_bind("clearable"),
    ":disabled" = .el_optional_bind("disabled"),
    ":value-key" = .el_optional_bind("valueKey"),
    ":debounce" = .el_optional_bind("debounce"),
    ":placement" = .el_optional_bind("placement"),
    ":trigger-on-focus" = .el_optional_bind("triggerOnFocus"),
    ":select-when-unmatched" = .el_optional_bind("selectWhenUnmatched"),
    ":highlight-first-item" = .el_optional_bind("highlightFirstItem"),
    ":hide-loading" = .el_optional_bind("hideLoading"),
    ":icon" = .el_optional_bind("icon"),
    ":prefix-icon" = .el_optional_bind("prefixIcon"),
    ":suffix-icon" = .el_optional_bind("suffixIcon"),
    ":label" = .el_optional_bind("label"),
    ":name" = .el_optional_bind("name"),
    ":popper-class" = .el_optional_bind("popperClass")
  )
  events <- .el_event_bindings(
    ns_id,
    c("select", "change", "blur", "clear", "focus", "input")
  )
  attrs <- c(attrs, events$attrs)

  el_widget(
    props = .el_props(list(
      append_to = append_to,
      aria_label = aria_label,
      fit_input_width = fit_input_width,
      loop_navigation = loop_navigation,
      popper_options = popper_options,
      popper_style = popper_style,
      show_arrow = show_arrow,
      teleported = teleported
    )),
    # Reported as the value changes, debounced, as Shiny's own inputs are
    rate = list(policy = "debounce", delay = 250),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-autocomplete", attrs),
    data = list(
      value = value,
      suggestions = .el_autocomplete_suggestions(suggestions),
      placeholder = .el_or_na(placeholder),
      clearable = .el_or_na(clearable),
      disabled = .el_or_na(disabled),
      valueKey = .el_or_na(value_key),
      debounce = .el_or_na(debounce),
      placement = .el_or_na(placement),
      triggerOnFocus = .el_or_na(trigger_on_focus),
      selectWhenUnmatched = .el_or_na(select_when_unmatched),
      highlightFirstItem = .el_or_na(highlight_first_item),
      hideLoading = .el_or_na(hide_loading),
      icon = .el_or_na(icon),
      prefixIcon = .el_or_na(prefix_icon),
      suffixIcon = .el_or_na(suffix_icon),
      label = .el_or_na(label),
      name = .el_or_na(name),
      popperClass = .el_or_na(popper_class)
    ),
    methods = c(events$methods, list(fetchSuggestions = fetcher)),
    watch = list(
      # Kept for when the autocomplete is absorbed into a wrapper and has no
      # binding; el_widget() strips it otherwise
      value = JS(sprintf(
        "function(newVal) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', newVal); }",
        ns_id
      )),
      suggestions = JS(paste0(
        "function(v) { var cb = this._elPending; if (!cb) return; ",
        "clearTimeout(this._elQueryTimer); ",
        "this._elAnswered = (this._elAnswered || 0) + 1; ",
        "if (this._elAnswered >= this._elAsked) this._elPending = null; ",
        "cb(v); }"
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width = width,
    slots = slots
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
  if (is.null(suggestions) || !length(suggestions)) {
    return(list())
  }
  if (is.list(suggestions)) {
    return(unname(suggestions))
  }
  lapply(as.character(suggestions), function(x) list(value = x))
}


#' Update Element Plus Autocomplete
#'
#' Server-side update for [el_autocomplete()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Input ID (un-namespaced).
#' @param value,suggestions,placeholder,disabled New values; `NULL` leaves one
#'   unchanged.
#'
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$country, {
#'     update_el_autocomplete(
#'       session,
#'       "city",
#'       suggestions = cities_of(input$country)
#'     )
#'   })
#' }
#' @export
update_el_autocomplete <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  suggestions = NULL,
  placeholder = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(suggestions)) {
    msg$suggestions <- .el_autocomplete_suggestions(suggestions)
  }
  if (!is.null(placeholder)) {
    msg$placeholder <- placeholder
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
