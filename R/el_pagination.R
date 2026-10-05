#' Element Plus Pagination Component
#'
#' Creates an Element Plus pagination bar with page navigation, size selector,
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
#' @param append_size_to Which element the size dropdown appends to. Element
#'   Plus's `append-size-to` (string).
#' @param default_current_page Default initial value of current-page, not
#'   setting is the same as setting 1. Element Plus's `default-current-page`
#'   (number).
#' @param default_page_size Default initial value of page size, not setting is
#'   the same as setting 10. Element Plus's `default-page-size` (number).
#' @param next_icon Icon for the next button, has a lower priority than
#'   `next-text`. Element Plus's `next-icon` (string / Component). An icon's
#'   name, such as `"Search"`.
#' @param popper_style Custom style for the page size Select's dropdown.
#'   Element Plus's `popper-style` (string / object).
#' @param prev_icon Icon for the prev button, has a lower priority than
#'   `prev-text`. Element Plus's `prev-icon` (string / Component). An icon's
#'   name, such as `"Search"`.
#' @param size Pagination size. Element Plus's `size` ('large' | 'default' |
#'   'small').
#' @param teleported Whether Pagination select dropdown is teleported to the
#'   body. Element Plus's `teleported` (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param prev_text Text of the previous-page button, in place of the arrow icon.
#' @param next_text Text of the next-page button, in place of the arrow icon.
#' @param hide_on_single_page Whether to hide the pager when there is only one page.
#' @param page_count Total page count. Set either this or `total`.
#' @param popper_class Extra class name for the page-size dropdown.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed pagination component.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the current page, 1-based, on load and on change.
#' - `input$<id>_size` -- the page size, on load and on change.
#'
#' @examples
#' # Basic usage
#' el_pagination("pg1", total = 100)
#'
#' # With custom page sizes and layout
#' el_pagination(
#'   "pg2",
#'   total = 500,
#'   page_size = 20,
#'   page_sizes = c(10, 20, 50, 100),
#'   layout = "total, sizes, prev, pager, next"
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
#'       list(page = input$pg1, size = input$pg1_size)
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_pagination <- function(
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
  session = NULL
) {
  .el_check_choices("el_pagination", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_pagination")
  }
  ns_id <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")
  # The page is the value, restored by el_widget(); the size beside it
  page_size <- shiny::restoreInput(paste0(ns_id, "_size"), page_size)

  pagination_attrs <- list(
    ":total" = "total",
    "v-model:page-size" = "pageSize",
    "v-model:current-page" = "currentPage",
    ":page-sizes" = "pageSizes",
    ":layout" = "layout",
    ":background" = "background",
    ":small" = "small",
    ":disabled" = "disabled",
    ":pager-count" = "pagerCount",
    "@current-change" = "handlePageChange",
    "@size-change" = "handleSizeChange"
  )

  pagination_attrs[[":prev-text"]] <- .el_optional_bind("prevText")

  pagination_attrs[[":next-text"]] <- .el_optional_bind("nextText")

  pagination_attrs[[":hide-on-single-page"]] <- .el_optional_bind(
    "hideOnSinglePage"
  )

  pagination_attrs[[":page-count"]] <- .el_optional_bind("pageCount")

  pagination_attrs[[":popper-class"]] <- .el_optional_bind("popperClass")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().

  events <- .el_event_bindings(
    ns_id,
    c(
      "prev-click",

      "next-click",
      "change"
    )
  )

  pagination_attrs <- c(pagination_attrs, events$attrs)

  vue_data <- list(
    total = total,
    pageSize = page_size,
    currentPage = current_page,
    pageSizes = as.list(page_sizes),
    layout = layout,
    background = background,
    small = small,
    disabled = disabled,
    pagerCount = pager_count
  )

  vue_data$prevText <- .el_or_na(prev_text)

  vue_data$nextText <- .el_or_na(next_text)

  vue_data$hideOnSinglePage <- .el_or_na(hide_on_single_page)

  vue_data$pageCount <- .el_or_na(page_count)

  vue_data$popperClass <- .el_or_na(popper_class)

  el_widget(
    props = .el_props(list(
      append_size_to = append_size_to,
      default_current_page = default_current_page,
      default_page_size = default_page_size,
      next_icon = .el_icon_name(next_icon),
      popper_style = popper_style,
      prev_icon = .el_icon_name(prev_icon),
      size = size,
      teleported = teleported
    )),
    id = ns_id,
    markup = htmltools::tag("el-pagination", pagination_attrs),
    data = vue_data,
    methods = c(
      events$methods,
      list(
        handlePageChange = JS(sprintf(
          "function(page) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', page); }",
          ns_id
        )),
        handleSizeChange = JS(sprintf(
          "function(size) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_size', size); }",
          ns_id
        ))
      )
    ),
    mounted = .el_mounted_init(stats::setNames(
      c("currentPage", "pageSize"),
      paste0(ns_id, c("", "_size"))
    )),
    width = width,
    slots = slots
  )
}


#' Update Element Plus Pagination
#'
#' Server-side update for [el_pagination()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Pagination ID (un-namespaced).
#' @param total New total item count.
#' @param current_page New current page number.
#' @param page_size New page size.
#' @param disabled New disabled state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_pagination(session, "pager", current_page = 2)
#'   })
#' }
#' @export
update_el_pagination <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  total = NULL,
  current_page = NULL,
  page_size = NULL,
  disabled = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(total)) {
    msg$total <- total
  }
  if (!is.null(current_page)) {
    msg$currentPage <- current_page
  }
  if (!is.null(page_size)) {
    msg$pageSize <- page_size
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
