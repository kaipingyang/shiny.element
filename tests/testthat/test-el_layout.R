render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── .el_style ─────────────────────────────────────────────────────────────────

test_that(".el_style: joins fragments with semicolons", {
  # htmltools::tagAppendAttributes() joins with a space, producing broken CSS.
  expect_equal(.el_style("color:red", "padding:1px"), "color:red; padding:1px")
})

test_that(".el_style: drops NULL and empty fragments", {
  expect_equal(.el_style(NULL, "color:red", ""), "color:red")
  expect_null(.el_style(NULL))
  expect_null(.el_style())
})

test_that(".el_style: strips a trailing semicolon before joining", {
  expect_equal(.el_style("color:red;", "padding:1px"), "color:red; padding:1px")
})

# ── el_row ────────────────────────────────────────────────────────────────────

test_that("el_row: renders a div with the el-row class, not a custom tag", {
  html <- render_html(el_row())
  expect_match(html, '<div class="el-row"')
  expect_false(grepl("<el-row", html, fixed = TRUE))
})

test_that("el_row: gutter sets negative margins and pads the columns", {
  html <- render_html(el_row(gutter = 20, el_col(span = 12, "a")))
  expect_match(html, "margin-left:-10px; margin-right:-10px")
  expect_match(html, "padding-left:10px; padding-right:10px")
})

test_that("el_row: zero or missing gutter adds no margins", {
  expect_false(grepl("margin-left", render_html(el_row(el_col(span = 12)))))
  expect_false(grepl("margin-left", render_html(el_row(gutter = 0, el_col()))))
})

test_that("el_row: gutter preserves a column's own style", {
  html <- render_html(el_row(gutter = 20, el_col(span = 12, style = "color:red")))
  expect_match(html, "color:red; padding-left:10px")
})

test_that("el_row: flex classes are only added for type = 'flex'", {
  html <- render_html(el_row(type = "flex", justify = "center", align = "middle"))
  expect_match(html, "el-row--flex")
  expect_match(html, "is-justify-center")
  expect_match(html, "is-align-middle")

  # justify/align are meaningless without flex and must not leak in
  plain <- render_html(el_row(justify = "center", align = "middle"))
  expect_false(grepl("is-justify", plain))
  expect_false(grepl("is-align", plain))
})

test_that("el_row: default justify/align add no class", {
  # Element UI ships no .is-justify-start or .is-align-top rule.
  html <- render_html(el_row(type = "flex", justify = "start", align = "top"))
  expect_false(grepl("is-justify-start", html))
  expect_false(grepl("is-align-top", html))
})

test_that("el_row: extra class and style are kept", {
  html <- render_html(el_row(class = "mine", style = "height:10px"))
  expect_match(html, 'class="el-row mine"')
  expect_match(html, "height:10px")
})

# ── el_col ────────────────────────────────────────────────────────────────────

test_that("el_col: renders a div with span class, defaulting to 24", {
  expect_match(render_html(el_col()), 'class="el-col el-col-24"')
  expect_match(render_html(el_col(span = 8)), 'class="el-col el-col-8"')
  expect_false(grepl("<el-col", render_html(el_col()), fixed = TRUE))
})

test_that("el_col: offset, push and pull each get their class", {
  html <- render_html(el_col(span = 6, offset = 6, push = 2, pull = 1))
  expect_match(html, "el-col-offset-6")
  expect_match(html, "el-col-push-2")
  expect_match(html, "el-col-pull-1")
})

test_that("el_col: a bare responsive value is treated as the span", {
  html <- render_html(el_col(xs = 24, sm = 12, md = 8, lg = 6, xl = 4))
  for (cls in c("el-col-xs-24", "el-col-sm-12", "el-col-md-8",
                "el-col-lg-6", "el-col-xl-4")) {
    expect_match(html, cls)
  }
})

test_that("el_col: a responsive list can carry offset/push/pull", {
  html <- render_html(el_col(md = list(span = 12, offset = 6, push = 1)))
  expect_match(html, "el-col-md-12")
  expect_match(html, "el-col-md-offset-6")
  expect_match(html, "el-col-md-push-1")
})

test_that("el_col: content is rendered inside", {
  expect_match(render_html(el_col(span = 12, "hello")), ">hello<")
})

# ── nesting ───────────────────────────────────────────────────────────────────

test_that("el_row: a nested widget keeps its html dependencies", {
  # The old custom-tag/template approach dropped these.
  deps <- htmltools::findDependencies(el_row(el_col(span = 12, el_switch("sw"))))
  expect_true("shiny-vue" %in% vapply(deps, function(d) d$name, character(1)))
})
