# .vue_json(): yyjsonr writes what jsonlite wrote -- the same values once
# parsed -- for every component's options and for the awkward values.

jsonlite_json <- function(spec) {
  spec <- .vue_tags_as_html(spec)
  spec$evals <- I(.vue_js_paths(spec))
  suppressWarnings(as.character(jsonlite::toJSON(
    spec,
    auto_unbox = TRUE,
    null = "null",
    na = "null",
    digits = NA,
    force = TRUE,
    POSIXt = "ISO8601",
    UTC = TRUE,
    rownames = FALSE,
    keep_vec_names = TRUE,
    dataframe = "columns",
    json_verbatim = TRUE
  )))
}

# parsed, numbers as doubles: 1 and 1.0 are one value in JavaScript
parsed <- function(json) {
  rapply(
    list(jsonlite::fromJSON(json, simplifyVector = FALSE)),
    function(x) if (is.numeric(x)) as.double(x) else x,
    how = "replace"
  )
}

test_that("awkward values travel as jsonlite wrote them", {
  spec <- list(
    options = list(
      one = 1,
      int = 2L,
      half = 0.5,
      range = c(20, 80),
      boxed = I(3),
      boxed_chr = I("a"),
      empty = character(0),
      empty_list = list(),
      empty_object = stats::setNames(list(), character(0)),
      na = NA,
      na_num = c(1, NA),
      null = NULL,
      nested = list(list(a = 1), list(a = 2)),
      named = c(a = 1, b = 2),
      date = as.Date("2026-10-19"),
      time = as.POSIXct("2026-10-19 08:30:00", tz = "Asia/Shanghai"),
      factor = factor(c("x", "y")),
      df = data.frame(x = c(1, 2), y = c("a", "b"), z = c(1.5, NA)),
      unicode = "中文 é",
      script = "</script><b>",
      big = 3e10,
      negzero = -0,
      infinite = c(Inf, -Inf, NaN),
      json = structure("{\"k\":[1,2]}", class = "json"),
      code = JS("function(x) { return x; }")
    )
  )
  ours <- .vue_json(spec)
  expect_identical(parsed(ours), parsed(jsonlite_json(spec)))
  # safe inside a <script>, as before
  expect_false(grepl("</script>", ours, fixed = TRUE))
  # whole numbers written as whole numbers
  expect_match(ours, '"one":1,', fixed = TRUE)
  expect_match(ours, '"range":[20,80]', fixed = TRUE)
  expect_match(ours, '"boxed":[3]', fixed = TRUE)
  expect_match(ours, '"time":"2026-10-19T00:30:00Z"', fixed = TRUE)
  expect_match(ours, '"named":{"a":1,"b":2}', fixed = TRUE)
  expect_match(ours, '"code":"function(x) { return x; }"', fixed = TRUE)
  expect_match(ours, '"evals":["options.code"]', fixed = TRUE)
})

test_that("every component's options travel as jsonlite wrote them", {
  specs <- list()
  real <- .vue_json
  local_mocked_bindings(.vue_json = function(spec) {
    specs[[length(specs) + 1]] <<- spec
    real(spec)
  })
  args <- list(
    el_table = list(data = utils::head(mtcars)),
    el_countdown = list("x", value = 1),
    el_tabs = list("x", tabs = list(list(name = "a", label = "A"))),
    el_pagination = list("x", total = 10),
    el_form = list(id = "x", el_form_field("n", "input")),
    el_select = list("x", choices = c(A = "a", B = "b")),
    el_slider = list("x", value = c(20, 80), range = TRUE),
    el_calendar = list(
      "x",
      events = data.frame(
        id = 1,
        date = as.Date("2026-10-19"),
        title = "a"
      )
    ),
    el_tree = list(
      "x",
      data = list(list(label = "a", children = list(list(label = "b"))))
    ),
    el_cascader = list(
      "x",
      options = list(list(value = "a", label = "A")),
      value = "a"
    )
  )
  drawn <- 0
  for (fn in grep("^el_", getNamespaceExports("shiny.element"), value = TRUE)) {
    f <- get(fn)
    if (!is.function(f) || !"id" %in% names(formals(f))) {
      next
    }
    a <- args[[fn]] %||% list("x")
    ok <- tryCatch(
      {
        htmltools::renderTags(htmltools::tagList(do.call(f, a)))
        TRUE
      },
      error = function(e) FALSE
    )
    drawn <- drawn + ok
  }
  expect_gt(drawn, 50)
  expect_gt(length(specs), 50)
  for (spec in specs) {
    expect_identical(parsed(real(spec)), parsed(jsonlite_json(spec)))
  }
})
