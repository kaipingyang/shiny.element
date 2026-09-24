# A single app touching most of the package. Run it with:
#   shiny::runApp(system.file("examples", "el_showcase_app.R",
#                             package = "shiny.element"))
library(shiny)
library(shiny.element)

ui <- el_page(
  title = "shiny.element showcase",

  el_container(
    el_header(
      tags$h4("Inputs", style = "margin:0; line-height:60px")
    ),
    el_container(
      el_aside(
        width = "280px",
        el_input("name", value = "Ada", placeholder = "your name"),
        tags$br(),
        el_select("city", choices = c(Beijing = "bj", Shanghai = "sh"), selected = "bj"),
        tags$br(),
        el_slider("score", value = 60),
        el_rate("stars", value = 3),
        el_switch("dark", value = FALSE, active_text = "on", inactive_text = "off"),
        tags$br(),
        el_button("notify", "Notify me", type = "primary")
      ),
      el_main(
        el_row(
          gutter = 20,
          el_col(span = 12, el_alert("hint", title = "Values update live",
                                     type = "info", description = "Every input reports on load.")),
          el_col(span = 12, el_progress("pct", percentage = 60))
        ),
        tags$br(),
        verbatimTextOutput("values"),
        tags$hr(),
        tags$h4("Steps"),
        el_steps("wizard", active = 0, finish_status = "success",
                 steps = list(list(title = "Pick"), list(title = "Confirm"), list(title = "Done"))),
        el_button("next_step", "Next step"),
        tags$hr(),
        tags$h4("Form with client-side validation"),
        el_form(
          id = "signup", label_width = "110px", reset_label = "Reset",
          el_form_field("fname", "input", label = "Name",
                        rules = el_rule(required = TRUE, message = "Name is required")),
          el_form_field("femail", "input", label = "Email",
                        rules = el_rule(type = "email", message = "Not a valid email")),
          el_form_field("fage", "input-number", label = "Age", value = 18, min = 0, max = 150)
        ),
        verbatimTextOutput("submitted"),
        tags$hr(),
        tags$h4("Table"),
        el_table(id = "tbl", data = head(iris, 5), selection = TRUE),
        verbatimTextOutput("picked")
      )
    )
  )
)

server <- function(input, output, session) {
  output$values <- renderPrint({
    list(name = input$name, city = input$city, score = input$score,
         stars = input$stars, dark = input$dark)
  })

  observeEvent(input$notify, {
    el_notification(session, message = paste("Hello,", input$name),
                    title = "Notification", type = "success")
  })

  observeEvent(input$score, {
    update_el_progress(session, "pct", percentage = input$score)
  }, ignoreInit = TRUE)

  n_steps <- 3L
  observeEvent(input$next_step, {
    current <- input$wizard
    update_el_steps(session, "wizard",
                    active = if (current >= n_steps) 0L else current + 1L)
  })

  output$submitted <- renderPrint({
    req(input$signup_submit)
    if (!isTRUE(input$signup_valid)) return("Fix the errors above")
    input$signup
  })

  output$picked <- renderPrint({
    rows <- input$tbl_selected_rows
    if (is.null(rows)) "Select some rows" else head(iris, 5)[rows, ]
  })
}

shinyApp(ui, server)
