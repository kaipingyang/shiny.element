# Server functions take the session first, defaulting to the current one, as
# Shiny's update*Input() do. Given the id in its place, they say so.

test_that("an id passed as the session is named in the error", {
  expect_error(
    update_el_input("name", value = "a"),
    'not "name".*update_el_input\\(id = ...\\)'
  )
  expect_error(el_message("Saved"), 'el_message\\(message = ...\\)')
})

test_that("outside a session, the error says there is no server", {
  expect_error(
    update_el_input(id = "name", value = "a"),
    "outside a Shiny session"
  )
})

test_that("every server function checks its session first", {
  ns <- asNamespace("shiny.element")
  fns <- Filter(
    function(f) {
      fn <- get(f, envir = ns)
      is.function(fn) &&
        identical(names(formals(fn))[1], "session") &&
        identical(
          deparse(formals(fn)$session),
          "shiny::getDefaultReactiveDomain()"
        )
    },
    getNamespaceExports("shiny.element")
  )
  expect_gt(length(fns), 50)
  for (f in fns) {
    first <- as.list(body(get(f, envir = ns)))[[2]]
    # the Element layer's check, or the Vue layer's for its own functions
    expect_true(
      deparse(first) %in%
        c(".el_check_session(session)", ".vue_check_session(session)"),
      info = f
    )
  }
})
