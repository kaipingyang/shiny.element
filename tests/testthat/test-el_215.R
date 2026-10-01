# Components Element added in 2.15, after this package first bundled 2.13.2

test_that("el_empty renders, and absorbs a component placed in it", {
  ui <- el_empty("e", description = "Nothing yet", el_button("create", "Create"))
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, "<el-empty")
  expect_equal(vue_data_of(ui)$emptyDescription, "Nothing yet")
  expect_true("label" %in% names(vue_data_of(ui)))   # the button's
})

test_that("content after the id goes to ..., not to the next argument", {
  # With ... placed after icon, title and sub_title, R matched a positional
  # el_button() to sub_title -- the button became the subtitle, and a tagList
  # landed in the Vue data.
  ui <- el_result("r", icon = "success", title = "Done", el_button("b", "Back"))
  expect_true(is.na(vue_data_of(ui)$resultSubTitle) || is.null(vue_data_of(ui)$resultSubTitle))
  expect_match(paste(as.character(ui), collapse = ""), '<template slot="extra">')
})

test_that("el_skeleton starts loading and can be switched off", {
  ui <- el_skeleton("s", rows = 4, shiny::tags$p("real"))
  expect_true(vue_data_of(ui)$skLoading)
  expect_equal(vue_data_of(ui)$skRows, 4)

  s <- mock_session()
  update_el_skeleton(s, "s", loading = FALSE)
  expect_false(s$captured()$msg$skLoading)
})

test_that("el_statistic carries its number and formatting", {
  ui <- el_statistic("n", value = 1318.5, prefix = "$", precision = 2)
  d <- vue_data_of(ui)
  expect_equal(d$value, 1318.5)
  expect_equal(d$prefix, "$")
  expect_equal(d$precision, 2)
})

test_that("el_descriptions renders one item per field", {
  ui <- el_descriptions("d", border = TRUE, items = list(
    list(label = "Name", content = "Ada"),
    list(label = "Address", content = "London", span = 2)
  ))
  html <- paste(as.character(ui), collapse = "")
  expect_equal(lengths(regmatches(html, gregexpr("<el-descriptions-item", html))), 2L)
  expect_match(html, ':span="2"', fixed = TRUE)
})

test_that("el_descriptions takes names as labels", {
  ui <- el_descriptions("car", items = as.list(mtcars[1, 1:3]))
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, 'label="mpg"', fixed = TRUE)
})

test_that("a descriptions label may be markup", {
  ui <- el_descriptions("d", items = list(
    list(label = shiny::tags$b("Bold"), content = "x")
  ))
  expect_match(paste(as.character(ui), collapse = ""), '<template slot="label">')
})

test_that("el_statistic counts down to a date-time, in milliseconds", {
  end <- as.POSIXct("2026-10-02 00:00:00", tz = "UTC")
  d <- vue_data_of(el_statistic("left", value = end, time_indices = TRUE,
                                format = "HH:mm:ss"))
  expect_equal(d$value, as.numeric(end) * 1000)
  expect_true(d$timeIndices)
  expect_equal(d$format, "HH:mm:ss")
})

test_that("el_statistic forwards finish, and throttles change to once a second", {
  p <- vue_payload_of(el_statistic("left", value = 1, time_indices = TRUE))
  expect_true(all(c("elEmitFinish", "elEmitChange") %in% names(p$methods)))
  expect_match(p$methods$elEmitChange, "_elLastChange", fixed = TRUE)
})
