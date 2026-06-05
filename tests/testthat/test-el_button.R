render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_button: returns a tagList", {
  btn <- el_button("btn1", "Click")
  expect_true(inherits(btn, "shiny.tag.list"))
})

test_that("el_button: container div has correct id", {
  btn <- el_button("btn1", "Click", session = NULL)
  html <- render_html(btn)
  expect_match(html, 'id="btn1_container"')
})

test_that("el_button: auto-generated id when NULL", {
  btn <- el_button(NULL, "Click", session = NULL)
  html <- render_html(btn)
  expect_match(html, 'id="el_button_.*_container"')
})

# ── 基本参数写入 Vue data ─────────────────────────────────────────────────────

test_that("el_button: label appears in Vue data", {
  btn  <- el_button("btn1", "Submit", session = NULL)
  html <- render_html(btn)
  expect_match(html, '"label"\\s*:\\s*"Submit"')
})

test_that("el_button: type appears in Vue data", {
  btn  <- el_button("btn1", type = "primary", session = NULL)
  html <- render_html(btn)
  expect_match(html, '"type"\\s*:\\s*"primary"')
})

test_that("el_button: size appears in Vue data when set", {
  btn  <- el_button("btn1", size = "small", session = NULL)
  html <- render_html(btn)
  expect_match(html, '"size"\\s*:\\s*"small"')
})

test_that("el_button: size NULL still included in Vue data as null", {
  btn  <- el_button("btn1", session = NULL)
  html <- render_html(btn)
  expect_match(html, '"size"\\s*:\\s*null')
})

# ── 新增参数 ──────────────────────────────────────────────────────────────────

test_that("el_button: plain=TRUE appears in Vue data", {
  btn  <- el_button("btn1", plain = TRUE, session = NULL)
  html <- render_html(btn)
  expect_match(html, '"plain"\\s*:\\s*true')
})

test_that("el_button: round=TRUE appears in Vue data", {
  btn  <- el_button("btn1", round = TRUE, session = NULL)
  html <- render_html(btn)
  expect_match(html, '"round"\\s*:\\s*true')
})

test_that("el_button: circle=TRUE appears in Vue data", {
  btn  <- el_button("btn1", circle = TRUE, session = NULL)
  html <- render_html(btn)
  expect_match(html, '"circle"\\s*:\\s*true')
})

test_that("el_button: loading=TRUE appears in Vue data", {
  btn  <- el_button("btn1", loading = TRUE, session = NULL)
  html <- render_html(btn)
  expect_match(html, '"loading"\\s*:\\s*true')
})

test_that("el_button: disabled=TRUE appears in Vue data", {
  btn  <- el_button("btn1", disabled = TRUE, session = NULL)
  html <- render_html(btn)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_button: native_type appears in Vue data", {
  btn  <- el_button("btn1", native_type = "submit", session = NULL)
  html <- render_html(btn)
  expect_match(html, '"native_type"\\s*:\\s*"submit"')
})

# ── circle 按钮 label 置空 ────────────────────────────────────────────────────

test_that("el_button: circle=TRUE forces label to empty string", {
  btn  <- el_button("btn1", label = "ShouldBeIgnored", circle = TRUE, session = NULL)
  html <- render_html(btn)
  expect_match(html, '"label"\\s*:\\s*""')
})

# ── icon ──────────────────────────────────────────────────────────────────────

test_that("el_button: icon tag rendered inside button", {
  btn  <- el_button("btn1", icon = el_icon("search"), session = NULL)
  html <- render_html(btn)
  expect_match(html, "el-icon-search")
})

test_that("el_button: NULL icon does not break output", {
  expect_silent(el_button("btn1", icon = NULL, session = NULL))
})

# ── Vue 属性绑定 ───────────────────────────────────────────────────────────────

test_that("el_button: :plain binding present on el-button tag", {
  btn  <- el_button("btn1", session = NULL)
  html <- render_html(btn)
  expect_match(html, ":plain")
})

test_that("el_button: :loading binding present on el-button tag", {
  btn  <- el_button("btn1", session = NULL)
  html <- render_html(btn)
  expect_match(html, ":loading")
})

test_that("el_button: :native-type binding present on el-button tag", {
  btn  <- el_button("btn1", session = NULL)
  html <- render_html(btn)
  expect_match(html, ":native-type")
})

# ── 向后兼容：与 el_button 相同的默认参数输出一致 ──────────────────────────────

test_that("el_button: same container id pattern as el_button", {
  old <- el_button("btn1", "Click", session = NULL)
  new <- el_button("btn1", "Click", session = NULL)
  expect_match(render_html(old), 'id="btn1_container"')
  expect_match(render_html(new), 'id="btn1_container"')
})

test_that("el_button: same label in Vue data as el_button", {
  old <- render_html(el_button("btn1", "Hello", session = NULL))
  new <- render_html(el_button("btn1", "Hello", session = NULL))
  expect_match(old, '"label"\\s*:\\s*"Hello"')
  expect_match(new, '"label"\\s*:\\s*"Hello"')
})

# ── update_el_button ──────────────────────────────────────────────────────

test_that("update_el_button: sends correct message with new fields", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_button(mock_session, "btn1",
    label   = "New Label",
    loading = TRUE,
    plain   = TRUE,
    round   = TRUE,
    size    = "mini"
  )
  expect_equal(captured$label,   "New Label")
  expect_true(captured$loading)
  expect_true(captured$plain)
  expect_true(captured$round)
  expect_equal(captured$size,    "mini")
})

test_that("update_el_button: NULL fields are excluded from message", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_button(mock_session, "btn1", label = "X")
  expect_equal(captured$label, "X")
  expect_null(captured$loading)
  expect_null(captured$plain)
})

test_that("update_el_button: all fields included when provided", {
  captured <- NULL
  mock_session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_button(mock_session, "btn1",
    label = "L", type = "primary", size = "small",
    plain = TRUE, round = TRUE, loading = FALSE, disabled = TRUE
  )
  expect_equal(captured$label,    "L")
  expect_equal(captured$type,     "primary")
  expect_equal(captured$size,     "small")
  expect_true(captured$plain)
  expect_true(captured$round)
  expect_false(captured$loading)
  expect_true(captured$disabled)
})
