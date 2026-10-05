# Element Plus Calendar

A month of days to pick one from, or a range of weeks to show.

## Usage

``` r
el_calendar(
  id = NULL,
  value = NULL,
  range = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  controller_type = NULL,
  formatter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Calendar ID (auto-generated if NULL)

- value:

  Bound value (Date/string/number)

- range:

  Date range, c("YYYY-MM-DD", "YYYY-MM-DD")

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- controller_type:

  How the header switches month and year: `"button"` (the default) or
  `"select"`. Element Plus's `controller-type`.

- formatter:

  With `controller_type = "select"`, a
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(value, type)` returning the label of each option.
  Element Plus's `formatter`.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels.

- slots:

  Named list of Element slot contents. `dateCell` renders one day:
  Element hands the template `date` and `data`, so write it with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).
  A default is used when none is given.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Examples

``` r
# The default day cell
el_calendar("cal")
#> <style>
#>       .is-selected {
#>         color: #1989FA;
#>         font-weight: bold;
#>       }
#>     </style>
#> <div id="cal" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cal_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{date, data}"><p :class="data.isSelected ? 'is-selected' : ''">{{ data.day.split('-').slice(1).join('-') }}<span v-if="data.isSelected">✔</span></p></template></el-calendar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-05","range":null,"controllerType":null,"formatter":null},"methods":{"elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value"]}</script>
#> </div>

# Your own, with whatever Element hands the template
el_calendar(
  "cal",
  slots = list(
    dateCell = template(
      htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
      slot = "dateCell",
      scope = "{date, data}"
    )
  )
)
#> <style>
#>       .is-selected {
#>         color: #1989FA;
#>         font-weight: bold;
#>       }
#>     </style>
#> <div id="cal" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cal_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{date, data}"><p>{{ data.day.slice(8) }}</p></template></el-calendar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-05","range":null,"controllerType":null,"formatter":null},"methods":{"elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value"]}</script>
#> </div>
# Basic usage
el_calendar(id = "calendar1", value = Sys.Date())
#> <style>
#>       .is-selected {
#>         color: #1989FA;
#>         font-weight: bold;
#>       }
#>     </style>
#> <div id="calendar1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="calendar1_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{date, data}"><p :class="data.isSelected ? 'is-selected' : ''">{{ data.day.split('-').slice(1).join('-') }}<span v-if="data.isSelected">✔</span></p></template></el-calendar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-05","range":null,"controllerType":null,"formatter":null},"methods":{"elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value"]}</script>
#> </div>

# With date range
el_calendar(id = "calendar2", range = c("2025-01-01", "2025-01-31"))
#> <style>
#>       .is-selected {
#>         color: #1989FA;
#>         font-weight: bold;
#>       }
#>     </style>
#> <div id="calendar2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="calendar2_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{date, data}"><p :class="data.isSelected ? 'is-selected' : ''">{{ data.day.split('-').slice(1).join('-') }}<span v-if="data.isSelected">✔</span></p></template></el-calendar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-05","range":["2025-01-01","2025-01-31"],"controllerType":null,"formatter":null},"methods":{"elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value"]}</script>
#> </div>

# Shiny app example: interactive calendar with update
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    titlePanel("Element Plus Calendar Example"),
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
          value = Sys.Date()
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
