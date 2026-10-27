# Optional props: one group per tag, bound with v-bind="$optional('<group>')"

test_that("a group's map names each prop's field; unset is NA", {
  o <- .vue_optional_props(
    list(size = "small", placeholder = NULL, value_on_clear = JS("null")),
    "select"
  )
  expect_equal(
    o$map,
    list(
      select = list(
        size = "size",
        placeholder = "placeholder",
        `value-on-clear` = "valueOnClear"
      )
    )
  )
  expect_equal(o$data$size, "small")
  expect_identical(o$data$placeholder, NA)
  expect_s3_class(o$data$valueOnClear, "JS_EVAL")
})

test_that("prefix, rename and wrap shape the fields and entries", {
  o <- .vue_optional_props(
    list(placement = "top", width = 3, default_time = "12:00"),
    "tooltip",
    prefix = "tip",
    rename = c(width = "popper-width"),
    wrap = c(default_time = "elDate")
  )
  expect_named(o$map$tooltip, c("placement", "popper-width", "default-time"))
  expect_equal(o$map$tooltip$`popper-width`, "tipPopperWidth")
  expect_equal(
    o$map$tooltip$`default-time`,
    list(field = "tipDefaultTime", wrap = "elDate")
  )
  expect_named(o$data, c("tipPlacement", "tipPopperWidth", "tipDefaultTime"))
})

test_that("a group is a plain name, as a template reads it", {
  expect_error(.vue_optional_props(list(), "a'b"), "single name")
  expect_error(.vue_optional_props(list(), c("a", "b")), "single name")
  expect_equal(.vue_optional_props(list(), "a")$map, list(a = list()))
})

test_that("the binding goes first, merged with a v-bind already there", {
  expect_equal(
    .vue_bind_optional(list(class = "x"), "select"),
    list(`v-bind` = "$optional('select')", class = "x")
  )
  merged <- .vue_bind_optional(
    list(`v-bind` = "loadingAttrs", class = "x", `:size` = "s"),
    "table"
  )
  # one v-bind; the existing object spread last wins, and so does the
  # explicit binding after it
  expect_equal(names(merged), c("v-bind", "class", ":size"))
  expect_equal(merged$`v-bind`, "{...$optional('table'), ...(loadingAttrs)}")
  # children among the attributes are kept
  kept <- .vue_bind_optional(list(htmltools::tags$b()), "a")
  expect_length(kept, 2)
})

test_that("the spec carries the groups, and JS(\"null\") to revive", {
  o <- .vue_optional_props(list(label = JS("null"), note = NULL), "box")
  host <- .vue_app_spec(
    "x",
    "<b/>",
    data = o$data,
    options = list(),
    input = NULL,
    use = NULL,
    dependencies = NULL,
    optional = o$map
  )
  json <- jsonlite::fromJSON(
    .vue_json(attr(host, "vue_host")$spec),
    simplifyVector = FALSE
  )
  expect_equal(json$optional, list(box = list(label = "label", note = "note")))
  expect_null(json$options$data$note)
  expect_true("options.data.label" %in% unlist(json$evals))
})
