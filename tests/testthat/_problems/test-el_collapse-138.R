# Extracted from test-el_collapse.R:138

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# prequel ----------------------------------------------------------------------
render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}
demo_items <- list(
  list(name = "p1", title = "First",  content = shiny::tags$p("One")),
  list(name = "p2", title = "Second", content = shiny::tags$p("Two")),
  list(name = "p3", title = "Third",  content = "Three", disabled = TRUE)
)

# test -------------------------------------------------------------------------
js <- paste(readLines(
    system.file("js", "el-collapse-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
expect_match(js, "typeof Shiny === 'undefined'", fixed = TRUE)
