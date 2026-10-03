#' Element UI Transfer
#'
#' Two lists side by side, for moving items from one to the other.
#'
#' @param id Transfer ID. Auto-generated if `NULL`.
#' @param data The items to choose from, as a data.frame with columns `key`
#'   and `label` (and optionally `disabled`), or a list of
#'   `list(key =, label =, disabled =)`.
#' @param value Keys that start out on the right.
#' @param titles Headings of the two panels, as a length-2 character vector.
#'   Default `c("List 1", "List 2")`.
#' @param button_texts Labels of the two buttons, as a length-2 character
#'   vector. Default is arrows only.
#' @param filterable Whether each panel gets a search box.
#' @param filter_placeholder Placeholder of the search boxes.
#' @param filter_method `JS()` function `function(query, item)`
#'   returning whether an item survives the search.
#' @param target_order Order of the right-hand panel: `"original"` (default),
#'   `"push"` or `"unshift"`.
#' @param format Counts shown in each heading, as
#'   `list(noChecked =, hasChecked =)`, for example
#'   `list(noChecked = "${total}", hasChecked = "${checked}/${total}")`.
#' @param props Field names when `data` uses other ones, as
#'   `list(key =, label =, disabled =)`.
#' @param left_default_checked,right_default_checked Keys ticked at the start.
#' @param render_content `JS()` render function for an item.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param item_size Item height for virtual scrolling. Element Plus's
#'   `item-size` (number).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param virtual_scroll Whether to enable virtual scrolling. Element Plus's
#'   `virtual-scroll` (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- keys currently on the right.
#' - `input$<id>_change` -- fires on each move.
#' - `input$<id>_left_check_change`, `input$<id>_right_check_change` -- fire
#'   as items are ticked.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `clearQuery()` -- clear one panel's search box; pass `"left"` or
#'   `"right"`
#'
#' @return A Shiny UI element.
#' @examples
#' el_transfer("cols",
#'   data = data.frame(key = names(iris), label = names(iris)),
#'   value = c("Species")
#' )
#'
#' el_transfer("cols",
#'   data = data.frame(key = names(mtcars), label = names(mtcars)),
#'   titles = c("Available", "Chosen"),
#'   filterable = TRUE, width = "100%"
#' )
#' @export
el_transfer <- function(id = NULL,
                        data = list(),
                        value = NULL,
                        titles = NULL,
                        button_texts = NULL,
                        filterable = NULL,
                        filter_placeholder = NULL,
                        filter_method = NULL,
                        target_order = NULL,
                        format = NULL,
                        props = NULL,
                        left_default_checked = NULL,
                        right_default_checked = NULL,
                        render_content = NULL,
                        label = NULL,
                        label_position = c("top", "left", "right"),
                        label_width = NULL,
                        label_suffix = NULL,
                        required = FALSE,
                        error = NULL,
                        show_message = TRUE,
                        inline_message = FALSE,
                        item_size = NULL,
                        validate_event = NULL,
                        virtual_scroll = NULL,
                        width = NULL,
                        slots   = NULL,
                        session = NULL) {
  .el_check_choices("el_transfer", environment())
  if (is.null(id)) id <- paste0("el_transfer_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    "v-model"              = "value",
    ":data"                = "data",
    ":titles"              = .el_optional_bind("titles"),
    ":button-texts"        = .el_optional_bind("buttonTexts"),
    ":filterable"          = .el_optional_bind("filterable"),
    ":filter-placeholder"  = .el_optional_bind("filterPlaceholder"),
    ":filter-method"       = .el_optional_bind("filterMethod"),
    ":target-order"        = .el_optional_bind("targetOrder"),
    ":format"              = .el_optional_bind("format"),
    ":props"               = .el_optional_bind("props"),
    ":left-default-checked"  = .el_optional_bind("leftDefaultChecked"),
    ":right-default-checked" = .el_optional_bind("rightDefaultChecked"),
    ":render-content"      = .el_optional_bind("renderContent")
  )
  events <- .el_event_bindings(ns_id, c("change", "left-check-change", "right-check-change"),
    shapes = list(
    "change" = "function(value, direction, moved) { return {value: value, direction: direction, moved: moved}; }",
    "left-check-change"  = "function(checked, changed) { return {checked: checked, changed: changed}; }",
    "right-check-change" = "function(checked, changed) { return {checked: checked, changed: changed}; }"
  ))
  attrs <- c(attrs, events$attrs)

  el_widget(
    props = .el_props(list(
      item_size = item_size,
      validate_event = validate_event,
      virtual_scroll = virtual_scroll)),
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = htmltools::tag("el-transfer", attrs),
    data   = list(
      value               = if (is.null(value)) list() else as.list(value),
      data                = .el_transfer_data(data),
      titles              = if (is.null(titles)) NA else as.list(titles),
      buttonTexts         = if (is.null(button_texts)) NA else as.list(button_texts),
      filterable          = .el_or_na(filterable),
      filterPlaceholder   = .el_or_na(filter_placeholder),
      filterMethod        = .el_or_na(filter_method),
      targetOrder         = .el_or_na(target_order),
      format              = .el_or_na(format),
      props               = .el_or_na(props),
      leftDefaultChecked  = if (is.null(left_default_checked)) NA else as.list(left_default_checked),
      rightDefaultChecked = if (is.null(right_default_checked)) NA else as.list(right_default_checked),
      renderContent       = .el_or_na(render_content)
    ),
    methods = events$methods,
    watch = list(
      value = JS(sprintf(
        "function(newVal) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', newVal); }", ns_id
      ))
    ),
    mounted    = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Normalise transfer items
#'
#' Element reads `key`, `label` and `disabled` off each item, so a data.frame
#' is turned into one object per row.
#'
#' @param data A data.frame or a list of items.
#' @return A list of items.
#' @keywords internal
.el_transfer_data <- function(data) {
  if (is.null(data) || !length(data)) return(list())
  if (is.data.frame(data)) {
    return(lapply(seq_len(nrow(data)), function(i) as.list(data[i, , drop = FALSE])))
  }
  unname(data)
}


#' Update Element UI Transfer
#'
#' Server-side update for [el_transfer()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Transfer ID (un-namespaced).
#' @param value,data,titles,filterable New values; `NULL` leaves one unchanged.
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
#'   observeEvent(input$reset, {
#'     update_el_transfer(session, "cols", value = list())
#'   })
#' }
#' @export
update_el_transfer <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL, data = NULL,
                               titles = NULL, filterable = NULL,
                               label = NULL, error = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(value))      msg$value      <- as.list(value)
  if (!is.null(data))       msg$data       <- .el_transfer_data(data)
  if (!is.null(titles))     msg$titles     <- as.list(titles)
  if (!is.null(filterable)) msg$filterable <- filterable
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}


