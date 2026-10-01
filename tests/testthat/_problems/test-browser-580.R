# Extracted from test-browser.R:580

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
skip_if_no_browser()
h <- as.numeric(bev("String(document.documentElement.scrollHeight)"))
expect_lt(h, 4000)
