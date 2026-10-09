#' @param on Handlers of your own, for an event not reported or to send
#'   something else: a named list of [JS()] functions, one per event --
#'   Element's, or a DOM event with Vue's modifiers (`"keyup.enter"`). Each
#'   is called with `report` and the event's arguments; `report(name,
#'   value)` sets `input$<id>_<name>`. See [el_widget()].
