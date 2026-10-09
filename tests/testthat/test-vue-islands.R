# Shiny UI in a template is taken out of it, to a holder beside it, and a
# <shiny-island> takes its place.

render_html <- function(x) {
  paste(as.character(htmltools::renderTags(x)$html), collapse = "")
}

test_that("Shiny UI, widgets and components become islands", {
  x <- .vue_islands(htmltools::tags$div(
    htmltools::tags$p("{{ n }}"),
    shiny::textInput("t", "T"),
    shiny::plotOutput("p"),
    shiny::actionButton("b", "B"),
    shiny::conditionalPanel("input.t == 'x'", "c"),
    htmltools::tags$span(`data-shiny-island` = NA, "mine"),
    htmltools::tags$script("var x = 1;")
  ))
  tpl <- render_html(x$template)
  expect_equal(
    lengths(regmatches(tpl, gregexpr("<shiny-island", tpl, fixed = TRUE))),
    5L
  )
  expect_match(tpl, "<p>{{ n }}</p>", fixed = TRUE)
  expect_false(grepl("<script", tpl, fixed = TRUE))
  holder <- render_html(x$holder)
  expect_match(holder, "data-shiny-vue-islands", fixed = TRUE)
  expect_match(holder, "var x = 1;", fixed = TRUE)
  expect_match(holder, 'id="t"', fixed = TRUE)
})

test_that("a template with no Shiny UI is left alone", {
  x <- .vue_islands(htmltools::tags$div(htmltools::tags$b("{{ a }}")))
  expect_null(x$holder)
  expect_equal(render_html(x$template), "<div>\n  <b>{{ a }}</b>\n</div>")
})

test_that("vue_app() puts the holder in its host, and a component its own", {
  html <- render_html(vue_app(
    "app",
    htmltools::tags$div(`v-if` = "show", shiny::textInput("t", "T")),
    data = list(show = TRUE)
  ))
  expect_match(html, '<shiny-island name="1"></shiny-island>', fixed = TRUE)
  expect_match(html, "data-shiny-vue-islands", fixed = TRUE)
})
