render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_select: returns a tagList", {
  sel <- el_select("sel1", choices = c(A = "a", B = "b"))
  expect_true(inherits(sel, "shiny.tag.list"))
})

test_that("el_select: container div has correct id", {
  sel  <- el_select("sel1", choices = c(A = "a"), session = NULL)
  html <- render_html(sel)
  expect_match(html, 'id="sel1_container"')
})

test_that("el_select: auto-generated id when NULL", {
  sel  <- el_select(NULL, choices = c(A = "a"), session = NULL)
  html <- render_html(sel)
  expect_match(html, 'id="el_select_.*_container"')
})

# ── options 写入 Vue data ─────────────────────────────────────────────────────

test_that("el_select: named vector choices normalised to value/label pairs", {
  sel  <- el_select("s1", choices = c(Apple = "apple", Banana = "banana"), session = NULL)
  html <- render_html(sel)
  expect_match(html, '"value"\\s*:\\s*"apple"')
  expect_match(html, '"label"\\s*:\\s*"Apple"')
})

test_that("el_select: list of list choices passed through unchanged", {
  opts <- list(list(value = "x", label = "X"), list(value = "y", label = "Y"))
  sel  <- el_select("s1", choices = opts, session = NULL)
  html <- render_html(sel)
  expect_match(html, '"value"\\s*:\\s*"x"')
  expect_match(html, '"label"\\s*:\\s*"X"')
})

test_that("el_select: unnamed vector uses element as both value and label", {
  sel  <- el_select("s1", choices = c("alpha", "beta"), session = NULL)
  html <- render_html(sel)
  expect_match(html, '"value"\\s*:\\s*"alpha"')
  expect_match(html, '"label"\\s*:\\s*"alpha"')
})

# ── selected 初始值 ───────────────────────────────────────────────────────────

test_that("el_select: selected=NULL single defaults to empty string in Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), multiple = FALSE, session = NULL)
  html <- render_html(sel)
  # value field should be ""
  expect_match(html, '"value"\\s*:\\s*""')
})

test_that("el_select: selected=NULL multiple defaults to empty array in Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), multiple = TRUE, session = NULL)
  html <- render_html(sel)
  # value should be []
  expect_match(html, '"value"\\s*:\\s*\\[\\]')
})

test_that("el_select: selected value written to Vue data", {
  sel  <- el_select("s1", choices = c(A = "a", B = "b"), selected = "b", session = NULL)
  html <- render_html(sel)
  expect_match(html, '"value"\\s*:\\s*"b"')
})

# ── multiple 参数 ─────────────────────────────────────────────────────────────

test_that("el_select: multiple=FALSE written to Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), multiple = FALSE, session = NULL)
  html <- render_html(sel)
  expect_match(html, '"multiple"\\s*:\\s*false')
})

test_that("el_select: multiple=TRUE written to Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), multiple = TRUE, session = NULL)
  html <- render_html(sel)
  expect_match(html, '"multiple"\\s*:\\s*true')
})

# ── @change 绑定 ─────────────────────────────────────────────────────────────

test_that("el_select: @change binding present on el-select tag", {
  sel  <- el_select("s1", choices = c(A = "a"), session = NULL)
  html <- render_html(sel)
  expect_match(html, "@change")
})

test_that("el_select: handleChange uses correct Shiny id", {
  sel  <- el_select("s1", choices = c(A = "a"), session = NULL)
  html <- render_html(sel)
  expect_match(html, "Shiny.setInputValue\\('s1'")
})

# ── v-for 选项槽 ──────────────────────────────────────────────────────────────

test_that("el_select: v-for attribute present on el-option", {
  sel  <- el_select("s1", choices = c(A = "a"), session = NULL)
  html <- render_html(sel)
  expect_match(html, "v-for")
  expect_match(html, "opt in options")
})

# ── disabled / clearable / filterable ────────────────────────────────────────

test_that("el_select: disabled=TRUE written to Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), disabled = TRUE, session = NULL)
  html <- render_html(sel)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_select: clearable=TRUE written to Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), clearable = TRUE, session = NULL)
  html <- render_html(sel)
  expect_match(html, '"clearable"\\s*:\\s*true')
})

test_that("el_select: filterable=TRUE written to Vue data", {
  sel  <- el_select("s1", choices = c(A = "a"), filterable = TRUE, session = NULL)
  html <- render_html(sel)
  expect_match(html, '"filterable"\\s*:\\s*true')
})

# ── size / placeholder ────────────────────────────────────────────────────────

test_that("el_select: size written to Vue data when provided", {
  sel  <- el_select("s1", choices = c(A = "a"), size = "small", session = NULL)
  html <- render_html(sel)
  expect_match(html, '"size"\\s*:\\s*"small"')
})

test_that("el_select: placeholder written to Vue data when provided", {
  sel  <- el_select("s1", choices = c(A = "a"), placeholder = "Choose...", session = NULL)
  html <- render_html(sel)
  expect_match(html, '"placeholder"\\s*:\\s*"Choose\\.\\.\\."')
})

