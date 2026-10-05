# The Vue layer: Element-free, Vue's own names, Shiny's conventions.

html_of <- function(ui) {
  paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
}

test_that("the Vue layer knows no component library", {
  # It is to become a package of its own: nothing in it may name Element
  pkg <- testthat::test_path("..", "..")
  files <- c(
    list.files(
      file.path(pkg, "R"),
      pattern = "^vue_.*[.]R$",
      full.names = TRUE
    ),
    file.path(pkg, "inst", "js", "shiny-vue.js")
  )
  files <- files[file.exists(files)]
  skip_if(length(files) < 2, "sources not available")
  for (f in files) {
    hits <- grep(
      "\\bel_|\\bElement\\b|ElementPlus|shinyElement",
      readLines(f, warn = FALSE),
      value = TRUE
    )
    expect_equal(hits, character(0), info = basename(f))
  }
  # and loads none of it
  deps <- vapply(
    htmltools::findDependencies(vue_app("a", "<b/>")),
    `[[`,
    "",
    "name"
  )
  expect_setequal(deps, c("jquery", "vue", "shiny-vue"))
})

test_that("vue_app() writes Vue's options under Vue's names", {
  ui <- vue_app(
    "c",
    template = htmltools::tags$button(`@click` = "n++", "{{ n }}"),
    data = list(n = 0, rows = data.frame(a = 1:2)),
    methods = list(reset = JS("function() { this.n = 0; }")),
    emits = "picked",
    before_unmount = JS("function() {}"),
    inheritAttrs = FALSE,
    input = "n"
  )
  spec <- vue_spec_of(ui)
  opts <- spec$options
  expect_equal(spec$input, "n")
  expect_equal(unlist(opts$emits), "picked")
  # snake_case for one of Vue's multi-word options; Vue's name as is
  expect_true("beforeUnmount" %in% names(opts))
  expect_false(opts$inheritAttrs)
  # a data.frame is rows
  expect_equal(opts$data$rows[[2]]$a, 2)
  # no component library unless asked for
  expect_null(spec$use)
  expect_match(
    html_of(ui),
    '<button @click="n++">{{ n }}</button>',
    fixed = TRUE
  )
})

test_that("names the user chose are never renamed", {
  opts <- vue_spec_of(vue_app(
    "c",
    "<i/>",
    data = list(item_count = 1),
    methods = list(add_one = JS("function() {}"))
  ))$options
  expect_true("item_count" %in% names(opts$data))
  expect_true("add_one" %in% names(opts$methods))
})

test_that("two spellings of one option must agree", {
  expect_error(
    vue_app("c", "<i/>", before_unmount = JS("a"), beforeUnmount = JS("b")),
    "twice"
  )
})

test_that("input: a field, several, or one from setup()", {
  expect_error(
    vue_app("c", "<i/>", data = list(a = 1), input = "b"),
    "not a field"
  )
  two <- vue_spec_of(vue_app(
    "c",
    "<i/>",
    data = list(a = 1, b = 2),
    input = c("a", "b")
  ))
  expect_equal(two$input, "({a: a, b: b})")
  st <- vue_spec_of(vue_app(
    "c",
    "<i/>",
    setup = JS("function() {}"),
    input = "k"
  ))
  expect_equal(st$input, "k")
})

test_that("use: plugins by name, with options", {
  spec <- vue_spec_of(vue_app(
    "c",
    "<i/>",
    use = list(A = list(size = "small"), "B")
  ))
  expect_equal(spec$use[[1]], list(name = "A", options = list(size = "small")))
  expect_equal(spec$use[[2]], "B")
})

test_that("vue_component() is a child's options, its data a function", {
  child <- vue_component(
    template = htmltools::tags$li("{{ text }}"),
    props = "text",
    emits = "toggle",
    data = list(open = FALSE),
    before_mount = JS("function() {}")
  )
  expect_s3_class(child, "vue_component")
  expect_equal(child$template, "<li>{{ text }}</li>")
  expect_true(inherits(child$data, "JS_EVAL"))
  expect_match(child$data, '{"open":false}', fixed = TRUE)
  expect_true("beforeMount" %in% names(child))
  spec <- vue_spec_of(vue_app(
    "c",
    "<todo-item/>",
    components = list(todo_item = child)
  ))
  expect_true("options.components.todo_item.data" %in% unlist(spec$evals))
})

test_that("vue_store() is a host marked as a store", {
  spec <- vue_spec_of(vue_store("cart", data = list(n = 0), input = "n"))
  expect_true(spec$store)
  expect_equal(spec$input, "n")
})

test_that("update_vue() sends fields, and value for the input", {
  s <- mock_session()
  update_vue(s, "c", n = 1, rows = data.frame(a = 1), value = 3)
  msg <- s$captured()$msg
  expect_equal(msg$id, "c")
  expect_equal(msg$n, 1)
  expect_equal(rows_of(msg$rows)[[1]]$a, 1)
  expect_equal(msg$.value, 3)
  expect_error(update_vue(s, "c", 1), "named")
  expect_error(update_vue(NULL, "c", n = 1), "outside a Shiny session")
})

test_that("call_vue() and vue_answer() send what the bridge reads", {
  s <- mock_session()
  call_vue(s, "c", "getCheckedKeys", list(TRUE))
  msg <- s$captured()$msg
  expect_equal(s$captured()$type, "shinyVueCall")
  expect_equal(msg$input, "c_get_checked_keys")
  expect_error(call_vue(s, "c", "a;b"), "plain method name")
  vue_answer(s, "c", request = list(request = 4), value = c("x", "y"))
  expect_equal(
    s$captured()$msg$.resolve,
    list(request = 4, value = c("x", "y"))
  )
  vue_answer(s, "c", request = 5, failed = TRUE)
  expect_equal(s$captured()$msg$.resolve, list(request = 5, failed = TRUE))
})

test_that("call_el() is call_vue() under Element's name", {
  s <- mock_session()
  call_el(s, "t", "toggleRowSelection", list(el_table_row(2)))
  expect_equal(s$captured()$msg$args[[1]], list(.ref = "row", value = 2))
})
