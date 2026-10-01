# Inside a module the caller namespaces ids with ns(), as for any Shiny input.
# Components used to namespace again from the default reactive domain, which
# inside renderUI() in a module server is the module's session: ns("x")
# became "mod-mod-x", and that input never reported.

module_session <- function() {
  shiny::MockShinySession$new()$makeScope("mod")
}

widget_id <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  sub('^.*?<div id="([^"]+)" data-el-vue-host.*$', "\\1", html)
}

test_that("a component keeps the id it is given inside a module's renderUI()", {
  ns <- shiny::NS("mod")
  m <- module_session()
  shiny::withReactiveDomain(m, {
    expect_equal(widget_id(el_input(ns("name"))), "mod-name")
    expect_equal(widget_id(el_select(ns("pick"), choices = c("a", "b"))), "mod-pick")
    expect_equal(widget_id(el_table(ns("rows"), data = head(iris, 2))), "mod-rows")
    tabs <- paste(as.character(el_tabs(ns("tabs"), tabs = list(
      list(name = "a", label = "A", content = "x")))), collapse = "")
    expect_match(tabs, 'id="mod-tabs"', fixed = TRUE)
  })
})

test_that("no UI function reads the default reactive domain", {
  ns <- asNamespace("shiny.element")
  for (f in getNamespaceExports("shiny.element")) {
    g <- get(f, ns)
    if (!is.function(g) || !"session" %in% names(formals(g))) next
    fm <- formals(g)
    # Server functions take a session with no default
    if (is.symbol(fm$session) && !nzchar(as.character(fm$session))) next
    expect_null(fm$session, info = f)
    expect_false(any(grepl("getDefaultReactiveDomain", deparse(g))), info = f)
  }
})

test_that("a session given explicitly still namespaces, with a warning", {
  m <- module_session()
  expect_warning(id <- widget_id(el_input("name", session = m)), "deprecated")
  expect_equal(id, "mod-name")
})

test_that("server functions namespace the id they are given, as update*Input() do", {
  # The parts of a module session these functions use
  sent <- NULL
  m <- list(ns = shiny::NS("mod"),
            sendCustomMessage = function(type, message) sent <<- message)
  update_el_input(m, "name", value = "x")
  expect_equal(sent$id, "mod-name")
  el_call(m, "rows", "clearSelection")
  expect_equal(sent$id, "mod-rows")
})
