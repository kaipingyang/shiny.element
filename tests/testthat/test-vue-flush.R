# Updates and method calls go with the flush, as Shiny's update*Input() do;
# flush_vue() sends them at once; a progress is sent at once.

flushing_session <- function() {
  env <- new.env()
  env$sent <- list()
  env$flushed <- list()
  env$requested <- 0
  env$session <- list(
    ns = function(id) id,
    userData = new.env(),
    sendCustomMessage = function(type, msg) {
      env$sent[[length(env$sent) + 1L]] <- list(type = type, msg = msg)
    },
    onFlushed = function(fun, once = TRUE) {
      env$flushed[[length(env$flushed) + 1L]] <- fun
    },
    requestFlush = function() env$requested <- env$requested + 1
  )
  env$flush <- function() {
    callbacks <- env$flushed
    env$flushed <- list()
    for (f in callbacks) {
      f()
    }
  }
  env
}

test_that("updates and calls wait for the flush, in order", {
  s <- flushing_session()
  update_vue(s$session, "a", n = 1)
  call_vue(s$session, "a", "focus")
  update_el_input(s$session, "b", value = "x")
  expect_length(s$sent, 0)
  # one flush requested, one callback, however many messages
  expect_equal(s$requested, 1)
  expect_length(s$flushed, 1)
  s$flush()
  expect_equal(
    vapply(s$sent, `[[`, "", "type"),
    c("shinyVueUpdate", "shinyVueCall", "shinyVueUpdate")
  )
  expect_equal(s$sent[[1]]$msg$n, 1)
  expect_equal(s$sent[[3]]$msg$id, "b")

  # the next flush is armed again
  update_vue(s$session, "a", n = 2)
  expect_equal(s$requested, 2)
  s$flush()
  expect_equal(s$sent[[4]]$msg$n, 2)
})

test_that("flush_vue() sends what is queued at once", {
  s <- flushing_session()
  out <- flush_vue(
    {
      update_vue(s$session, "a", n = 1)
      "done"
    },
    session = s$session
  )
  expect_equal(out, "done")
  expect_length(s$sent, 1)
  # alone, it sends what was queued before
  update_vue(s$session, "a", n = 2)
  flush_vue(session = s$session)
  expect_length(s$sent, 2)
  # the flush that follows finds nothing left to send
  s$flush()
  expect_length(s$sent, 2)
})

test_that("a progress is sent at once, as withProgress() reports", {
  s <- flushing_session()
  update_el_progress(s$session, "p", percentage = 50)
  expect_length(s$sent, 1)
  expect_equal(s$sent[[1]]$msg$percentage, 50)
})

test_that("a session with no flush to wait for is sent to at once", {
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) sent <<- msg
  )
  update_vue(session, "a", n = 3)
  expect_equal(sent$n, 3)
})

test_that("a module's session shares its session's queue", {
  s <- flushing_session()
  module <- s$session
  module$ns <- shiny::NS("m")
  update_vue(s$session, "a", n = 1)
  update_vue(module, "a", n = 2)
  s$flush()
  expect_equal(
    vapply(s$sent, function(m) m$msg$id, ""),
    c("a", "m-a")
  )
})
