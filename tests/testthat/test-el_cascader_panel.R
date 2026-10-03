regions <- list(
  list(
    value = "asia",
    label = "Asia",
    children = list(
      list(value = "cn", label = "China"),
      list(value = "jp", label = "Japan")
    )
  )
)

test_that("el_cascader_panel renders Element's panel with its options", {
  ui <- el_cascader_panel("where", options = regions, value = c("asia", "jp"))
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, "<el-cascader-panel", fixed = TRUE)
  d <- vue_data_of(ui)
  expect_equal(d$value, list("asia", "jp"))
  expect_equal(d$options[[1]]$children[[2]]$label, "Japan")
})

test_that("el_cascader_panel starts empty as an array, not a string", {
  expect_equal(
    vue_data_of(el_cascader_panel("where", options = regions))$value,
    list()
  )
})

test_that("el_cascader_panel reports its path and forwards expand-change", {
  p <- vue_payload_of(el_cascader_panel(
    "where",
    options = regions,
    props = list(multiple = TRUE)
  ))
  expect_equal(p$data$props, list(multiple = TRUE))
  expect_equal(
    vue_spec_of(el_cascader_panel("where", options = regions))$input,
    "value"
  )
  expect_true("elEmitExpandChange" %in% names(p$methods))
})

test_that("update_el_cascader_panel sends the new value and options", {
  s <- mock_session()
  update_el_cascader_panel(s, "where", value = c("asia", "cn"))
  expect_equal(s$captured()$type, "shinyVueUpdate")
  expect_equal(s$captured()$msg, list(id = "where", value = list("asia", "cn")))
})
