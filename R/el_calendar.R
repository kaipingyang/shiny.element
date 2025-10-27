#' Element UI Calendar Component
#'
#' @param id Calendar ID (auto-generated if NULL)
#' @param value Bound value (Date/string/number)
#' @param range Date range, c("YYYY-MM-DD", "YYYY-MM-DD")
#' @param first_day_of_week First day of week (1~7), default 1
#' @param session Shiny session for module support
#' @export
el_calendar <- function(id = NULL,  
                        value = NULL,  
                        range = NULL,  
                        first_day_of_week = 1,  
                        session = getDefaultReactiveDomain()) {  
    
  if (is.null(id)) {  
    id <- paste0("el_calendar_", uuid::UUIDgenerate())  
  }  
  ns_id <- if (!is.null(session)) session$ns(id) else id  
  container_id <- paste0(ns_id, "_container")  
    
  calendar_attrs <- list(  
    "v-model" = "value",  
    ":first-day-of-week" = "firstDayOfWeek"  
  )  
  if (!is.null(range)) calendar_attrs[[":range"]] <- "range"  
    
  date_cell_slot <- htmltools::HTML('  
    <template slot="dateCell" slot-scope="{date, data}">  
      <p :class="data.isSelected ? \'is-selected\' : \'\'">  
        {{ data.day.split(\'-\').slice(1).join(\'-\') }}  
        <span v-if="data.isSelected">\u2714</span>  
      </p>  
    </template>  
  ')  
    
  vue_data <- list(  
    value = if (is.null(value)) format(Sys.Date(), "%Y-%m-%d") else {  
      if (inherits(value, "Date")) format(value, "%Y-%m-%d") else value  
    },  
    firstDayOfWeek = first_day_of_week  
  )  
  if (!is.null(range)) vue_data$range <- as.character(range)  
    
  component_ui <- tagList(  
    tags$style(HTML("  
      .is-selected {  
        color: #1989FA;  
        font-weight: bold;  
      }  
    ")),  
    tags$div(  
      id = container_id,  
      tag("el-calendar", append(calendar_attrs, list(date_cell_slot)))  
    ),  
    vueR::vue(  
      elementId = ns_id,  
      list(  
        el = paste0("#", container_id),  
        data = vue_data,  
        watch = list(  
          value = htmlwidgets::JS(sprintf(  
            "function(newVal) { Shiny.setInputValue('%s', newVal); }",   
            ns_id  
          ))  
        )  
      )  
    )  
  )  
    
  htmltools::attachDependencies(  
    component_ui,  
    el_calendar_handler_dependency()  
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
#' @param session Shiny session
#' @export
update_el_calendar <- function(session, id, value = NULL, range = NULL, first_day_of_week = NULL) {  
  ns_id <- session$ns(id)  
  message <- list(id = ns_id)  
  if (!is.null(value)) message$value <- if (inherits(value, "Date")) format(value, "%Y-%m-%d") else value  
  if (!is.null(range)) message$range <- as.character(range)  
  if (!is.null(first_day_of_week)) message$firstDayOfWeek <- first_day_of_week  
    
  session$sendCustomMessage('updateElCalendar', message)  
}