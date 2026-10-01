# Extracted from test-modules.R:50

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
m <- module_session()
sent <- NULL
m$sendCustomMessage <- function(type, message) sent <<- message
