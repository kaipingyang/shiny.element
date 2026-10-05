#' Element Plus Switch
#'
#' Creates an Element Plus switch with Vue instance.
#'
#' @param id Switch ID. Auto-generated UUID if `NULL`.
#' @param value Initial switch state. Default `FALSE`.
#' @param disabled Whether the switch is disabled. Default `FALSE`.
#' @inheritParams el_widget
#' @param width Switch width in pixels (integer).
#' @param active_text Text displayed when switch is on.
#' @param inactive_text Text displayed when switch is off.
#' @param active_color Background color when switch is on (e.g. `"#409EFF"`).
#' @param inactive_color Background color when switch is off.
#' @param active_value Value reported to Shiny when switch is on. Default `TRUE`.
#' @param inactive_value Value reported to Shiny when switch is off. Default `FALSE`.
#' @param active_action_icon Component of the icon displayed in action when in
#'   `on` state. Element Plus's `active-action-icon` (string / Component). An
#'   icon's name, such as `"Search"`.
#' @param active_icon Component of the icon displayed when in `on` state,
#'   overrides `active-text`. Element Plus's `active-icon` (string /
#'   Component). An icon's name, such as `"Search"`.
#' @param aria_label Same as `aria-label` in native input. Element Plus's
#'   `aria-label` (string).
#' @param before_change Before-change hook before the switch state changes. If
#'   `false` is returned or a `Promise` is returned and then is rejected, will
#'   stop switching. Element Plus's `before-change`
#'   (`() => Promise<boolean> | boolean`).
#' @param border_color Border color of the switch ( use CSS var
#'   `--el-switch-border-color` instead ). Element Plus's `border-color`
#'   (string).
#' @param inactive_action_icon Component of the icon displayed in action when
#'   in `off` state. Element Plus's `inactive-action-icon` (string /
#'   Component). An icon's name, such as `"Search"`.
#' @param inactive_icon Component of the icon displayed when in `off` state,
#'   overrides `inactive-text`. Element Plus's `inactive-icon` (string /
#'   Component). An icon's name, such as `"Search"`.
#' @param inline_prompt Whether icon or text is displayed inside dot, only the
#'   first character will be rendered for text. Element Plus's `inline-prompt`
#'   (boolean).
#' @param loading Whether Switch is in loading state. Element Plus's `loading`
#'   (boolean).
#' @param size Size of Switch. Element Plus's `size` ('' | 'large' | 'default'
#'   | 'small').
#' @param tabindex Tabindex for input. Element Plus's `tabindex` (string /
#'   number).
#' @param session In `el_switch()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_switch()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param name Native `name` attribute of the inner checkbox.
#' @param validate_event Whether a change triggers form validation. Default `TRUE`.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `focus()` -- Focus the Switch component
#'
#' @return An `htmltools` tagList with a Vue-managed switch component.
#'
#' @section Shiny inputs:
#' `input$<id>` -- the value of `active_value` (when on) or `inactive_value`
#' (when off), matching the types of those arguments.
#'
#' @examples
#' el_switch("sw1", value = TRUE)
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_switch("sw1", active_text = "On", inactive_text = "Off"),
#'     verbatimTextOutput("state")
#'   )
#'   server <- function(input, output, session) {
#'     output$state <- renderPrint(input$sw1)
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_switch <- function(
  id = NULL,
  value = FALSE,
  disabled = FALSE,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  active_value = TRUE,
  inactive_value = FALSE,
  name = NULL,
  validate_event = NULL,
  active_action_icon = NULL,
  active_icon = NULL,
  aria_label = NULL,
  before_change = NULL,
  border_color = NULL,
  inactive_action_icon = NULL,
  inactive_icon = NULL,
  inline_prompt = NULL,
  loading = NULL,
  size = NULL,
  tabindex = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_switch", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_switch")
  }
  ns_id <- .el_ui_id(id, session)

  switch_attrs <- list(
    "v-model" = "value",
    ":disabled" = "disabled",
    ":active-text" = "activeText",
    ":inactive-text" = "inactiveText",
    ":active-color" = "activeColor",
    ":inactive-color" = "inactiveColor",
    ":active-value" = "activeValue",
    ":inactive-value" = "inactiveValue",
    "@change" = "handleChange"
  )
  switch_attrs[[":width"]] <- .el_optional_bind("width")
  switch_attrs[[":name"]] <- .el_optional_bind("name")
  switch_attrs[[":validate-event"]] <- .el_optional_bind("validateEvent")
  switch_tag <- htmltools::tag("el-switch", switch_attrs)

  vue_data <- list(
    value = value,
    disabled = disabled,
    activeText = if (is.null(active_text)) "" else active_text,
    inactiveText = if (is.null(inactive_text)) "" else inactive_text,
    activeColor = if (is.null(active_color)) "" else active_color,
    inactiveColor = if (is.null(inactive_color)) "" else inactive_color,
    activeValue = active_value,
    inactiveValue = inactive_value
  )
  vue_data$width <- .el_or_na(width)
  vue_data$name <- .el_or_na(name)
  vue_data$validateEvent <- .el_or_na(validate_event)
  el_widget(
    props = .el_props(list(
      active_action_icon = .el_icon_name(active_action_icon),
      active_icon = .el_icon_name(active_icon),
      aria_label = aria_label,
      before_change = before_change,
      border_color = border_color,
      inactive_action_icon = .el_icon_name(inactive_action_icon),
      inactive_icon = .el_icon_name(inactive_icon),
      inline_prompt = inline_prompt,
      loading = loading,
      size = size,
      tabindex = tabindex
    )),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = switch_tag,
    data = vue_data,
    methods = list(
      handleChange = JS(sprintf(
        "function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    slots = slots
  )
}


#' @rdname el_switch
#' @section Updating from the server:
#' Server-side update for [el_switch()]. Pass only the fields to change;
#' `NULL` fields are excluded from the update message.
#'
#' Every other argument of [el_switch()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_switch()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_switch(session, "live", value = TRUE)
#'   })
#' }
#' @export
update_el_switch <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  label = NULL,
  error = NULL,
  active_value = NULL,
  inactive_value = NULL,
  name = NULL,
  validate_event = NULL,
  active_action_icon = NULL,
  active_icon = NULL,
  aria_label = NULL,
  before_change = NULL,
  border_color = NULL,
  inactive_action_icon = NULL,
  inactive_icon = NULL,
  inline_prompt = NULL,
  loading = NULL,
  size = NULL,
  tabindex = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  if (!is.null(active_text)) {
    msg$activeText <- active_text
  }
  if (!is.null(inactive_text)) {
    msg$inactiveText <- inactive_text
  }
  if (!is.null(active_color)) {
    msg$activeColor <- active_color
  }
  if (!is.null(inactive_color)) {
    msg$inactiveColor <- inactive_color
  }
  msg <- .el_form_item_update(msg, label, error)
  msg <- c(
    msg,
    .el_update_props(
      "el_switch",
      Filter(
        Negate(is.null),
        list(
          active_value = active_value,
          inactive_value = inactive_value,
          name = name,
          validate_event = validate_event,
          active_action_icon = active_action_icon,
          active_icon = active_icon,
          aria_label = aria_label,
          before_change = before_change,
          border_color = border_color,
          inactive_action_icon = inactive_action_icon,
          inactive_icon = inactive_icon,
          inline_prompt = inline_prompt,
          loading = loading,
          size = size,
          tabindex = tabindex
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
