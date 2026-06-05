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
  session = shiny::getDefaultReactiveDomain()
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

- session:

  Shiny session for module support.

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
#> <div id="pg1_container">
#>   <el-pagination :total="total" :page-size="pageSize" :current-page.sync="currentPage" :page-sizes="pageSizes" :layout="layout" :background="background" :small="small" :disabled="disabled" :pager-count="pagerCount" @current-change="handlePageChange" @size-change="handleSizeChange"></el-pagination>
#> </div>
#> <div class="vue html-widget html-fill-item" id="pg1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="pg1">{"x":{"el":"#pg1_container","data":{"total":100,"pageSize":10,"currentPage":1,"pageSizes":[10,20,30,50],"layout":"total, sizes, prev, pager, next, jumper","background":false,"small":false,"disabled":false,"pagerCount":7},"methods":{"handlePageChange":"function(page) { Shiny.setInputValue('pg1_page', page); }","handleSizeChange":"function(size) { Shiny.setInputValue('pg1_size', size); }"}},"evals":["methods.handlePageChange","methods.handleSizeChange"],"jsHooks":[]}</script>

# With custom page sizes and layout
el_pagination(
  "pg2",
  total      = 500,
  page_size  = 20,
  page_sizes = c(10, 20, 50, 100),
  layout     = "total, sizes, prev, pager, next"
)
#> <div id="pg2_container">
#>   <el-pagination :total="total" :page-size="pageSize" :current-page.sync="currentPage" :page-sizes="pageSizes" :layout="layout" :background="background" :small="small" :disabled="disabled" :pager-count="pagerCount" @current-change="handlePageChange" @size-change="handleSizeChange"></el-pagination>
#> </div>
#> <div class="vue html-widget html-fill-item" id="pg2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="pg2">{"x":{"el":"#pg2_container","data":{"total":500,"pageSize":20,"currentPage":1,"pageSizes":[10,20,50,100],"layout":"total, sizes, prev, pager, next","background":false,"small":false,"disabled":false,"pagerCount":7},"methods":{"handlePageChange":"function(page) { Shiny.setInputValue('pg2_page', page); }","handleSizeChange":"function(size) { Shiny.setInputValue('pg2_size', size); }"}},"evals":["methods.handlePageChange","methods.handleSizeChange"],"jsHooks":[]}</script>

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
