# Inside a module every update reaches the namespaced id, as Shiny's
# update*Input() do. A module's session namespaces an input message itself
# (session$makeScope()), not a custom message: an update_*() sending
# shinyVueUpdate must call session$ns() on its id, one sending an input
# message must not, or the id is namespaced twice.

test_that("every update_*() reaches the namespaced id in a module", {
  ns <- shiny::NS("mod")
  updaters <- sort(grep(
    "^update_",
    getNamespaceExports("shiny.element"),
    value = TRUE
  ))
  sent_ids <- function(fn) {
    ids <- character()
    # as a module's session: ns() given, input messages namespaced on the way
    session <- list(
      ns = ns,
      userData = new.env(),
      sendCustomMessage = function(type, msg) ids <<- c(ids, msg$id),
      sendInputMessage = function(id, msg) ids <<- c(ids, ns(id))
    )
    tryCatch(
      do.call(fn, list(session = session, id = "x")),
      error = function(e) NULL
    )
    ids
  }
  checked <- 0
  for (fn in updaters) {
    ids <- sent_ids(get(fn, envir = asNamespace("shiny.element")))
    if (!length(ids)) {
      next
    }
    checked <- checked + 1
    expect_true(all(ids == "mod-x"), info = paste(fn, toString(ids)))
  }
  # every one sends something with no field given
  expect_equal(checked, length(updaters))
})

test_that("method calls and tab insertion reach the namespaced id in a module", {
  ns <- shiny::NS("mod")
  sent <- list()
  session <- list(
    ns = ns,
    userData = new.env(),
    sendCustomMessage = function(type, msg) {
      sent[[length(sent) + 1]] <<- msg$id
    },
    sendInputMessage = function(id, msg) {
      sent[[length(sent) + 1]] <<- ns(id)
    },
    sendInsertUI = function(selector, ...) {
      sent[[length(sent) + 1]] <<- selector
    }
  )
  call_vue(session, "x", "focus")
  call_el(session, "x", "focus")
  remove_el_tab(session, "x", "a")
  expect_equal(unlist(sent), rep("mod-x", 3))

  sent <- list()
  insert_el_tab(session, "x", "b", content = "b")
  expect_equal(unlist(sent), c("#mod-x > .el-tabs__content", "mod-x"))
})
