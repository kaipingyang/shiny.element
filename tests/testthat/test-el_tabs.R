render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

tabs_fixture <- list(
  list(name = "tab1", label = "Tab 1", content = shiny::tags$p("Content 1")),
  list(name = "tab2", label = "Tab 2", content = shiny::tags$p("Content 2")),
  list(name = "tab3", label = "Tab 3", disabled = TRUE)
)

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_tabs: returns a tagList", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  expect_true(inherits(result, "shiny.tag.list"))
})

test_that("el_tabs: container div has correct id", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, 'id="tabs1_container"')
})

test_that("el_tabs: auto-generated id when NULL", {
  result <- el_tabs(NULL, tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, 'id="el_tabs_.*_container"')
})

# ── Vue data ────────────────────────────────────────────────────────────────

test_that("el_tabs: activeTab defaults to first tab name", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, '"activeTab"\\s*:\\s*"tab1"')
})

test_that("el_tabs: activeTab uses selected when provided", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, selected = "tab2", session = NULL)
  html   <- render_html(result)
  expect_match(html, '"activeTab"\\s*:\\s*"tab2"')
})

test_that("el_tabs: tabPosition in Vue data", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, tab_position = "left", session = NULL)
  html   <- render_html(result)
  expect_match(html, '"tabPosition"\\s*:\\s*"left"')
})

test_that("el_tabs: stretch in Vue data", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, stretch = TRUE, session = NULL)
  html   <- render_html(result)
  expect_match(html, '"stretch"\\s*:\\s*true')
})

# ── el-tab-pane tags ─────────────────────────────────────────────────────────

test_that("el_tabs: el-tab-pane tags are rendered", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, "el-tab-pane")
})

test_that("el_tabs: tab name attribute present", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, 'name="tab1"')
  expect_match(html, 'name="tab2"')
})

test_that("el_tabs: tab label attribute present", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, 'label="Tab 1"')
  expect_match(html, 'label="Tab 2"')
})

test_that("el_tabs: disabled attribute present on disabled tab", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  # tab3 is disabled=TRUE; htmltools renders NA boolean attr as the attr name only
  expect_match(html, "disabled")
})

# ── Vue 属性绑定 ──────────────────────────────────────────────────────────────

test_that("el_tabs: v-model binding present", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, 'v-model="activeTab"')
})

test_that("el_tabs: :tab-position binding present", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, ':tab-position="tabPosition"')
})

test_that("el_tabs: @tab-click binding present", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, session = NULL)
  html   <- render_html(result)
  expect_match(html, '@tab-click="handleTabClick"')
})

test_that("el_tabs: type attribute set when provided", {
  result <- el_tabs("tabs1", tabs = tabs_fixture, type = "card", session = NULL)
  html   <- render_html(result)
  expect_match(html, 'type="card"')
})

# ── update_el_tabs ────────────────────────────────────────────────────────────

test_that("update_el_tabs: sends activeTab in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_tabs(mock_session, "tabs1", selected = "tab2")
  expect_equal(captured$activeTab, "tab2")
})

test_that("update_el_tabs: id included in message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_tabs(mock_session, "tabs1", selected = "tab1")
  expect_equal(captured$id, "tabs1")
})

test_that("update_el_tabs: NULL selected sends only id", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_tabs(mock_session, "tabs1")
  expect_null(captured$activeTab)
  expect_equal(captured$id, "tabs1")
})
