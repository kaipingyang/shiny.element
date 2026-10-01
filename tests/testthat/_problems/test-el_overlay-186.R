# Extracted from test-el_overlay.R:186

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}
sent_input <- function(expr) {
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendInputMessage = function(id, msg) sent <<- list(id = id, msg = msg),
    sendCustomMessage = function(type, msg) stop("should not be used")
  )
  expr(session)
  sent
}

# test -------------------------------------------------------------------------
js <- paste(readLines(
    system.file("js", "el-overlay-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
expect_match(js, "typeof Shiny === 'undefined'", fixed = TRUE)
