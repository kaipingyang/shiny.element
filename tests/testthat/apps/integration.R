# Fixture app for the browser integration tests. Every widget here covers a
# failure that the HTML-level unit tests cannot see; see test-browser.R.
library(shiny)
library(shiny.element)

cascader_opts <- list(
  list(value = "zj", label = "Zhejiang", children = list(
    list(value = "hz", label = "Hangzhou"),
    list(value = "nb", label = "Ningbo")
  )),
  list(value = "js", label = "Jiangsu", children = list(
    list(value = "nj", label = "Nanjing")
  ))
)

ui <- el_page(
  title = "integration",

  # Initial values: every one of these reported NULL until mount-time reporting
  # was added.
  el_input("inp", value = "hello"),
  el_select("sel", choices = c(A = "a", B = "b"), selected = "b"),
  el_switch("sw", value = TRUE),
  el_slider("sld", value = 42),
  el_rate("rate", value = 3),
  el_radio_group("rg", choices = c(X = "x", Y = "y"), selected = "y"),
  el_checkbox_group("cg", choices = c(P = "p", Q = "q"), selected = "p"),
  el_input_number("num", value = 7),
  el_date_picker("dp", value = "2026-01-15"),
  el_color_picker("cp", value = "#409EFF"),
  el_tabs("tabs",
    tabs = list(list(name = "t1", label = "T1", content = "c1"),
                list(name = "t2", label = "T2", content = "c2")),
    selected = "t2"),
  el_pagination("pg", total = 100, current_page = 3, page_size = 20),
  el_collapse("col",
    items = list(list(name = "i1", title = "I1", content = "c1"),
                 list(name = "i2", title = "I2", content = "c2")),
    value = "i2"),

  # Named non-character choices: labels used to be lost and options serialised
  # as a JSON object instead of an array.
  el_radio_group("rg_num", choices = c(First = 1, Second = 2), selected = 1),

  # Steps: reaching "all finished" needs active == number of steps.
  el_steps("stp", active = 0, finish_status = "success",
           steps = list(list(title = "S1"), list(title = "S2"), list(title = "S3"))),
  actionButton("step_next", "next step"),

  # Table: a data.frame used to serialise column-wise and render nothing.
  el_table(id = "tbl", data = head(iris, 4), selection = TRUE),
  actionButton("tbl_swap", "swap table data"),

  # Cascader: its handler script was never loaded, so updates went unheard.
  el_cascader("casc", options = cascader_opts, value = list("zj", "hz"),
              placeholder = "pick one"),
  actionButton("casc_update", "update cascader"),

  # Layout: these used to emit uncompiled custom tags and, for the container,
  # silently swallow any nested widget.
  tags$div(id = "grid", style = "width:800px",
    el_row(gutter = 20,
      el_col(span = 12, tags$div("left")),
      el_col(span = 12, tags$div("right"))
    )
  ),
  tags$div(id = "flexrow", style = "width:800px",
    el_row(type = "flex", justify = "center", align = "middle",
      el_col(span = 8, tags$div("centred"))
    )
  ),
  tags$div(id = "layout", style = "width:800px; height:200px",
    el_container(
      el_header("head"),
      el_container(
        el_aside(width = "200px", el_switch("sw_nested", value = TRUE)),
        el_main(el_slider("sld_nested", value = 88))
      )
    )
  ),

  # Form: owns its model, so validation runs client-side and the whole form
  # reports once on submit rather than field by field.
  el_form(
    id = "signup", label_width = "110px", reset_label = "Reset",
    el_form_field("fname", "input", label = "Name",
                  rules = el_rule(required = TRUE, message = "name required")),
    el_form_field("fage", "input-number", label = "Age", value = 18, min = 0, max = 150),
    el_form_field("fcity", "select", label = "City",
                  choices = c(Beijing = "bj", Shanghai = "sh"),
                  rules = el_rule(required = TRUE, message = "pick a city",
                                  trigger = "change"))
  ),
  actionButton("form_prefill", "prefill form"),

  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  fmt <- function(x) {
    if (is.null(x)) return("<NULL>")
    paste(format(x), collapse = ",")
  }

  output$dump <- renderPrint({
    invalidateLater(1000, session)
    ids <- c("inp", "sel", "sw", "sld", "rate", "rg", "cg", "num", "dp", "cp",
             "tabs", "pg_page", "pg_size", "col", "rg_num", "stp",
             "tbl_selected_rows", "casc_value", "sw_nested", "sld_nested",
             "signup_submit", "signup_valid")
    for (i in ids) cat(i, "=", fmt(input[[i]]), "\n")
  })

  n_steps <- 3L
  observeEvent(input$step_next, {
    current <- input$stp
    update_el_steps(session, "stp",
                    active = if (current >= n_steps) 0L else current + 1L)
  })

  observeEvent(input$tbl_swap, {
    update_el_table(session, "tbl", data = head(mtcars, 6))
  })

  observeEvent(input$form_prefill, {
    update_el_form(session, "signup",
                   model = list(fname = "Ada", fcity = "sh"))
  })

  observeEvent(input$casc_update, {
    update_el_cascader(session, "casc",
                       value = list("js", "nj"), placeholder = "updated",
                       disabled = TRUE)
  })
}

shinyApp(ui, server)
