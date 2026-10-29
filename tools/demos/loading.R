## basic
#' A table's own `loading` draws Element Plus's mask over it, as `v-loading`
#' does; `update_el_table(loading =)` turns it on and off.
#| shot_expect = "document.querySelector('.el-table .el-loading-mask .el-loading-spinner')"
table_data <- data.frame(
  date = c("2016-05-02", "2016-05-04", "2016-05-01"),
  name = "John Smith",
  address = "No.1518,  Jinshajiang Road, Putuo District"
)
el_table(
  loading = TRUE,
  data = table_data,
  columns = list(
    el_table_column("date", "Date", width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column("address", "Address")
  )
)

## customization
#' `loading_options` sets the mask's text, spinner and background, as the
#' `element-loading-*` attributes do. `el_loading()` covers an element of
#' your choice from the server with the same options.
#| shot_expect = c("document.querySelector('.el-loading-text').innerText === 'Loading...'", "document.querySelectorAll('.el-loading-spinner svg .path').length === 2")
table_data <- data.frame(
  date = c("2016-05-02", "2016-05-04", "2016-05-01"),
  name = "John Smith",
  address = "No.1518,  Jinshajiang Road, Putuo District"
)
columns <- list(
  el_table_column("date", "Date", width = 180),
  el_table_column("name", "Name", width = 180),
  el_table_column("address", "Address")
)
svg <- '
  <path class="path" d="
    M 30 15
    L 28 17
    M 25.61 25.61
    A 15 15, 0, 0, 1, 15 30
    A 15 15, 0, 1, 1, 27.99 7.5
    L 15 15
  " style="stroke-width: 4px; fill: rgba(0, 0, 0, 0)"/>'
tagList(
  tags$style(
    ".example-showcase .el-loading-mask { z-index: 9; }"
  ),
  el_table(
    loading = TRUE,
    loading_options = list(
      text = "Loading...",
      spinner = svg,
      svg_view_box = "-10, -10, 50, 50",
      background = "rgba(122, 122, 122, 0.8)"
    ),
    data = table_data,
    columns = columns
  ),
  tags$div(
    class = "custom-loading-svg",
    el_table(
      loading = TRUE,
      loading_options = list(svg = svg, svg_view_box = "-10, -10, 50, 50"),
      data = table_data,
      columns = columns
    )
  )
)

## fullscreen
#' In the browser, Element's own service, `$loading()`, in an `on` handler:
#' it covers the page until closed, `lock` stopping it scrolling meanwhile.
#' From the server it is `el_loading(session, id, fullscreen = TRUE)` and
#' `el_loading_close()`: see In Shiny below.
#| shot_js = "document.querySelectorAll('button')[1].click()"
#| shot_wait = 1
#| shot_sel = ".el-loading-mask"
#| shot_expect = "document.querySelector('.el-loading-mask.is-fullscreen .el-loading-text').innerText === 'Loading'"
el_button(
  "full_directive",
  "As a directive",
  type = "primary",
  on = list(
    click = JS(
      "function() {
        var mask = this.$loading({ fullscreen: true, lock: true });
        setTimeout(function() { mask.close(); }, 2000);
      }"
    )
  )
)
el_button(
  "full_service",
  "As a service",
  type = "primary",
  on = list(
    click = JS(
      "function() {
        var mask = this.$loading({
          fullscreen: true,
          lock: true,
          text: 'Loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });
        setTimeout(function() { mask.close(); }, 2000);
      }"
    )
  )
)

## in-shiny
#' From the server, `el_loading(session, id, ...)` covers the page -- or
#' an element, `target` -- while the server works, and
#' `el_loading_close(session, id)` takes it away.
#| shot_js = "document.querySelector('#work_container button').click()"
#| shot_wait = 1
#| shot_sel = ".el-loading-mask"
ui <- el_page(el_button("work", "Run", type = "primary"))
server <- function(input, output, session) {
  observeEvent(input$work, {
    el_loading(session, "page", fullscreen = TRUE, text = "Working")
    Sys.sleep(2) # the server's work
    el_loading_close(session, "page")
  })
}
shinyApp(ui, server)
