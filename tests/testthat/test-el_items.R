# Item constructors return the list their parent's argument takes.

test_that("an item is the parent's list, unset fields left out", {
  tab <- el_tab_pane("User", "user pane", lazy = TRUE)
  expect_s3_class(tab, "el_tab_pane")
  expect_s3_class(tab, "el_item")
  expect_equal(tab$name, "User")
  expect_equal(tab$label, "User")
  expect_equal(tab$content, "user pane")
  expect_true(tab$lazy)
  expect_false("disabled" %in% names(tab))
})

test_that("an item and the plain list draw the same", {
  html <- function(x) {
    paste(as.character(htmltools::renderTags(x)$html), collapse = "")
  }
  expect_equal(
    html(el_steps("s", steps = list(el_step("One", "first")))),
    html(el_steps(
      "s",
      steps = list(list(title = "One", description = "first"))
    ))
  )
  expect_equal(
    html(el_select("c", choices = list(el_option("A"), el_option("B", "b")))),
    html(el_select(
      "c",
      choices = list(
        list(value = "A", label = "A"),
        list(value = "b", label = "B")
      )
    ))
  )
})

test_that("a group header's child columns may come first", {
  col <- el_table_column(
    label = "Info",
    el_table_column("name", "Name"),
    el_table_column("city", "City")
  )
  expect_null(col$prop)
  expect_equal(col$label, "Info")
  expect_length(col$children, 2)
  expect_equal(col$children[[1]]$prop, "name")
})

test_that("enumerated arguments are checked", {
  expect_error(el_step("x", status = "done"), "should be one of")
  expect_error(el_table_column("a", align = "middle"), "should be one of")
  expect_error(el_sub_menu("x", "1"), "needs items")
})

test_that("a table-v2 column takes Element Plus's field names", {
  col <- el_table_v2_column("id", "Id", min_width = 50, cell_renderer = JS("f"))
  expect_equal(col$dataKey, "id")
  expect_equal(col$minWidth, 50)
  expect_s3_class(col$cellRenderer, "JS_EVAL")
})
