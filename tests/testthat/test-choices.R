# Enumerated arguments are checked against what Element accepts.

test_that("every checked argument is a real argument of its function", {
  for (fn in names(.el_choices)) {
    f <- get(fn, envir = asNamespace("shiny.element"))
    expect_true(all(names(.el_choices[[fn]]) %in% names(formals(f))), info = fn)
  }
})

test_that("every function checks its own arguments", {
  for (fn in names(.el_choices)) {
    body <- deparse(body(get(fn, envir = asNamespace("shiny.element"))))
    expect_true(any(grepl(sprintf('.el_check_choices("%s"', fn), body, fixed = TRUE)), info = fn)
  }
})

test_that("each default is a value Element accepts", {
  for (fn in names(.el_choices)) {
    fm <- formals(get(fn, envir = asNamespace("shiny.element")))
    for (arg in names(.el_choices[[fn]])) {
      d <- fm[[arg]]
      if (is.character(d)) expect_true(d %in% .el_choices[[fn]][[arg]], info = paste(fn, arg))
    }
  }
})

test_that("a value Element does not accept is an error naming the ones it does", {
  expect_error(el_button("b", "Go", type = "primry"), '`type` should be one of "default", "primary"')
  expect_error(el_input("i", size = "huge"), "`size` should be one of")
  expect_error(el_tooltip("t", el$button("x"), content = "c", placement = "middle"), "`placement`")
  # exact, as Element is: a prefix is not the value
  expect_error(el_button("b", "Go", type = "prim"), "should be one of")
  expect_error(el_message(list(ns = identity, sendCustomMessage = function(...) NULL),
                          "hi", type = "fatal"), "`type`")
})

test_that("values the documentation leaves out but Element renders are accepted", {
  expect_no_error(el_button("b", "Go", type = "default"))
  expect_no_error(el_link("l", "Go", type = "default"))
  expect_no_error(el_select("s", choices = "a", size = "medium"))
  expect_no_error(el_input_number("n", size = "large"))
  expect_no_error(el_avatar("a", size = 64))
  expect_error(el_avatar("a", size = "huge"), "`size`")
})
