# Element UI Calendar Component

Create a calendar widget for Shiny using Element UI.

## Usage

``` r
el_calendar(
  id = NULL,
  value = NULL,
  range = NULL,
  first_day_of_week = 1,
  session = getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Calendar ID (auto-generated if NULL)

- value:

  Bound value (Date/string/number)

- range:

  Date range, c("YYYY-MM-DD", "YYYY-MM-DD")

- first_day_of_week:

  First day of week (1~7), default 1

- session:

  Shiny session for module support

## Examples

``` r
# Basic usage
el_calendar(id = "calendar1", value = Sys.Date())
#> <style>  
#>       .is-selected {  
#>         color: #1989FA;  
#>         font-weight: bold;  
#>       }  
#>     </style>
#> <div id="calendar1_container">
#>   <el-calendar v-model="value" :first-day-of-week="firstDayOfWeek">  
#>     <template slot="dateCell" slot-scope="{date, data}">  
#>       <p :class="data.isSelected ? 'is-selected' : ''">  
#>         {{ data.day.split('-').slice(1).join('-') }}  
#>         <span v-if="data.isSelected">✔</span>  
#>       </p>  
#>     </template>  
#>   </el-calendar>
#> </div>
#> <div class="vue html-widget html-fill-item" id="calendar1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="calendar1">{"x":{"el":"#calendar1_container","data":{"value":"2026-06-05","firstDayOfWeek":1},"watch":{"value":"function(newVal) { Shiny.setInputValue('calendar1', newVal); }"}},"evals":["watch.value"],"jsHooks":[]}</script>

# With date range
el_calendar(id = "calendar2", range = c("2025-01-01", "2025-01-31"))
#> <style>  
#>       .is-selected {  
#>         color: #1989FA;  
#>         font-weight: bold;  
#>       }  
#>     </style>
#> <div id="calendar2_container">
#>   <el-calendar v-model="value" :first-day-of-week="firstDayOfWeek" :range="range">  
#>     <template slot="dateCell" slot-scope="{date, data}">  
#>       <p :class="data.isSelected ? 'is-selected' : ''">  
#>         {{ data.day.split('-').slice(1).join('-') }}  
#>         <span v-if="data.isSelected">✔</span>  
#>       </p>  
#>     </template>  
#>   </el-calendar>
#> </div>
#> <div class="vue html-widget html-fill-item" id="calendar2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="calendar2">{"x":{"el":"#calendar2_container","data":{"value":"2026-06-05","firstDayOfWeek":1,"range":["2025-01-01","2025-01-31"]},"watch":{"value":"function(newVal) { Shiny.setInputValue('calendar2', newVal); }"}},"evals":["watch.value"],"jsHooks":[]}</script>

# Shiny app example: interactive calendar with update
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    titlePanel("Element UI Calendar Example"),
    sidebarLayout(
      sidebarPanel(
        actionButton("set_today", "Set to Today"),
        actionButton("set_tomorrow", "Set to Tomorrow"),
        hr(),
        verbatimTextOutput("selected_date")
      ),
      mainPanel(
        el_calendar(
          id = "my_calendar",
          value = Sys.Date(),
          first_day_of_week = 1
        )
      )
    )
  )
  server <- function(input, output, session) {
    output$selected_date <- renderPrint({
      input$my_calendar
    })
    observeEvent(input$set_today, {
      update_el_calendar(session, "my_calendar", value = Sys.Date())
    })
    observeEvent(input$set_tomorrow, {
      update_el_calendar(session, "my_calendar", value = Sys.Date() + 1)
    })
  }
  shinyApp(ui, server)
}
```
