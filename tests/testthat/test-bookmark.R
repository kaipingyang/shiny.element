# A bookmarked session hands every input's value back through
# shiny::restoreInput(), which each Shiny input calls as its UI is built.

restoring <- function(query, expr) {
  ctx <- shiny:::RestoreContext$new(paste0("?_inputs_&", query))
  shiny:::withRestoreContext(ctx, expr)
}
enc <- function(x) utils::URLencode(as.character(jsonlite::toJSON(x, auto_unbox = TRUE)),
                                    reserved = TRUE)

test_that("a component's value comes back from a bookmark", {
  restoring(paste0("name=", enc("Grace")), {
    expect_equal(vue_data_of(el_input("name", value = "Ada"))$value, "Grace")
  })
  restoring(paste0("on=", enc(FALSE)), {
    expect_false(vue_data_of(el_switch("on", value = TRUE))$value)
  })
  # Nothing being restored: the value as given
  expect_equal(vue_data_of(el_input("name", value = "Ada"))$value, "Ada")
})

test_that("a restored selection keeps its shape", {
  restoring(paste0("pick=", enc(I("b"))), {
    d <- vue_data_of(el_checkbox_group("pick", choices = c("a", "b"), selected = "a"))
    expect_equal(d$value, list("b"))
  })
  restoring(paste0("many=", enc(c("a", "c"))), {
    d <- vue_data_of(el_select("many", choices = c("a", "b", "c"), multiple = TRUE))
    expect_equal(d$value, list("a", "c"))
  })
})

test_that("tabs, collapse, dialog, menu and pager restore too", {
  tabs <- list(list(name = "a", label = "A", content = "x"),
               list(name = "b", label = "B", content = "y"))
  restoring(paste0("t=", enc("b")), {
    html <- paste(as.character(el_tabs("t", tabs = tabs)), collapse = "")
    expect_match(html, 'is-active" data-el-name="b"', fixed = TRUE)
  })
  restoring(paste0("d=", enc(TRUE)), {
    html <- paste(as.character(el_dialog("d", content = "x")), collapse = "")
    expect_match(html, 'data-visible="true"', fixed = TRUE)
  })
  restoring(paste0("m=", enc("two")), {
    d <- vue_data_of(el_menu("m", items = list(list(index = "one", label = "1"),
                                              list(index = "two", label = "2"))))
    expect_equal(d$active, "two")
  })
  restoring(paste0("p_page=", enc(4), "&p_size=", enc(20)), {
    d <- vue_data_of(el_pagination("p", total = 200))
    expect_equal(d$currentPage, 4)
    expect_equal(d$pageSize, 20)
  })
})

test_that("a value field that defaults to NULL stays declared", {
  # Assigning a restored NULL with [[<- removed the field, and v-model then
  # bound to nothing
  expect_true("value" %in% names(vue_data_of(el_color_picker("x"))))
})
