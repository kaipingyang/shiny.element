# Element Plus Pagination Component

Creates an Element Plus pagination bar with page navigation, size
selector, jump-to-page input, and total count display.

## Usage

``` r
el_pagination(
  id = NULL,
  total,
  page_size = 10,
  current_page = 1,
  page_sizes = c(10, 20, 30, 50),
  layout = "total, sizes, prev, pager, next, jumper",
  background = FALSE,
  small = FALSE,
  disabled = FALSE,
  pager_count = 7,
  prev_text = NULL,
  next_text = NULL,
  hide_on_single_page = NULL,
  page_count = NULL,
  popper_class = NULL,
  append_size_to = NULL,
  default_current_page = NULL,
  default_page_size = NULL,
  next_icon = NULL,
  popper_style = NULL,
  prev_icon = NULL,
  size = NULL,
  teleported = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_pagination(
  session = shiny::getDefaultReactiveDomain(),
  id,
  total = NULL,
  current_page = NULL,
  page_size = NULL,
  disabled = NULL,
  page_sizes = NULL,
  layout = NULL,
  background = NULL,
  small = NULL,
  pager_count = NULL,
  prev_text = NULL,
  next_text = NULL,
  hide_on_single_page = NULL,
  page_count = NULL,
  popper_class = NULL,
  append_size_to = NULL,
  next_icon = NULL,
  popper_style = NULL,
  prev_icon = NULL,
  size = NULL,
  teleported = NULL
)
```

## Arguments

- id:

  Pagination ID. Auto-generated UUID if `NULL`.

- total:

  Total item count (required).

- page_size:

  Items per page. Default `10`.

- current_page:

  Current page number (1-based). Default `1`.

- page_sizes:

  Vector of page-size options. Default `c(10, 20, 30, 50)`.

- layout:

  Comma-separated list of layout elements. Default
  `"total, sizes, prev, pager, next, jumper"`.

- background:

  Whether to use background colour on page buttons. Default `FALSE`.

- small:

  Whether to use compact (small) mode. Default `FALSE`.

- disabled:

  Whether the pagination is disabled. Default `FALSE`.

- pager_count:

  Number of pager buttons to show. Default `7`.

- prev_text:

  Text of the previous-page button, in place of the arrow icon.

- next_text:

  Text of the next-page button, in place of the arrow icon.

- hide_on_single_page:

  Whether to hide the pager when there is only one page.

- page_count:

  Total page count. Set either this or `total`.

- popper_class:

  Extra class name for the page-size dropdown.

- append_size_to:

  Which element the size dropdown appends to. Element Plus's
  `append-size-to` (string).

- default_current_page:

  Default initial value of current-page, not setting is the same as
  setting 1. Element Plus's `default-current-page` (number).

- default_page_size:

  Default initial value of page size, not setting is the same as
  setting 10. Element Plus's `default-page-size` (number).

- next_icon:

  Icon for the next button, has a lower priority than `next-text`.
  Element Plus's `next-icon` (string / Component). An icon's name, such
  as `"Search"`.

- popper_style:

  Custom style for the page size Select's dropdown. Element Plus's
  `popper-style` (string / object).

- prev_icon:

  Icon for the prev button, has a lower priority than `prev-text`.
  Element Plus's `prev-icon` (string / Component). An icon's name, such
  as `"Search"`.

- size:

  Pagination size. Element Plus's `size` ('large' \| 'default' \|
  'small').

- teleported:

  Whether Pagination select dropdown is teleported to the body. Element
  Plus's `teleported` (boolean).

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_pagination()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_pagination()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed pagination component.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the current page, from 1 |
| `input$<id>_page_size` | unasked | the page size |
| `input$<id>_prev_click` | `events = "prev_click"` | triggers when the prev button is clicked and current page changes |
| `input$<id>_next_click` | `events = "next_click"` | triggers when the next button is clicked and current page changes |
| `input$<id>_change` | `events = "change"` | triggers when current-page or page-size changes |

The same list as `el_events("el_pagination")`, which says how an event's
arguments travel.

## Updating from the server

Server-side update for `el_pagination()`.

