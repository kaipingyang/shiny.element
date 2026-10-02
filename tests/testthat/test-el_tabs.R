render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

demo_tabs <- list(
  list(name = "a", label = "First",  content = shiny::tags$p("One")),
  list(name = "b", label = "Second", content = shiny::tags$p("Two")),
  list(name = "c", label = "Third",  content = "Three", disabled = TRUE)
)

# ── markup ────────────────────────────────────────────────────────────────────

test_that("el_tabs: renders plain markup with no Vue instance", {
  # A Vue instance would rebuild the DOM inside the panes, detaching whatever
  # is in them from the server.
  html <- render_html(el_tabs("t1", tabs = demo_tabs))
  expect_false(grepl("application/json", html, fixed = TRUE))
  expect_false(grepl("html-widget", html, fixed = TRUE))
  expect_false(grepl("<el-tabs", html, fixed = TRUE))
})

test_that("el_tabs: reproduces Element's own structure", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs))
  for (cls in c("el-tabs__header", "el-tabs__nav-wrap", "el-tabs__nav-scroll",
                "el-tabs__nav", "el-tabs__item", "el-tabs__content", "el-tab-pane")) {
    expect_match(html, cls, fixed = TRUE)
  }
  expect_match(html, 'role="tablist"', fixed = TRUE)
  expect_match(html, 'role="tabpanel"', fixed = TRUE)
})

test_that("el_tabs: loads the input binding, not a message handler", {
  deps  <- htmltools::findDependencies(el_tabs("t1", tabs = demo_tabs))
  names <- vapply(deps, function(d) d$name, character(1))
  expect_true("el-tabs-binding" %in% names)
  expect_false("shiny-vue" %in% names)
})

test_that("el_tabs: the selected tab is marked and its pane shown", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs, selected = "b"))
  expect_match(html, 'class="el-tabs__item is-top is-active" data-el-name="b"', fixed = TRUE)
  expect_match(html, 'aria-selected="true"', fixed = TRUE)
  # A hidden pane keeps its component mounted; a removed one would not.
  expect_match(html, 'style="display:none" data-el-name="a"', fixed = TRUE)
  expect_match(html, "<p>One</p>", fixed = TRUE)
})

test_that("el_tabs: selection defaults to the first tab", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs))
  expect_match(html, 'is-active" data-el-name="a"', fixed = TRUE)
})

test_that("el_tabs: an unknown selection falls back to the first tab", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs, selected = "nope"))
  expect_match(html, 'is-active" data-el-name="a"', fixed = TRUE)
})

test_that("el_tabs: disabled tabs are marked", {
  expect_match(render_html(el_tabs("t1", tabs = demo_tabs)),
               "el-tabs__item is-top is-disabled", fixed = TRUE)
})

# ── variants ──────────────────────────────────────────────────────────────────

test_that("el_tabs: the card types carry no active bar", {
  # Element shows the active card by its own border instead.
  plain <- render_html(el_tabs("t1", tabs = demo_tabs))
  expect_match(plain, "el-tabs__active-bar", fixed = TRUE)

  for (ty in c("card", "border-card")) {
    html <- render_html(el_tabs("t1", tabs = demo_tabs, type = ty))
    expect_match(html, paste0("el-tabs--", ty), fixed = TRUE)
    expect_false(grepl("el-tabs__active-bar", html, fixed = TRUE))
  }
})

test_that("el_tabs: position sets the root class and every is- modifier", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs, tab_position = "left"))
  expect_match(html, "el-tabs--left", fixed = TRUE)
  expect_match(html, "el-tabs__header is-left", fixed = TRUE)
  expect_match(html, "el-tabs__nav is-left", fixed = TRUE)
  expect_match(html, "el-tabs__item is-left", fixed = TRUE)
  expect_match(html, 'data-position="left"', fixed = TRUE)
})

test_that("el_tabs: closable adds the marker and the close icon", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs, closable = TRUE))
  expect_match(html, "is-closable", fixed = TRUE)
  expect_match(html, '<span class="el-icon-close"></span>', fixed = TRUE)

  expect_false(grepl("el-icon-close", render_html(el_tabs("t1", tabs = demo_tabs)),
                     fixed = TRUE))
})

test_that("el_tabs: stretch is a class on the nav", {
  expect_match(render_html(el_tabs("t1", tabs = demo_tabs, stretch = TRUE)),
               "el-tabs__nav is-top is-stretch", fixed = TRUE)
})

test_that("el_tabs: the binding is told whether there is a bar to move", {
  expect_match(render_html(el_tabs("t1", tabs = demo_tabs)),
               'data-carded="false"', fixed = TRUE)
  expect_match(render_html(el_tabs("t1", tabs = demo_tabs, type = "card")),
               'data-carded="true"', fixed = TRUE)
})

test_that("el_tabs: nested components keep their own dependencies", {
  deps <- htmltools::findDependencies(el_tabs("t1", tabs = list(
    list(name = "a", label = "A", content = el_switch("sw"))
  )))
  names <- vapply(deps, function(d) d$name, character(1))
  expect_true("shiny-vue" %in% names)
  expect_true("el-tabs-binding" %in% names)
})

test_that("el_tabs: an empty tabset still renders", {
  html <- render_html(el_tabs("t1"))
  expect_match(html, 'class="el-tabs el-tabs--top"', fixed = TRUE)
  expect_false(grepl("el-tabs__item", html, fixed = TRUE))
})

