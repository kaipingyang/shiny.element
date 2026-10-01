# Extracted from test-el_dependencies.R:261

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "shiny.element", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
for (f in list.files(system.file("..", "R", package = "shiny.element"), full.names = TRUE)) NULL
ui <- htmltools::tagList(
    el_input("i"), el_select("s", choices = "a"), el_table("t", data = head(iris, 1)),
    el_menu("m", items = list(list(index = "a", label = "A"))),
    el_pagination("p", total = 10), el_tree("tr", data = list(list(label = "x")))
  )
html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
calls <- regmatches(html, gregexpr("[^ ]* ?[^ ]* ?Shiny\\\\.setInputValue\\\\(", html))[[1]]
