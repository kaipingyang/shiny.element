#' Element UI Pagination Component
#'
#' Creates an Element UI pagination bar with page navigation, size selector,
#' jump-to-page input, and total count display.
#'
#' @param id Pagination ID. Auto-generated UUID if `NULL`.
#' @param total Total item count (required).
#' @param page_size Items per page. Default `10`.
#' @param current_page Current page number (1-based). Default `1`.
#' @param page_sizes Vector of page-size options. Default `c(10, 20, 30, 50)`.
#' @param layout Comma-separated list of layout elements.
#'   Default `"total, sizes, prev, pager, next, jumper"`.
#' @param background Whether to use background colour on page buttons. Default `FALSE`.
#' @param small Whether to use compact (small) mode. Default `FALSE`.
#' @param disabled Whether the pagination is disabled. Default `FALSE`.
#' @param pager_count Number of pager buttons to show. Default `7`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed pagination component.
#'
#' @section Shiny inputs:
#' \describe{
#'   \item{`input$<id>_page`}{Current page number (integer).}
#'   \item{`input$<id>_size`}{Current page size (integer).}
#' }
#'
#' @examples
#' # Basic usage
#' el_pagination("pg1", total = 100)
#'
#' # With custom page sizes and layout
#' el_pagination(
#'   "pg2",
#'   total      = 500,
#'   page_size  = 20,
#'   page_sizes = c(10, 20, 50, 100),
#'   layout     = "total, sizes, prev, pager, next"
#' )
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_pagination("pg1", total = 200),
#'     verbatimTextOutput("page_info")
#'   )
#'   server <- function(input, output, session) {
#'     output$page_info <- renderPrint({
#'       list(page = input$pg1_page, size = input$pg1_size)
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_pagination <- function(
    id           = NULL,
    total,
    page_size    = 10,
    current_page = 1,
    page_sizes   = c(10, 20, 30, 50),
    layout       = "total, sizes, prev, pager, next, jumper",
    background   = FALSE,
    small        = FALSE,
    disabled     = FALSE,
    pager_count  = 7,
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_pagination_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  pagination_attrs <- list(
    ":total"             = "total",
    ":page-size"         = "pageSize",
    ":current-page.sync" = "currentPage",
    ":page-sizes"        = "pageSizes",
    ":layout"            = "layout",
    ":background"        = "background",
    ":small"             = "small",
    ":disabled"          = "disabled",
    ":pager-count"       = "pagerCount",
    "@current-change"    = "handlePageChange",
    "@size-change"       = "handleSizeChange"
  )

  vue_data <- list(
    total       = total,
    pageSize    = page_size,
    currentPage = current_page,
    pageSizes   = as.list(page_sizes),
    layout      = layout,
    background  = background,
    small       = small,
    disabled    = disabled,
    pagerCount  = pager_count
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-pagination", pagination_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handlePageChange = htmlwidgets::JS(sprintf(
            "function(page) { Shiny.setInputValue('%s_page', page); }",
            ns_id
          )),
          handleSizeChange = htmlwidgets::JS(sprintf(
            "function(size) { Shiny.setInputValue('%s_size', size); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_pagination_handler_dependency())
}


#' Update Element UI Pagination
#'
#' Server-side update for [el_pagination()].
#'
#' @param session Shiny session object.
#' @param id Pagination ID (un-namespaced).
#' @param total New total item count.
#' @param current_page New current page number.
#' @param page_size New page size.
#' @param disabled New disabled state.
#'
#' @export
update_el_pagination <- function(
    session,
    id,
    total        = NULL,
    current_page = NULL,
    page_size    = NULL,
    disabled     = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(total))        msg$total       <- total
  if (!is.null(current_page)) msg$currentPage <- current_page
  if (!is.null(page_size))    msg$pageSize    <- page_size
  if (!is.null(disabled))     msg$disabled    <- disabled
  session$sendCustomMessage("updateElPagination", msg)
}


#' Pagination Handler Dependency
#' @keywords internal
el_pagination_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-pagination-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-pagination-handler.js",
    all_files = FALSE
  )
}
