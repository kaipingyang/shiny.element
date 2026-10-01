# Extracted from test-el_dependencies.R:103

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
fns <- ls(asNamespace("shiny.element"), pattern = "^el_.*_handler_dependency$")
for (fn in fns) {
    deps  <- do.call(fn, list())
    names <- vapply(deps, function(d) d$name, character(1))
    expect_equal(names[1:3], c("el-invoke", "el-events", "el-update"), info = fn)
    expect_length(deps, 4)
  }
