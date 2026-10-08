# Components that ask the server, folded into a space inside a config
# provider: a select searching remotely, a lazy tree, a lazy cascader; and
# form fields added from the server while their dialog is open.
#
#   shiny::runApp(system.file("examples/combinations/server-answers", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/server-answers.R).

library(shiny)
library(shiny.element)

# what the server holds, one input per line
inputs_text <- function(x) {
  paste(
    sprintf(
      "%s: %s",
      names(x),
      vapply(
        x,
        function(v) {
          if (is.null(v)) "NULL" else paste(format(unclass(v)), collapse = ", ")
        },
        character(1)
      )
    ),
    collapse = "\n"
  )
}

cities <- c("Beijing", "Berlin", "Bern", "Boston", "Shanghai", "Sydney")

ui <- el_page(
  el_config_provider(
    id = "cfg",
    el_space(
      id = "sp",
      direction = "vertical",
      alignment = "start",
      # remote search, folded into a space inside a provider
      el_select(
        "city",
        choices = character(),
        remote = TRUE,
        filterable = TRUE,
        placeholder = "type b",
        width = "200px"
      ),
      # lazy tree, folded in
      el_tree("lazy", lazy = TRUE, is_leaf_field = "leaf"),
      # cascader with lazy loading
      el_cascader("casc", props = list(lazy = TRUE), width = "200px")
    )
  ),
  el_button("open_dlg", "Open"),
  el_dialog(
    "dlg",
    title = "Fields added from the server",
    content = tagList(
      el_form(
        id = "dom",
        submit_label = "Submit",
        el_form_field(
          "email",
          "input",
          label = "Email",
          rules = el_rule(type = "email", message = "Not an email")
        )
      ),
      el_button("more", "New domain")
    )
  ),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  observeEvent(input$city_query, {
    q <- tolower(input$city_query)
    update_el_select(
      session,
      "city",
      choices = cities[startsWith(tolower(cities), q)]
    )
  })
  observeEvent(input$lazy_load, {
    q <- input$lazy_load
    kids <- if (q$level == 0) {
      list(list(label = "Region A"), list(label = "Region B"))
    } else if (q$level < 2) {
      list(list(label = paste(q$data$label, "child"), leaf = TRUE))
    } else {
      list()
    }
    el_load_children(id = "lazy", request = q, children = kids)
  })
  observeEvent(input$casc_lazy_load, {
    q <- input$casc_lazy_load
    lvl <- q$level %||% 0
    kids <- lapply(1:2, function(i) {
      list(
        value = paste0("l", lvl, "-", i),
        label = paste("Level", lvl, i),
        leaf = lvl >= 1
      )
    })
    el_load_children(id = "casc", request = q, children = kids)
  })
  observeEvent(input$open_dlg, update_el_dialog(session, "dlg", visible = TRUE))
  n <- reactiveVal(0)
  observeEvent(input$more, {
    n(n() + 1)
    update_el_form(
      session,
      "dom",
      fields = c(
        list(el_form_field(
          "email",
          "input",
          label = "Email",
          rules = el_rule(type = "email", message = "Not an email")
        )),
        lapply(seq_len(n()), function(i) {
          el_form_field(
            paste0("domain", i),
            "input",
            label = paste("Domain", i),
            rules = el_rule(required = TRUE, message = "Domain can not be null")
          )
        })
      )
    )
  })
  output$dump <- renderText(inputs_text(list(
    city = input$city,
    casc = input$casc,
    lazy = input$lazy,
    dom = input$dom,
    valid = input$dom_valid
  )))
}

shinyApp(ui, server)
