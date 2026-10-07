render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── .el_has_class ─────────────────────────────────────────────────────────────

test_that(".el_has_class: matches a layout class on a tag", {
  expect_true(.el_has_class(el_header("x"), c("el-header", "el-footer")))
  expect_false(.el_has_class(el_main("x"), c("el-header", "el-footer")))
})

test_that(".el_has_class: non-tags are not matched", {
  expect_false(.el_has_class("plain string", "el-header"))
  expect_false(.el_has_class(NULL, "el-header"))
})

test_that(".el_has_class: an extra class does not confuse the match", {
  expect_true(.el_has_class(el_header("x", class = "mine"), "el-header"))
})

# ── el_container ──────────────────────────────────────────────────────────────

test_that("el_container: renders Element's section with the el-container class", {
  html <- render_html(el_container())
  expect_match(html, '<section class="el-container"')
  expect_false(grepl("<el-container", html, fixed = TRUE))
})

test_that("el_container: no Vue instance is created", {
  # A Vue instance mounted over a container rebuilds the DOM inside it and
  # detaches the components placed there.
  html <- render_html(el_container(el_main("x")))
  expect_false(grepl("application/json", html, fixed = TRUE))
})

test_that("el_container: a header or footer child makes it vertical", {
  expect_match(
    render_html(el_container(el_header("h"), el_main("m"))),
    "is-vertical"
  )
  expect_match(
    render_html(el_container(el_main("m"), el_footer("f"))),
    "is-vertical"
  )
})

test_that("el_container: aside plus main stays horizontal", {
  expect_false(grepl(
    "is-vertical",
    render_html(el_container(el_aside("a"), el_main("m")))
  ))
})

test_that("el_container: explicit direction overrides detection", {
  expect_false(grepl(
    "is-vertical",
    render_html(el_container(direction = "horizontal", el_header("h")))
  ))
  expect_match(
    render_html(el_container(direction = "vertical", el_main("m"))),
    "is-vertical"
  )
})

test_that("el_container: id is only emitted when supplied", {
  expect_match(render_html(el_container(id = "c1")), 'id="c1"')
  expect_false(grepl("id=", render_html(el_container()), fixed = TRUE))
})

test_that("el_container: nested widgets keep their html dependencies", {
  deps <- htmltools::findDependencies(
    el_container(el_header(el_switch("sw")), el_main(el_slider("sld")))
  )
  names <- vapply(deps, function(d) d$name, character(1))
  expect_true("shiny-vue" %in% names)
  expect_true("shiny-vue" %in% names)
})

# ── header / aside / main / footer ────────────────────────────────────────────

test_that("el_header: Element's <header>, its height as Element's variable", {
  # Element Plus sets --el-header-height, which its stylesheet reads
  expect_match(
    render_html(el_header("x")),
    '<header class="el-header" style="--el-header-height:60px">',
    fixed = TRUE
  )
  expect_match(
    render_html(el_header("x", height = "80px")),
    "--el-header-height:80px"
  )
})

test_that("el_aside: Element's <aside>, its width as Element's variable", {
  expect_match(
    render_html(el_aside("x")),
    '<aside class="el-aside" style="--el-aside-width:300px">',
    fixed = TRUE
  )
  expect_match(
    render_html(el_aside("x", width = "200px")),
    "--el-aside-width:200px"
  )
})

test_that("el_footer: Element's <footer>, its height as Element's variable", {
  expect_match(
    render_html(el_footer("x")),
    '<footer class="el-footer" style="--el-footer-height:60px">',
    fixed = TRUE
  )
})

test_that("el_main: carries no inline size", {
  html <- render_html(el_main("x"))
  expect_match(html, 'class="el-main"')
  expect_false(grepl("style=", html, fixed = TRUE))
})

test_that("container parts: extra style and class are merged", {
  html <- render_html(el_header("x", style = "color:red", class = "mine"))
  expect_match(html, 'class="el-header mine"')
  expect_match(html, "height:60px; color:red")
})

test_that("container parts: content is rendered inside", {
  expect_match(render_html(el_main("body text")), ">body text<")
})
