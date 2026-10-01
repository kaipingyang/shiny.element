test_that("el_time_picker binds a single time", {
  ui <- el_time_picker("t", value = "09:30:00")
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, "<el-time-picker", fixed = TRUE)
  d <- vue_data_of(ui)
  expect_equal(d$value, "09:30:00")
  expect_equal(d$valueFormat, "HH:mm:ss")
  expect_false(d$isRange)
})

test_that("el_time_picker takes a range as two times", {
  d <- vue_data_of(el_time_picker("t", is_range = TRUE,
                                  value = c("09:00:00", "17:30:00")))
  expect_true(d$isRange)
  expect_equal(d$value, list("09:00:00", "17:30:00"))
  # An empty range is an array, not a string
  expect_equal(vue_data_of(el_time_picker("t", is_range = TRUE))$value, list())
})

test_that("el_time_select has no range, format or arrows of its own", {
  ui <- el_time_select("s", picker_options = list(start = "09:00", step = "00:30",
                                                  end = "18:00"))
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, "<el-time-select", fixed = TRUE)
  d <- vue_data_of(ui)
  expect_equal(d$pickerOptions$step, "00:30")
  for (f in c("isRange", "valueFormat", "arrowControl", "rangeSeparator")) {
    expect_false(f %in% names(d), info = f)
  }
})

test_that("both report on load and on change, and forward focus and blur", {
  for (ui in list(el_time_picker("t"), el_time_select("t"))) {
    p <- vue_payload_of(ui)
    expect_equal(vue_spec_of(ui)$input, "value")
    expect_match(p$methods$handleChange, "Shiny.setInputValue('t'", fixed = TRUE)
    expect_true(all(c("elEmitBlur", "elEmitFocus") %in% names(p$methods)))
  }
})

test_that("update_el_time_picker sends only what was given", {
  s <- mock_session()
  update_el_time_picker(s, "t", value = c("08:00:00", "12:00:00"))
  got <- s$captured()
  expect_equal(got$type, "updateElTimePicker")
  expect_equal(got$msg, list(id = "t", value = list("08:00:00", "12:00:00")))

  update_el_time_picker(s, "t", disabled = TRUE)
  expect_equal(s$captured()$msg, list(id = "t", disabled = TRUE))
})
