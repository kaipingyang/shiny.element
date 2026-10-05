render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) {
      captured <<- list(type = type, msg = msg)
    }
  )
  expr(session)
  captured
}

demo_items <- list(
  list(content = "Placed", timestamp = "2026-03-01", type = "primary"),
  list(
    content = "Shipped",
    timestamp = "2026-03-02",
    icon = "el-icon-check",
    size = "large",
    color = "#0bbd87"
  ),
  list(content = "No timestamp")
)

# ── .el_timeline_items ────────────────────────────────────────────────────────

test_that(".el_timeline_items: unset fields are dropped, not nulled", {
  # A v-for binding reading a missing property gets undefined, which is what
  # makes Element use a prop's default. Sending null instead broke `placement`:
  # null matches neither 'top' nor 'bottom', so the timestamp rendered nowhere.
  out <- .el_timeline_items(list(list(content = "x")))
  expect_named(out[[1]], "content")
  expect_false("placement" %in% names(out[[1]]))
  expect_false("timestamp" %in% names(out[[1]]))
})

test_that(".el_timeline_items: fields that are set come through", {
  out <- .el_timeline_items(demo_items)
  expect_equal(out[[1]]$content, "Placed")
  expect_equal(out[[1]]$type, "primary")
  expect_equal(out[[2]]$color, "#0bbd87")
  expect_equal(out[[2]]$size, "large")
})

test_that(".el_timeline_items: unknown keys are ignored", {
  out <- .el_timeline_items(list(list(content = "x", nonsense = 1)))
  expect_false("nonsense" %in% names(out[[1]]))
})

test_that(".el_timeline_items: an empty list stays empty", {
  expect_length(.el_timeline_items(list()), 0)
})

# ── el_timeline ───────────────────────────────────────────────────────────────

test_that("el_timeline: returns a tagList with the container id", {
  t <- el_timeline(id = "log", items = demo_items)
  expect_true(inherits(t, "shiny.tag.list"))
  expect_match(render_html(t), 'id="log_container"')
})

test_that("el_timeline: attaches the shared bridge", {
  deps <- htmltools::findDependencies(el_timeline(id = "log"))
  expect_true("shiny-vue" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("el_timeline: entries render through one v-for so they stay replaceable", {
  html <- render_html(el_timeline(id = "log", items = demo_items))
  expect_match(html, 'v-for="(item, index) in items"', fixed = TRUE)
  expect_match(html, ':timestamp="item.timestamp"', fixed = TRUE)
  expect_match(html, ':type="item.type"', fixed = TRUE)
  expect_match(html, ':placement="item.placement"', fixed = TRUE)
})

test_that("el_timeline: the timestamp is hidden when asked, or when there is none", {
  expect_match(
    render_html(el_timeline(id = "log")),
    ':hide-timestamp="item.hide_timestamp != null ? item.hide_timestamp : !item.timestamp"',
    fixed = TRUE
  )
})

test_that("el_timeline: entries reach the Vue data", {
  html <- render_html(el_timeline(id = "log", items = demo_items))
  expect_match(html, '"content":"Placed"', fixed = TRUE)
  expect_match(html, '"color":"#0bbd87"', fixed = TRUE)
})

test_that("el_timeline: content is text by default and HTML on request", {
  plain <- render_html(el_timeline(id = "log", items = demo_items))
  expect_match(plain, "{{ item.content }}", fixed = TRUE)
  expect_false(grepl("v-html", plain, fixed = TRUE))

  # v-html does not escape, hence the documented warning.
  rich <- render_html(el_timeline(id = "log", items = demo_items, html = TRUE))
  expect_match(rich, 'v-html="item.content"', fixed = TRUE)
  expect_false(grepl("{{ item.content }}", rich, fixed = TRUE))
})

test_that("el_timeline: reverse is bound", {
  expect_match(
    render_html(el_timeline(id = "log")),
    ':reverse="reverse"',
    fixed = TRUE
  )
  expect_match(
    render_html(el_timeline(id = "log", reverse = TRUE)),
    '"reverse":true'
  )
})

test_that("el_timeline: an empty timeline still renders", {
  html <- render_html(el_timeline(id = "log"))
  expect_match(html, "<el-timeline")
  expect_match(html, '"items":\\[\\]')
})

test_that("el_timeline: is display-only, with no Shiny input", {
  # Nothing to select or type into, so it reports nothing.
  html <- render_html(el_timeline(id = "log", items = demo_items))
  expect_false(grepl("setInputValue", html, fixed = TRUE))
})

# ── update_el_timeline ────────────────────────────────────────────────────────

test_that("update_el_timeline: sends under the right message type", {
  out <- sent_message(function(s) {
    update_el_timeline(s, "log", items = demo_items)
  })
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg$id, "log")
  expect_length(out$msg$items, 3)
  expect_equal(out$msg$items[[1]]$content, "Placed")
})

test_that("update_el_timeline: entries are normalised on the way out too", {
  out <- sent_message(function(s) {
    update_el_timeline(
      s,
      "log",
      items = list(list(content = "x", nonsense = 1))
    )
  })
  expect_named(out$msg$items[[1]], "content")
})

test_that("update_el_timeline: reverse passes through", {
  out <- sent_message(function(s) update_el_timeline(s, "log", reverse = TRUE))
  expect_true(out$msg$reverse)
  expect_null(out$msg$items)
})

test_that("update_el_timeline: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_timeline(s, "log", items = list()))
  expect_equal(out$msg$items, list())
  expect_null(out$msg$reverse)
})
