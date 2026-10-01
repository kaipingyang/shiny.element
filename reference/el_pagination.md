# Element UI Pagination Component

Creates an Element UI pagination bar with page navigation, size
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
  width = NULL,
  slots = NULL,
  session = NULL
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

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed pagination component.

## Shiny inputs

- `input$<id>_page`:

  Current page number (integer).

- `input$<id>_size`:

  Current page size (integer).

## Examples

``` r
# Basic usage
el_pagination("pg1", total = 100)
#> <div id="pg1_container" style="display: contents">
#>   <el-pagination :total="total" :page-size="pageSize" :current-page.sync="currentPage" :page-sizes="pageSizes" :layout="layout" :background="background" :small="small" :disabled="disabled" :pager-count="pagerCount" @current-change="handlePageChange" @size-change="handleSizeChange" :prev-text="prevText === null ? undefined : prevText" :next-text="nextText === null ? undefined : nextText" :hide-on-single-page="hideOnSinglePage === null ? undefined : hideOnSinglePage" :page-count="pageCount === null ? undefined : pageCount" :popper-class="popperClass === null ? undefined : popperClass" @prev-click="elEmitPrevClick" @next-click="elEmitNextClick"></el-pagination>
#> </div>
#> <div id="pg1" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="pg1">{"x":{"el":"#pg1_container","data":{"total":100,"pageSize":10,"currentPage":1,"pageSizes":[10,20,30,50],"layout":"total, sizes, prev, pager, next, jumper","background":false,"small":false,"disabled":false,"pagerCount":7,"prevText":null,"nextText":null,"hideOnSinglePage":null,"pageCount":null,"popperClass":null},"methods":{"elEmitPrevClick":"function() { window.shinyElement.emit('pg1', 'prev_click', arguments); }","elEmitNextClick":"function() { window.shinyElement.emit('pg1', 'next_click', arguments); }","handlePageChange":"function(page) { window.Shiny && Shiny.setInputValue('pg1_page', page); }","handleSizeChange":"function(size) { window.Shiny && Shiny.setInputValue('pg1_size', size); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"pg1_page\", self.currentPage); window.Shiny && Shiny.setInputValue(\"pg1_size\", self.pageSize); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitPrevClick","methods.elEmitNextClick","methods.handlePageChange","methods.handleSizeChange","mounted"],"jsHooks":[]}</script>

# With custom page sizes and layout
el_pagination(
  "pg2",
  total      = 500,
  page_size  = 20,
  page_sizes = c(10, 20, 50, 100),
  layout     = "total, sizes, prev, pager, next"
)
#> <div id="pg2_container" style="display: contents">
#>   <el-pagination :total="total" :page-size="pageSize" :current-page.sync="currentPage" :page-sizes="pageSizes" :layout="layout" :background="background" :small="small" :disabled="disabled" :pager-count="pagerCount" @current-change="handlePageChange" @size-change="handleSizeChange" :prev-text="prevText === null ? undefined : prevText" :next-text="nextText === null ? undefined : nextText" :hide-on-single-page="hideOnSinglePage === null ? undefined : hideOnSinglePage" :page-count="pageCount === null ? undefined : pageCount" :popper-class="popperClass === null ? undefined : popperClass" @prev-click="elEmitPrevClick" @next-click="elEmitNextClick"></el-pagination>
#> </div>
#> <div id="pg2" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="pg2">{"x":{"el":"#pg2_container","data":{"total":500,"pageSize":20,"currentPage":1,"pageSizes":[10,20,50,100],"layout":"total, sizes, prev, pager, next","background":false,"small":false,"disabled":false,"pagerCount":7,"prevText":null,"nextText":null,"hideOnSinglePage":null,"pageCount":null,"popperClass":null},"methods":{"elEmitPrevClick":"function() { window.shinyElement.emit('pg2', 'prev_click', arguments); }","elEmitNextClick":"function() { window.shinyElement.emit('pg2', 'next_click', arguments); }","handlePageChange":"function(page) { window.Shiny && Shiny.setInputValue('pg2_page', page); }","handleSizeChange":"function(size) { window.Shiny && Shiny.setInputValue('pg2_size', size); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"pg2_page\", self.currentPage); window.Shiny && Shiny.setInputValue(\"pg2_size\", self.pageSize); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitPrevClick","methods.elEmitNextClick","methods.handlePageChange","methods.handleSizeChange","mounted"],"jsHooks":[]}</script>

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
      list(page = input$pg1_page, size = input$pg1_size)
    })
  }
  shinyApp(ui, server)
}
```
