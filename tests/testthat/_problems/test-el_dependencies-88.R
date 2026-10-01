# Extracted from test-el_dependencies.R:88

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
fns <- ls(asNamespace("shiny.element"), pattern = "^el_.*_handler_dependency$")
expect_gt(length(fns), 20)
for (fn in fns) {
    for (dep in do.call(fn, list())) {
      expect_true(
        file.exists(file.path(unname(dep$src[["file"]]), dep$script)),
        info = paste(fn, "->", dep$script)
      )
    }
  }
