render_html <- function(tag) paste(as.character(tag), collapse = "")

test_that("tags in a component's data travel as their HTML", {
  # A timeline entry's content used to arrive as the tag's serialised object
  html <- render_html(el_timeline("tl", html = TRUE,
    items = list(list(content = tags$b(id = "tl-b", "Bold")))))
  expect_match(html, '<b id=\\"tl-b\\">Bold<\\/b>', fixed = TRUE)
  expect_false(grepl('"attribs"', html, fixed = TRUE))
})

test_that("tags in an update travel as their HTML", {
  session <- shiny::MockShinySession$new()
  sent <- NULL
  session$sendCustomMessage <- function(type, message) sent <<- message
  .el_send_update(session, list(id = "x", items = list(list(content = tags$i("it")))))
  expect_identical(sent$items[[1]]$content, "<i>it</i>")
})

test_that("an updated label given as tags goes as HTML, text as text", {
  msg <- .el_form_item_update(list(), label = tags$b("B"))
  expect_identical(msg[[".label"]], list(html = "<b>B</b>"))
  msg <- .el_form_item_update(list(), label = shiny::HTML("<i>I</i>"))
  expect_identical(msg[[".label"]], list(html = "<i>I</i>"))
  expect_identical(.el_form_item_update(list(), label = "<b>")[[".label"]], "<b>")
})

test_that("items that are not a list of lists say what was expected", {
  expect_error(el_tabs("t", tabs = "a"), "`tabs` must be a list of items")
  expect_error(el_collapse("c", items = c("a", "b")), "`items` must be a list of items")
  expect_error(el_menu("m", items = tags$div()), "not a tag")
  expect_error(el_steps("s", steps = "a"), "`steps` must be a list of items")
  expect_error(el_dropdown("d", items = "a"), "`items` must be a list of items")
  expect_error(el_carousel("c", items = "a"), "`items` must be a list of items")
  expect_error(el_descriptions(items = c("a", "b")), "`items` must be named")
  # the forms that are right still pass
  expect_silent(el_descriptions(items = c(Name = "Ada")))
  expect_silent(el_tabs("t", tabs = list()))
})

test_that("layout arguments of the wrong kind are refused with a message", {
  expect_error(el_row(gutter = "20"), "`gutter` must be a single number")
  expect_error(el_page(theme_css = "x"), "`theme_css` must be an htmlDependency")
})

test_that("el_cascader has no icon argument, which Element's cascader lacks", {
  expect_false("icon" %in% names(formals(el_cascader)))
})
