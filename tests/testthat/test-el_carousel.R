render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

demo_items <- list(
  list(name = "one", content = shiny::tags$h3("First")),
  list(name = "two", content = "Second"),
  list(content = "No name")
)

test_that("el_carousel: returns a tagList with the container id", {
  c1 <- el_carousel(id = "banner", items = demo_items)
  expect_true(inherits(c1, "shiny.tag.list"))
  expect_match(render_html(c1), 'id="banner_container"')
})

test_that("el_carousel: attaches its own handler dependency", {
  deps <- htmltools::findDependencies(el_carousel(id = "banner"))
  expect_true("el-carousel-handler" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("el_carousel: one el-carousel-item per slide, with its markup", {
  # Generated in R rather than with v-for, so a slide can hold any htmltools
  # markup rather than only a string.
  html <- render_html(el_carousel(id = "banner", items = demo_items))
  expect_equal(lengths(regmatches(html, gregexpr("<el-carousel-item", html, fixed = TRUE)))[[1]], 3L)
  expect_match(html, "<h3>First</h3>", fixed = TRUE)
  expect_match(html, "Second", fixed = TRUE)
})

test_that("el_carousel: the carousel is named so the handler can reach it", {
  # setActiveItem() is the only way to change slides; see the handler.
  expect_match(render_html(el_carousel(id = "banner")), 'ref="carousel"', fixed = TRUE)
})

test_that("el_carousel: options reach the Vue data", {
  html <- render_html(el_carousel(
    id = "banner", items = demo_items, height = "180px", initial_index = 1,
    autoplay = FALSE, interval = 5000, trigger = "click", loop = FALSE,
    direction = "vertical"
  ))
  expect_match(html, '"height":"180px"')
  expect_match(html, '"initialIndex":1')
  expect_match(html, '"autoplay":false')
  expect_match(html, '"interval":5000')
  expect_match(html, '"trigger":"click"')
  expect_match(html, '"loop":false')
  expect_match(html, '"direction":"vertical"')
})

test_that("el_carousel: type and indicator position fall back to Element's", {
  plain <- render_html(el_carousel(id = "banner"))
  expect_match(plain, '"carouselType":null', fixed = TRUE)
  expect_match(plain, '"indicatorPosition":null', fixed = TRUE)
  expect_match(plain, .el_optional_bind("carouselType"), fixed = TRUE)

  set <- render_html(el_carousel(id = "banner", type = "card",
                                 indicator_position = "outside"))
  expect_match(set, '"carouselType":"card"', fixed = TRUE)
  expect_match(set, '"indicatorPosition":"outside"', fixed = TRUE)
})

test_that("el_carousel: slide names are carried so the index can be named", {
  html <- render_html(el_carousel(id = "banner", items = demo_items))
  expect_match(html, '"itemNames":\\["one","two",""\\]')
  # A slide without a name reports an empty string rather than dropping out.
  expect_match(html, '"activeName":"one"')
})

test_that("el_carousel: activeName tracks initial_index", {
  html <- render_html(el_carousel(id = "banner", items = demo_items, initial_index = 1))
  expect_match(html, '"active":1')
  expect_match(html, '"activeName":"two"')
})

test_that("el_carousel: an out-of-range initial index leaves the name empty", {
  html <- render_html(el_carousel(id = "banner", items = demo_items, initial_index = 9))
  expect_match(html, '"activeName":""')
})

test_that("el_carousel: reports both index and name", {
  html <- render_html(el_carousel(id = "banner", items = demo_items))
  expect_match(html, "banner_name", fixed = TRUE)
  expect_match(html, '"mounted"')
})

test_that("el_carousel: an empty carousel still renders", {
  html <- render_html(el_carousel(id = "banner"))
  expect_match(html, "<el-carousel")
  expect_false(grepl("<el-carousel-item", html, fixed = TRUE))
})

# ── update_el_carousel ────────────────────────────────────────────────────────

test_that("update_el_carousel: sends under the right message type", {
  out <- sent_message(function(s) update_el_carousel(s, "banner", active = 2))
  expect_equal(out$type, "updateElCarousel")
  expect_equal(out$msg$id, "banner")
  expect_equal(out$msg$active, 2)
})

test_that("update_el_carousel: slide 0 is sent, not treated as absent", {
  out <- sent_message(function(s) update_el_carousel(s, "banner", active = 0))
  expect_equal(out$msg$active, 0)
})

test_that("update_el_carousel: autoplay and interval pass through", {
  out <- sent_message(function(s) {
    update_el_carousel(s, "banner", autoplay = FALSE, interval = 8000)
  })
  expect_false(out$msg$autoplay)
  expect_equal(out$msg$interval, 8000)
})

test_that("update_el_carousel: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_carousel(s, "banner", active = 1))
  expect_null(out$msg$autoplay)
  expect_null(out$msg$interval)
})

test_that("the carousel handler moves slides through setActiveItem", {
  js <- paste(readLines(
    system.file("js", "el-carousel-handler.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  # initial-index is read once at mount and has no watcher, so assigning it
  # moves nothing.
  expect_match(js, "setActiveItem", fixed = TRUE)
})
