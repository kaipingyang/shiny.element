# vue_ref(), vue_reactive(), vue_computed(), vue_watch(): Vue's reactivity
# for the page, hosts with no markup the bridge makes the state in.

state_spec <- function(tag) {
  html <- paste(as.character(htmltools::renderTags(tag)$html), collapse = "")
  m <- regmatches(
    html,
    regexpr('application/json"[^>]*>.*?</script>', html, perl = TRUE)
  )
  jsonlite::fromJSON(
    sub("</script>$", "", sub('^application/json"[^>]*>', "", m)),
    simplifyVector = FALSE
  )
}

test_that("vue_ref() holds a value, reported when asked", {
  s <- state_spec(vue_ref("count", 1))
  expect_equal(s$state$kind, "ref")
  expect_equal(s$options$data$value, 1)
  expect_null(s$input)
  expect_equal(state_spec(vue_ref("count", 1, input = TRUE))$input, "value")
})

test_that("vue_reactive() holds an object of named fields", {
  s <- state_spec(vue_reactive(
    "form",
    list(name = "Ann", age = 3),
    input = TRUE
  ))
  expect_equal(s$state$kind, "reactive")
  expect_equal(s$options$data, list(name = "Ann", age = 3))
  expect_equal(s$input, "shinyVueValue")
  expect_error(vue_reactive("f", list(1, 2)), "named list")
})

test_that("vue_computed() is an expression, scoped in a module", {
  s <- state_spec(vue_computed("twice", "$vueRef.count * 2"))
  expect_equal(
    s$state,
    list(kind = "computed", expr = list(expr = "$vueRef.count * 2"))
  )
  s <- state_spec(vue_computed(
    "twice",
    "$vueRef.count * 2",
    ns = shiny::NS("m")
  ))
  expect_equal(s$state$expr$scope, list(inputs = "m-", store = "m-"))
  expect_error(vue_computed("x", ""), "one JavaScript expression")
})

test_that("vue_watch() runs a statement or a JS() function", {
  s <- state_spec(vue_watch(
    "$vueRef.count",
    "$vueRef.last = $value",
    immediate = TRUE
  ))
  expect_equal(s$state$kind, "watch")
  expect_equal(s$state$source, list(expr = "$vueRef.count"))
  expect_equal(s$state$handler, "$vueRef.last = $value")
  expect_true(s$state$statement)
  expect_true(s$state$immediate)
  expect_false(s$state$deep)
  s <- state_spec(vue_watch(
    "$vueRef.count",
    JS("function(v, old) { console.log(v); }")
  ))
  expect_false(s$state$statement)
  expect_true("state.handler" %in% unlist(s$evals))
  expect_error(
    vue_watch("$vueRef.count", 1),
    "inline statement, a string, or a JS"
  )
})