# ── update_el_select ──────────────────────────────────────────────────────────

test_that("update_el_select: sends correct message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_select(mock_session, "s1", value = "b", disabled = TRUE)
  expect_equal(captured$value,    "b")
  expect_true(captured$disabled)
})

test_that("update_el_select: NULL fields excluded from message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_select(mock_session, "s1", value = "a")
  expect_equal(captured$value, "a")
  expect_null(captured$disabled)
  expect_null(captured$placeholder)
})

test_that("update_el_select: options normalised when named vector passed", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_select(mock_session, "s1", options = c(Cat = "cat", Dog = "dog"))
  expect_equal(captured$options[[1]]$value, "cat")
  expect_equal(captured$options[[1]]$label, "Cat")
})

test_that("update_el_select: all fields sent when provided", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_select(
    mock_session, "s1",
    value       = "x",
    disabled    = FALSE,
    placeholder = "Pick one",
    clearable   = TRUE,
    filterable  = TRUE
  )
  expect_equal(captured$value,       "x")
  expect_false(captured$disabled)
  expect_equal(captured$placeholder, "Pick one")
  expect_true(captured$clearable)
  expect_true(captured$filterable)
})

test_that("el_select renders option groups from a named list, as Shiny does", {
  ui <- el_select("g", choices = list(
    Fruit = c(Apple = "a", Pear = "p"),
    Veg   = list(label = "Vegetables", disabled = TRUE, options = c(Kale = "k"))
  ))
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, "<el-option-group", fixed = TRUE)
  d <- vue_data_of(ui)
  expect_equal(d$options, list())
  expect_equal(d$groups[[1]]$label, "Fruit")
  expect_equal(d$groups[[1]]$options[[2]], list(value = "p", label = "Pear"))
  expect_equal(d$groups[[2]]$label, "Vegetables")
  expect_true(d$groups[[2]]$disabled)
})

test_that("a single option can be disabled", {
  html <- paste(as.character(el_select("s", choices = c(A = "a"))), collapse = "")
  expect_match(html, ':disabled="opt.disabled"', fixed = TRUE)
})

# ── Shiny's names and Element's ───────────────────────────────────────────────

test_that("el_select takes choices/selected or options/value alike", {
  shiny_way   <- vue_data_of(el_select("s", choices = c(A = "a", B = "b"), selected = "b"))
  element_way <- vue_data_of(el_select("s", options = c(A = "a", B = "b"), value = "b"))
  mixed       <- vue_data_of(el_select("s", choices = c(A = "a", B = "b"), value = "b"))
  expect_identical(shiny_way, element_way)
  expect_identical(shiny_way, mixed)
  expect_equal(shiny_way$value, "b")
})

test_that("positional calls are unchanged by the second names", {
  d <- vue_data_of(el_select("s", c(A = "a", B = "b"), "b"))
  expect_equal(d$value, "b")
  expect_equal(length(d$options), 2L)
})

test_that("two different values under the two names are an error", {
  expect_error(el_select("s", c(A = "a"), selected = "a", value = "b"),
               "`selected` and `value` are the same argument")
  expect_error(el_select("s", choices = c(A = "a"), options = c(B = "b")),
               "`choices` and `options` are the same argument")
  # The same value twice says one thing
  expect_no_error(el_select("s", c(A = "a"), selected = "a", value = "a"))
})

test_that("a select may start with no choices, for remote search", {
  expect_equal(vue_data_of(el_select("s", remote = TRUE))$options, list())
})

test_that("update_el_select takes both names and the remote-search state", {
  s <- mock_session()
  update_el_select(s, "s1", selected = "b", choices = c(Cat = "cat"))
  a <- s$captured()$msg
  update_el_select(s, "s1", value = "b", options = c(Cat = "cat"))
  expect_identical(a, s$captured()$msg)
  expect_equal(a$value, "b")
  expect_error(update_el_select(s, "s1", selected = "a", value = "b"),
               "same argument")

  update_el_select(s, "s1", loading = TRUE, loading_text = "Searching",
                   no_match_text = "None", no_data_text = "Empty",
                   multiple_limit = 2)
  expect_equal(s$captured()$msg,
               list(id = "s1", multipleLimit = 2, loading = TRUE,
                    loadingText = "Searching", noMatchText = "None",
                    noDataText = "Empty"))
})

test_that("every field update_el_select sets is declared on the instance", {
  s <- mock_session()
  update_el_select(s, "s1", selected = "a", choices = c(A = "a"), disabled = TRUE,
                   placeholder = "p", clearable = TRUE, filterable = TRUE,
                   multiple_limit = 1, loading = TRUE, loading_text = "l",
                   no_match_text = "m", no_data_text = "d")
  fields <- setdiff(names(s$captured()$msg), "id")
  expect_true(all(fields %in% names(vue_data_of(el_select("s1", c(A = "a"))))))
})
