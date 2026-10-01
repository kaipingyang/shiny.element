# Extracted from test-modules.R:35

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
module_session <- function() {
  shiny::MockShinySession$new()$makeScope("mod")
}
widget_id <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  sub('^.*<div id="([^"]+)" style="width:0px;height:0px;" class="vue html-widget".*$',
      "\\1", html)
}

# test -------------------------------------------------------------------------
ns <- asNamespace("shiny.element")
for (f in getNamespaceExports("shiny.element")) {
    g <- get(f, ns)
    if (!is.function(g) || !"session" %in% names(formals(g))) next
    default <- formals(g)$session
    if (identical(default, quote(expr = ))) next      # server functions
    expect_null(default, info = f)
    expect_false(any(grepl("getDefaultReactiveDomain", deparse(g))), info = f)
  }
