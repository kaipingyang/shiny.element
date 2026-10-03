#' Element UI Calendar
#'
#' A month of days to pick one from, or a range of weeks to show.
#'
#' @param id Calendar ID (auto-generated if NULL)
#' @param value Bound value (Date/string/number)
#' @param range Date range, c("YYYY-MM-DD", "YYYY-MM-DD")
#' @param first_day_of_week First day of week (1~7), default 1
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels.
#' @param slots Named list of Element slot contents. `dateCell` renders one
#'   day: Element hands the template `date` and `data`, so write it with
#'   [template()]. A default is used when none is given.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @return A Shiny UI element.
#' @export
#' @examples
#' # The default day cell
#' el_calendar("cal")
#'
#' # Your own, with whatever Element hands the template
#' el_calendar("cal", slots = list(
#'   dateCell = template(
#'     htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
#'     slot = "dateCell", scope = "{date, data}"
#'   )
#' ))
#' # Basic usage
#' el_calendar(id = "calendar1", value = Sys.Date())
#'
#' # With date range
#' el_calendar(id = "calendar2", range = c("2025-01-01", "2025-01-31"))
#'
#' # Shiny app example: interactive calendar with update
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     titlePanel("Element UI Calendar Example"),
#'     sidebarLayout(
#'       sidebarPanel(
#'         actionButton("set_today", "Set to Today"),
#'         actionButton("set_tomorrow", "Set to Tomorrow"),
#'         hr(),
#'         verbatimTextOutput("selected_date")
#'       ),
#'       mainPanel(
#'         el_calendar(
#'           id = "my_calendar",
#'           value = Sys.Date(),
#'           first_day_of_week = 1
#'         )
#'       )
#'     )
#'   )
#'   server <- function(input, output, session) {
#'     output$selected_date <- renderPrint({
#'       input$my_calendar
#'     })
#'     observeEvent(input$set_today, {
#'       update_el_calendar(session, "my_calendar", value = Sys.Date())
#'     })
#'     observeEvent(input$set_tomorrow, {
#'       update_el_calendar(session, "my_calendar", value = Sys.Date() + 1)
#'     })
#'   }
#'   shinyApp(ui, server)
#' }

el_calendar <- function(id = NULL,  
                        value = NULL,  
                        range = NULL,  
                        first_day_of_week = 1,  
                        label = NULL,
                        label_position = c("top", "left", "right"),
                        label_width = NULL,
                        label_suffix = NULL,
                        required = FALSE,
                        error = NULL,
                        show_message = TRUE,
                        inline_message = FALSE,
                        width   = NULL,
                        slots   = NULL,
                        session = NULL) {  
  
  if (is.null(id)) {  
    id <- paste0("el_calendar_", uuid::UUIDgenerate())  
  }  
  ns_id <- .el_ui_id(id, session)  
  container_id <- paste0(ns_id, "_container")  
  
  calendar_attrs <- list(  
    "v-model" = "value",  
    ":first-day-of-week" = "firstDayOfWeek"  
  )  
  # Bound unconditionally so update_el_calendar(range = ) can set it later; a
  # field left out of the Vue data is not reactive.
  calendar_attrs[[":range"]] <- .el_optional_bind("range")  
  
  # Element's own day cell is bare, so this is the default -- but it is only
  # a default: slots = list(dateCell = ...) replaces it.
  if (is.null(slots$dateCell)) {
    slots$dateCell <- template(
      htmltools::HTML(paste0(
        '<p :class="data.isSelected ? \'is-selected\' : \'\'">',
        "{{ data.day.split('-').slice(1).join('-') }}",
        '<span v-if="data.isSelected">\u2714</span>',
        "</p>"
      )),
      slot = "date-cell", scope = "{date, data}"
    )
  }
 
  
  vue_data <- list(  
    value = if (is.null(value)) format(Sys.Date(), "%Y-%m-%d") else {  
      if (inherits(value, "Date")) format(value, "%Y-%m-%d") else value  
    },  
    firstDayOfWeek = first_day_of_week  
  )  
  vue_data$range <- if (is.null(range)) NA else as.character(range)  
  
  el_widget(
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = tag("el-calendar", calendar_attrs),
    head   = tags$style(HTML("
      .is-selected {
        color: #1989FA;
        font-weight: bold;
      }
    ")),
    data  = vue_data,
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

#' Update Element UI Calendar Component
#'
#' Send a message to update the calendar value, range, first day of week, or slot.
#'
#' @param id Component id
#' @param value New value (Date/string/number)
#' @param range New range (c("YYYY-MM-DD", "YYYY-MM-DD"))
#' @param first_day_of_week New first day of week (1~7)
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
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
#'   observeEvent(input$go, {
#'     update_el_calendar(session, "cal", value = "2026-06-01")
#'   })
#' }
#' @export
update_el_calendar <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL, range = NULL, first_day_of_week = NULL,
                               label = NULL, error = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)  
  message <- list(id = ns_id)  
  if (!is.null(value)) message$value <- if (inherits(value, "Date")) format(value, "%Y-%m-%d") else value  
  if (!is.null(range)) message$range <- as.character(range)  
  if (!is.null(first_day_of_week)) message$firstDayOfWeek <- first_day_of_week  
  
  message <- .el_form_item_update(message, label, error)
  .el_send_update(session, message)
  invisible(NULL)
}