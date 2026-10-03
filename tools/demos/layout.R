## basic-layout
cell <- function(dark = FALSE) {
  tags$div(
    class = "grid-content",
    style = sprintf(
      "border-radius: 4px; min-height: 36px; background: %s",
      if (dark) "#99a9bf" else "#d3dce6"
    )
  )
}
row <- function(...) el_row(style = "margin-bottom: 20px", ...)
tagList(
  row(el_col(span = 24, cell(TRUE))),
  row(lapply(1:2, function(i) el_col(span = 12, cell(i == 2)))),
  row(lapply(1:3, function(i) el_col(span = 8, cell(i == 2)))),
  row(lapply(1:4, function(i) el_col(span = 6, cell(i %% 2 == 0)))),
  row(lapply(1:6, function(i) el_col(span = 4, cell(i %% 2 == 0))))
)

## column-spacing
cell <- tags$div(
  style = "border-radius: 4px; min-height: 36px; background: #d3dce6"
)
el_row(gutter = 20, lapply(1:4, function(i) el_col(span = 6, cell)))

## hybrid-layout
cell <- tags$div(
  style = "border-radius: 4px; min-height: 36px; background: #d3dce6"
)
tagList(
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 16, cell),
    el_col(span = 8, cell)
  ),
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 8, cell),
    el_col(span = 8, cell),
    el_col(span = 4, cell),
    el_col(span = 4, cell)
  ),
  el_row(
    gutter = 20,
    el_col(span = 4, cell),
    el_col(span = 16, cell),
    el_col(span = 4, cell)
  )
)

## column-offset
cell <- tags$div(
  style = "border-radius: 4px; min-height: 36px; background: #d3dce6"
)
tagList(
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 6, cell),
    el_col(span = 6, offset = 6, cell)
  ),
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 6, offset = 6, cell),
    el_col(span = 6, offset = 6, cell)
  ),
  el_row(gutter = 20, el_col(span = 12, offset = 6, cell))
)

## alignment
cell <- function(light = FALSE) {
  tags$div(
    style = sprintf(
      "border-radius: 4px; min-height: 36px; background: %s",
      if (light) "#e5e9f2" else "#d3dce6"
    )
  )
}
cols <- function() {
  list(
    el_col(span = 6, cell()),
    el_col(span = 6, cell(TRUE)),
    el_col(span = 6, cell())
  )
}
tagList(lapply(
  c("start", "center", "end", "space-between", "space-around", "space-evenly"),
  function(j) {
    el_row(
      justify = j,
      style = "margin-bottom: 20px; background: #f9fafc",
      cols()
    )
  }
))

## responsive-layout
cell <- function(light = FALSE) {
  tags$div(
    style = sprintf(
      "border-radius: 4px; min-height: 36px; background: %s",
      if (light) "#e5e9f2" else "#d3dce6"
    )
  )
}
el_row(
  gutter = 10,
  el_col(xs = 8, sm = 6, md = 4, lg = 3, xl = 1, cell()),
  el_col(xs = 4, sm = 6, md = 8, lg = 9, xl = 11, cell(TRUE)),
  el_col(xs = 4, sm = 6, md = 8, lg = 9, xl = 11, cell()),
  el_col(xs = 8, sm = 6, md = 4, lg = 3, xl = 1, cell(TRUE))
)
