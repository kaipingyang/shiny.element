## basic-usage
tags$div(
  style = "display: grid; gap: 16px",
  tags$div("When you have few pages"),
  el_pagination("pg1", layout = "prev, pager, next", total = 50),
  tags$div("When you have more than 7 pages"),
  el_pagination("pg2", layout = "prev, pager, next", total = 1000)
)

## number-of-pagers
el_pagination(
  "pg_pagers",
  page_size = 20,
  pager_count = 11,
  layout = "prev, pager, next",
  total = 1000
)

## background-color
el_pagination(
  "pg_bg",
  background = TRUE,
  layout = "prev, pager, next",
  total = 1000
)

## small-pagination
tags$div(
  style = "display: grid; gap: 16px",
  el_pagination(
    "pg_s1",
    size = "small",
    layout = "prev, pager, next",
    total = 50
  ),
  el_pagination(
    "pg_s2",
    size = "small",
    background = TRUE,
    layout = "prev, pager, next",
    total = 50
  )
)

## auto-hide-pagination
el_pagination(
  "pg_hide",
  hide_on_single_page = FALSE,
  total = 5,
  layout = "prev, pager, next"
)

## more-elements
tags$div(
  style = "display: grid; gap: 16px",
  tags$div("Total item count"),
  el_pagination(
    "pg_m1",
    current_page = 5,
    page_size = 100,
    layout = "total, prev, pager, next",
    total = 1000
  ),
  tags$div("Change page size"),
  el_pagination(
    "pg_m2",
    current_page = 5,
    page_size = 100,
    page_sizes = c(100, 200, 300, 400),
    layout = "sizes, prev, pager, next",
    total = 1000
  ),
  tags$div("Jump to"),
  el_pagination(
    "pg_m3",
    current_page = 5,
    page_size = 100,
    layout = "prev, pager, next, jumper",
    total = 1000
  ),
  tags$div("All combined"),
  el_pagination(
    "pg_m4",
    current_page = 4,
    page_size = 100,
    page_sizes = c(100, 200, 300, 400),
    layout = "total, sizes, prev, pager, next, jumper",
    total = 400
  )
)