Every other argument of `el_pagination()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_pagination()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
# Basic usage
el_pagination("pg1", total = 100)
#> <div id="pg1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="pg1_container" style="display: contents">
#>   <el-pagination :total="total" v-model:page-size="pageSize" v-model:current-page="currentPage" :page-sizes="pageSizes" :layout="layout" :background="background" :small="small" :disabled="disabled" :pager-count="pagerCount" @current-change="handlePageChange" @size-change="handleSizeChange" :prev-text="prevText === null ? undefined : prevText" :next-text="nextText === null ? undefined : nextText" :hide-on-single-page="hideOnSinglePage === null ? undefined : hideOnSinglePage" :page-count="pageCount === null ? undefined : pageCount" :popper-class="popperClass === null ? undefined : popperClass" :append-size-to="appendSizeTo === null ? undefined : appendSizeTo" :default-current-page="defaultCurrentPage === null ? undefined : defaultCurrentPage" :default-page-size="defaultPageSize === null ? undefined : defaultPageSize" :next-icon="nextIcon === null ? undefined : nextIcon" :popper-style="popperStyle === null ? undefined : popperStyle" :prev-icon="prevIcon === null ? undefined : prevIcon" :size="size === null ? undefined : size" :teleported="teleported === null ? undefined : teleported"></el-pagination>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"total":100,"pageSize":10,"currentPage":1,"pageSizes":[10,20,30,50],"layout":"total, sizes, prev, pager, next, jumper","background":false,"small":false,"disabled":false,"pagerCount":7,"prevText":null,"nextText":null,"hideOnSinglePage":null,"pageCount":null,"popperClass":null,"appendSizeTo":null,"defaultCurrentPage":null,"defaultPageSize":null,"nextIcon":null,"popperStyle":null,"prevIcon":null,"size":null,"teleported":null},"methods":{"handlePageChange":"function(page) { }","handleSizeChange":"function(size) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('pg1_page_size', size); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"pg1_page_size\", self.pageSize); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"currentPage","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handlePageChange","options.methods.handleSizeChange","options.mounted"]}</script>
#> </div>

# With custom page sizes and layout
el_pagination(
  "pg2",
  total = 500,
  page_size = 20,
  page_sizes = c(10, 20, 50, 100),
  layout = "total, sizes, prev, pager, next"
)
#> <div id="pg2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="pg2_container" style="display: contents">
#>   <el-pagination :total="total" v-model:page-size="pageSize" v-model:current-page="currentPage" :page-sizes="pageSizes" :layout="layout" :background="background" :small="small" :disabled="disabled" :pager-count="pagerCount" @current-change="handlePageChange" @size-change="handleSizeChange" :prev-text="prevText === null ? undefined : prevText" :next-text="nextText === null ? undefined : nextText" :hide-on-single-page="hideOnSinglePage === null ? undefined : hideOnSinglePage" :page-count="pageCount === null ? undefined : pageCount" :popper-class="popperClass === null ? undefined : popperClass" :append-size-to="appendSizeTo === null ? undefined : appendSizeTo" :default-current-page="defaultCurrentPage === null ? undefined : defaultCurrentPage" :default-page-size="defaultPageSize === null ? undefined : defaultPageSize" :next-icon="nextIcon === null ? undefined : nextIcon" :popper-style="popperStyle === null ? undefined : popperStyle" :prev-icon="prevIcon === null ? undefined : prevIcon" :size="size === null ? undefined : size" :teleported="teleported === null ? undefined : teleported"></el-pagination>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"total":500,"pageSize":20,"currentPage":1,"pageSizes":[10,20,50,100],"layout":"total, sizes, prev, pager, next","background":false,"small":false,"disabled":false,"pagerCount":7,"prevText":null,"nextText":null,"hideOnSinglePage":null,"pageCount":null,"popperClass":null,"appendSizeTo":null,"defaultCurrentPage":null,"defaultPageSize":null,"nextIcon":null,"popperStyle":null,"prevIcon":null,"size":null,"teleported":null},"methods":{"handlePageChange":"function(page) { }","handleSizeChange":"function(size) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('pg2_page_size', size); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"pg2_page_size\", self.pageSize); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"currentPage","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handlePageChange","options.methods.handleSizeChange","options.mounted"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_pagination("pg1", total = 200),
    verbatimTextOutput("page_info")
  )
  server <- function(input, output, session) {
    output$page_info <- renderPrint({
      list(page = input$pg1, size = input$pg1_page_size)
    })
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_pagination(session, "pager", current_page = 2)
  })
}
```