# ── update_el_tabs ────────────────────────────────────────────────────────────

test_that("update_el_tabs: sends an input message, not a custom message", {
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendInputMessage = function(id, msg) sent <<- list(id = id, msg = msg),
    sendCustomMessage = function(type, msg) stop("should not be used")
  )
  update_el_tabs(session, "t1", selected = "b")
  expect_equal(sent$id, "t1")
  expect_equal(sent$msg$selected, "b")
})

test_that("the binding positions the bar from rendered width", {
  js <- paste(readLines(
    system.file("js", "el-tabs-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  # The bar's size depends on the active label's rendered width, so no CSS
  # class could express it -- Element sets it inline too.
  expect_match(js, "offsetWidth", fixed = TRUE)
  expect_match(js, "offsetLeft", fixed = TRUE)
  # Vertical positions use the other axis.
  expect_match(js, "translateY", fixed = TRUE)
  # And it has to be redone when the layout changes.
  expect_match(js, "resize.elTabs", fixed = TRUE)
})

test_that("the binding reports back after an update and on close", {
  js <- paste(readLines(
    system.file("js", "el-tabs-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  expect_match(js, "elTabsChange", fixed = TRUE)
  expect_match(js, "_tab_remove", fixed = TRUE)
  # The close button sits inside the tab, so its click must not also select it.
  expect_match(js, "stopPropagation", fixed = TRUE)
})

# ── adding, removing, lazy panes ──────────────────────────────────────────────

test_that("el_tabs: addable draws the new-tab button, editable implies closable", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs, addable = TRUE))
  expect_match(html, "el-tabs__new-tab", fixed = TRUE)
  expect_false(grepl("is-closable", html, fixed = TRUE))

  html <- render_html(el_tabs("t1", tabs = demo_tabs, editable = TRUE))
  expect_match(html, "el-tabs__new-tab", fixed = TRUE)
  expect_match(html, "is-closable", fixed = TRUE)
})

test_that("el_tabs: a closable tab can be set one at a time", {
  tabs <- demo_tabs
  tabs[[2]]$closable <- TRUE
  html <- render_html(el_tabs("t1", tabs = tabs))
  expect_match(html, 'is-closable" data-el-name="b"|data-el-name="b"[^>]*is-closable', perl = TRUE)
  expect_equal(lengths(regmatches(html, gregexpr("el-icon-close", html))), 1L)
})

test_that("el_tabs: a lazy pane holds its content in a template until shown", {
  tabs <- demo_tabs
  tabs[[2]]$lazy <- TRUE
  html <- render_html(el_tabs("t1", tabs = tabs, selected = "a"))
  expect_match(html, '<template data-el-lazy="true">\\s*<p>Two</p>', perl = TRUE)

  # Already selected, there is nothing to defer
  html <- render_html(el_tabs("t1", tabs = tabs, selected = "b"))
  expect_false(grepl("data-el-lazy", html, fixed = TRUE))
})

test_that("el_tabs: before_leave travels as source for the binding", {
  html <- render_html(el_tabs("t1", tabs = demo_tabs,
    before_leave = JS("function(to, from) { return to !== 'c'; }")))
  expect_match(html, "data-before-leave=\"function(to, from)", fixed = TRUE)
})

test_that("insert_el_tab: inserts the pane, then adds and selects the header", {
  inserted <- NULL
  local_mocked_bindings(insertUI = function(selector, where, ui, ...) {
    inserted <<- list(selector = selector, where = where, ui = ui)
  }, .package = "shiny")
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendInputMessage = function(id, msg) sent <<- list(id = id, msg = msg)
  )

  insert_el_tab(session, "t1", "new", "New tab", content = shiny::tags$p("Fresh"))
  expect_equal(inserted$selector, "#t1 > .el-tabs__content")
  expect_equal(inserted$where, "beforeEnd")
  expect_match(render_html(inserted$ui), 'data-el-name="new"', fixed = TRUE)
  expect_match(render_html(inserted$ui), "<p>Fresh</p>", fixed = TRUE)

  expect_equal(sent$id, "t1")
  expect_equal(sent$msg$add_tab$name, "new")
  expect_equal(sent$msg$add_tab$label, "New tab")
  expect_equal(sent$msg$selected, "new")

  insert_el_tab(session, "t1", "quiet", "Quiet", select = FALSE)
  expect_null(sent$msg$selected)
})

test_that("remove_el_tab: asks the binding to remove the tab", {
  sent <- NULL
  session <- list(ns = function(id) id,
                  sendInputMessage = function(id, msg) sent <<- list(id = id, msg = msg))
  remove_el_tab(session, "t1", "b")
  expect_equal(sent, list(id = "t1", msg = list(remove_tab = "b")))
})

test_that("the binding reports Element's tab events", {
  js <- paste(readLines(
    system.file("js", "el-tabs-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  for (ev in c("'_tab_click'", "'_tab_remove'", "'_tab_add'", "'_edit'")) {
    expect_match(js, ev, fixed = TRUE)
  }
  # Inserted and lazy content is bound like any other
  expect_match(js, "Shiny.bindAll", fixed = TRUE)
  expect_match(js, "Shiny.unbindAll", fixed = TRUE)
})
