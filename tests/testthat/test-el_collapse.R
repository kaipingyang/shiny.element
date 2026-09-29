render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

demo_items <- list(
  list(name = "p1", title = "First",  content = shiny::tags$p("One")),
  list(name = "p2", title = "Second", content = shiny::tags$p("Two")),
  list(name = "p3", title = "Third",  content = "Three", disabled = TRUE)
)

# ── markup ────────────────────────────────────────────────────────────────────

test_that("el_collapse: renders plain markup with no Vue instance", {
  # A Vue instance mounted here would rebuild the DOM inside the panels,
  # detaching any nested component from its registration.
  html <- render_html(el_collapse("c1", items = demo_items))
  expect_false(grepl("application/json", html, fixed = TRUE))
  expect_false(grepl("html-widget", html, fixed = TRUE))
  expect_false(grepl("<el-collapse", html, fixed = TRUE))
})

test_that("el_collapse: carries Element's own classes", {
  html <- render_html(el_collapse("c1", items = demo_items))
  expect_match(html, 'class="el-collapse"', fixed = TRUE)
  expect_match(html, "el-collapse-item__header", fixed = TRUE)
  expect_match(html, "el-collapse-item__wrap", fixed = TRUE)
  expect_match(html, "el-collapse-item__content", fixed = TRUE)
  expect_match(html, "el-collapse-item__arrow el-icon-arrow-right", fixed = TRUE)
})

test_that("el_collapse: the binding finds it by a data attribute", {
  html <- render_html(el_collapse("c1", items = demo_items))
  expect_match(html, 'data-el-collapse="true"', fixed = TRUE)
  expect_match(html, 'id="c1"', fixed = TRUE)
  # Panels are keyed by name, which is what the input reports.
  expect_match(html, 'data-el-name="p1"', fixed = TRUE)
})

test_that("el_collapse: loads the input binding, not a message handler", {
  deps  <- htmltools::findDependencies(el_collapse("c1", items = demo_items))
  names <- vapply(deps, function(d) d$name, character(1))
  expect_true("el-collapse-binding" %in% names)
  expect_false("el-collapse-handler" %in% names)
})

test_that("el_collapse: open panels are marked on all three elements", {
  html <- render_html(el_collapse("c1", items = demo_items, value = "p1"))
  # Element styles the item, its header and its arrow separately.
  expect_match(html, 'class="el-collapse-item is-active" data-el-name="p1"', fixed = TRUE)
  expect_match(html, 'class="el-collapse-item__header is-active"', fixed = TRUE)
  expect_match(html, 'el-icon-arrow-right is-active', fixed = TRUE)
})

test_that("el_collapse: a closed panel is hidden, not removed", {
  # Removing it would unmount any nested component; hiding keeps it alive.
  html <- render_html(el_collapse("c1", items = demo_items, value = "p1"))
  expect_match(html, 'class="el-collapse-item__wrap" style="display:none"', fixed = TRUE)
  expect_match(html, "<p>Two</p>", fixed = TRUE)
})

test_that("el_collapse: disabled panels are marked", {
  html <- render_html(el_collapse("c1", items = demo_items))
  expect_match(html, "el-collapse-item is-disabled", fixed = TRUE)
  expect_match(html, "el-collapse-item__header is-disabled", fixed = TRUE)
})

test_that("el_collapse: accordion mode is declared and caps the open set", {
  html <- render_html(el_collapse("c1", items = demo_items, accordion = TRUE,
                                  value = c("p1", "p2")))
  expect_match(html, 'data-accordion="true"', fixed = TRUE)
  # Only the first survives; two open panels is not an accordion.
  expect_equal(
    lengths(regmatches(html, gregexpr("el-collapse-item is-active", html, fixed = TRUE)))[[1]],
    1L
  )
})

test_that("el_collapse: default is multi-open", {
  expect_match(render_html(el_collapse("c1", items = demo_items)),
               'data-accordion="false"', fixed = TRUE)
})

test_that("el_collapse: nested components keep their own dependencies", {
  deps <- htmltools::findDependencies(el_collapse("c1", items = list(
    list(name = "p", title = "T", content = el_switch("sw"))
  )))
  names <- vapply(deps, function(d) d$name, character(1))
  expect_true("el-switch-handler" %in% names)
  expect_true("el-collapse-binding" %in% names)
})

test_that("el_collapse: an empty collapse still renders", {
  html <- render_html(el_collapse("c1"))
  expect_match(html, 'class="el-collapse"', fixed = TRUE)
  expect_false(grepl("el-collapse-item", html, fixed = TRUE))
})

# ── update_el_collapse ────────────────────────────────────────────────────────

test_that("update_el_collapse: sends an input message, not a custom message", {
  # The binding owns the element, so Shiny routes the message to it by id.
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendInputMessage = function(id, msg) sent <<- list(id = id, msg = msg),
    sendCustomMessage = function(type, msg) stop("should not be used")
  )
  update_el_collapse(session, "c1", value = c("p1", "p2"))
  expect_equal(sent$id, "c1")
  expect_equal(sent$msg$value, list("p1", "p2"))
})

test_that("update_el_collapse: an empty vector closes everything", {
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendInputMessage = function(id, msg) sent <<- msg
  )
  update_el_collapse(session, "c1", value = character(0))
  # list() rather than NULL, so the message still carries a value to apply.
  expect_equal(sent$value, list())
})

test_that("the binding reports back after an update", {
  js <- paste(readLines(
    system.file("js", "el-collapse-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  # receiveMessage has no callback of its own; without raising an event the
  # panels move while input$<id> keeps its old value.
  expect_match(js, "elCollapseChange", fixed = TRUE)
  expect_match(js, "Shiny.inputBindings.register", fixed = TRUE)
})

test_that("the binding degrades gracefully outside Shiny", {
  js <- paste(readLines(
    system.file("js", "el-collapse-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  expect_match(js, "typeof Shiny === 'undefined'", fixed = TRUE)
})
