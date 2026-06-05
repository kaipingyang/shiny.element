render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# ── 基础结构 ─────────────────────────────────────────────────────────────────

test_that("el_input: returns a tagList", {
  inp <- el_input("inp1")
  expect_true(inherits(inp, "shiny.tag.list"))
})

test_that("el_input: container div has correct id", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, 'id="inp1_container"')
})

test_that("el_input: auto-generated id when NULL", {
  inp  <- el_input(NULL, session = NULL)
  html <- render_html(inp)
  expect_match(html, 'id="el_input_.*_container"')
})

# ── Vue data 核心字段 ──────────────────────────────────────────────────────────

test_that("el_input: value appears in Vue data", {
  inp  <- el_input("inp1", value = "hello", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"value"\\s*:\\s*"hello"')
})

test_that("el_input: type appears in Vue data", {
  inp  <- el_input("inp1", type = "textarea", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"type"\\s*:\\s*"textarea"')
})

test_that("el_input: disabled=TRUE appears in Vue data", {
  inp  <- el_input("inp1", disabled = TRUE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"disabled"\\s*:\\s*true')
})

test_that("el_input: disabled=FALSE appears in Vue data", {
  inp  <- el_input("inp1", disabled = FALSE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"disabled"\\s*:\\s*false')
})

test_that("el_input: readonly=TRUE appears in Vue data", {
  inp  <- el_input("inp1", readonly = TRUE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"readonly"\\s*:\\s*true')
})

test_that("el_input: clearable=TRUE appears in Vue data", {
  inp  <- el_input("inp1", clearable = TRUE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"clearable"\\s*:\\s*true')
})

test_that("el_input: showPassword appears in Vue data", {
  inp  <- el_input("inp1", show_password = TRUE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"showPassword"\\s*:\\s*true')
})

test_that("el_input: showWordLimit appears in Vue data", {
  inp  <- el_input("inp1", show_word_limit = TRUE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"showWordLimit"\\s*:\\s*true')
})

test_that("el_input: autosize=TRUE appears in Vue data", {
  inp  <- el_input("inp1", autosize = TRUE, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"autosize"\\s*:\\s*true')
})

test_that("el_input: prefixIcon appears in Vue data", {
  inp  <- el_input("inp1", prefix_icon = "el-icon-search", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"prefixIcon"\\s*:\\s*"el-icon-search"')
})

test_that("el_input: suffixIcon appears in Vue data", {
  inp  <- el_input("inp1", suffix_icon = "el-icon-date", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"suffixIcon"\\s*:\\s*"el-icon-date"')
})

# ── 条件字段：非 NULL 时出现，NULL 时不出现 ───────────────────────────────────

test_that("el_input: size appears in Vue data when set", {
  inp  <- el_input("inp1", size = "small", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"size"\\s*:\\s*"small"')
})

test_that("el_input: size absent from Vue data when NULL", {
  inp  <- el_input("inp1", size = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl('"size"', html))
})

test_that("el_input: maxlength appears in Vue data when set", {
  inp  <- el_input("inp1", maxlength = 100, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"maxlength"\\s*:\\s*100')
})

test_that("el_input: maxlength absent from Vue data when NULL", {
  inp  <- el_input("inp1", maxlength = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl('"maxlength"', html))
})

test_that("el_input: rows appears in Vue data when set", {
  inp  <- el_input("inp1", rows = 4, session = NULL)
  html <- render_html(inp)
  expect_match(html, '"rows"\\s*:\\s*4')
})

test_that("el_input: rows absent from Vue data when NULL", {
  inp  <- el_input("inp1", rows = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl('"rows"', html))
})

test_that("el_input: placeholder appears in Vue data when set", {
  inp  <- el_input("inp1", placeholder = "Enter text", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"placeholder"\\s*:\\s*"Enter text"')
})

test_that("el_input: placeholder absent from Vue data when NULL", {
  inp  <- el_input("inp1", placeholder = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl('"placeholder"', html))
})

test_that("el_input: label appears in Vue data when set", {
  inp  <- el_input("inp1", label = "Name", session = NULL)
  html <- render_html(inp)
  expect_match(html, '"label"\\s*:\\s*"Name"')
})

test_that("el_input: label absent from Vue data when NULL", {
  inp  <- el_input("inp1", label = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl('"label"', html))
})

# ── 条件属性：非 NULL 时绑定属性出现，NULL 时不出现 ───────────────────────────

test_that("el_input: :size attr present when size set", {
  inp  <- el_input("inp1", size = "mini", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":size")
})

test_that("el_input: :size attr absent when size is NULL", {
  inp  <- el_input("inp1", size = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl(":size", html, fixed = TRUE))
})

test_that("el_input: :placeholder attr absent when placeholder is NULL", {
  inp  <- el_input("inp1", placeholder = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl(":placeholder", html, fixed = TRUE))
})

test_that("el_input: :placeholder attr present when set", {
  inp  <- el_input("inp1", placeholder = "Search", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":placeholder")
})

test_that("el_input: :maxlength attr absent when NULL", {
  inp  <- el_input("inp1", maxlength = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl(":maxlength", html, fixed = TRUE))
})

test_that("el_input: :rows attr absent when NULL", {
  inp  <- el_input("inp1", rows = NULL, session = NULL)
  html <- render_html(inp)
  expect_false(grepl(":rows", html, fixed = TRUE))
})

# ── 常驻 Vue 属性绑定 ──────────────────────────────────────────────────────────

test_that("el_input: v-model binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, "v-model")
})

test_that("el_input: :type binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":type")
})

test_that("el_input: :disabled binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":disabled")
})

test_that("el_input: :clearable binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":clearable")
})

test_that("el_input: :show-password binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":show-password")
})

test_that("el_input: :show-word-limit binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":show-word-limit")
})

test_that("el_input: :autosize binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":autosize")
})

test_that("el_input: @change binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, "@change")
})

test_that("el_input: :prefix-icon binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":prefix-icon")
})

test_that("el_input: :suffix-icon binding present", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, ":suffix-icon")
})

# ── handleChange 使用正确的 ns_id ────────────────────────────────────────────

test_that("el_input: handleChange references correct ns_id", {
  inp  <- el_input("inp1", session = NULL)
  html <- render_html(inp)
  expect_match(html, "setInputValue\\('inp1'")
})

# ── update_el_input ───────────────────────────────────────────────────────────

test_that("update_el_input: sends correct message with value", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_input(mock_session, "inp1", value = "new text")
  expect_equal(captured$id,    "inp1")
  expect_equal(captured$value, "new text")
})

test_that("update_el_input: sends multiple fields", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_input(mock_session, "inp1",
    value       = "x",
    placeholder = "hint",
    disabled    = TRUE,
    readonly    = FALSE,
    type        = "textarea",
    size        = "small",
    clearable   = TRUE
  )
  expect_equal(captured$value,       "x")
  expect_equal(captured$placeholder, "hint")
  expect_true(captured$disabled)
  expect_false(captured$readonly)
  expect_equal(captured$type,      "textarea")
  expect_equal(captured$size,      "small")
  expect_true(captured$clearable)
})

test_that("update_el_input: NULL fields excluded from message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_input(mock_session, "inp1", value = "only value")
  expect_equal(captured$value, "only value")
  expect_null(captured$placeholder)
  expect_null(captured$disabled)
  expect_null(captured$type)
  expect_null(captured$size)
})

test_that("update_el_input: show_password maps to showPassword in message", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) id,
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_input(mock_session, "inp1", show_password = TRUE)
  expect_true(captured$showPassword)
})

test_that("update_el_input: uses session$ns for id namespacing", {
  captured     <- NULL
  mock_session <- list(
    ns                = function(id) paste0("module-", id),
    sendCustomMessage = function(type, msg) { captured <<- msg }
  )
  update_el_input(mock_session, "inp1", value = "v")
  expect_equal(captured$id, "module-inp1")
})
