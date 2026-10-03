# One app touching every component in the package. Run it with:
#   shiny::runApp(system.file("examples", "el_showcase_app.R",
#                             package = "shiny.element"))
library(shiny)
library(shiny.element)

demo_tree <- list(
  list(
    id = "fruit",
    label = "Fruit",
    children = list(
      list(id = "apple", label = "Apple"),
      list(id = "cherry", label = "Cherry"),
      list(id = "plum", label = "Plum", disabled = TRUE)
    )
  ),
  list(
    id = "veg",
    label = "Vegetables",
    children = list(
      list(id = "leek", label = "Leek")
    )
  )
)

demo_nav <- list(
  list(index = "home", label = "Home", icon = "el-icon-house"),
  list(
    index = "data",
    label = "Data",
    icon = "el-icon-document",
    children = list(
      list(index = "data-all", label = "All records"),
      list(index = "data-new", label = "Recent")
    )
  ),
  list(
    index = "help",
    label = "Help",
    icon = "el-icon-question",
    disabled = TRUE
  )
)

slide <- function(text, bg) {
  tags$div(
    style = sprintf(
      paste0(
        "height:100%%; display:flex; align-items:center;",
        "justify-content:center; background:%s; color:#fff;",
        "font:600 20px sans-serif"
      ),
      bg
    ),
    text
  )
}

ui <- el_page(
  title = "shiny.element showcase",

  el_container(
    el_header(tags$h4("shiny.element", style = "margin:0; line-height:60px")),
    el_container(
      el_aside(
        width = "220px",
        el_menu("nav", items = demo_nav, active = "home")
      ),

      el_main(
        el_tabs(
          "section",
          selected = "inputs",

          tabs = list(
            list(
              name = "inputs",
              label = "Inputs",
              content = tagList(
                el_row(
                  gutter = 20,
                  el_col(
                    span = 12,
                    tagList(
                      el_input(
                        "name",
                        value = "Ada",
                        placeholder = "your name"
                      ),
                      tags$br(),
                      el_select(
                        "city",
                        choices = c(Beijing = "bj", Shanghai = "sh"),
                        selected = "bj"
                      ),
                      tags$br(),
                      el_input_number("age", value = 36, min = 0, max = 150),
                      tags$br(),
                      tags$br(),
                      el_date_picker("when", value = "2026-03-01")
                    )
                  ),
                  el_col(
                    span = 12,
                    tagList(
                      el_slider("score", value = 60),
                      el_rate("stars", value = 3),
                      el_switch(
                        "dark",
                        value = FALSE,
                        active_text = "on",
                        inactive_text = "off"
                      ),
                      tags$br(),
                      el_radio_group(
                        "plan",
                        choices = c(Basic = "b", Pro = "p"),
                        selected = "b"
                      ),
                      tags$br(),
                      el_checkbox_group(
                        "langs",
                        choices = c(R = "r", Python = "p"),
                        selected = "r"
                      ),
                      tags$br(),
                      el_color_picker("shade", value = "#409EFF"),
                      el_cascader(
                        "region",
                        value = list("zj", "hz"),
                        options = list(
                          list(
                            value = "zj",
                            label = "Zhejiang",
                            children = list(
                              list(value = "hz", label = "Hangzhou")
                            )
                          )
                        )
                      )
                    )
                  )
                ),
                tags$hr(),
                verbatimTextOutput("values")
              )
            ),

            list(
              name = "form",
              label = "Form",
              content = tagList(
                el_form(
                  id = "signup",
                  label_width = "110px",
                  reset_label = "Reset",
                  el_form_field(
                    "fname",
                    "input",
                    label = "Name",
                    rules = el_rule(
                      required = TRUE,
                      message = "Name is required"
                    )
                  ),
                  el_form_field(
                    "femail",
                    "input",
                    label = "Email",
                    rules = el_rule(
                      type = "email",
                      message = "Not a valid email"
                    )
                  ),
                  el_form_field(
                    "fage",
                    "input-number",
                    label = "Age",
                    value = 18,
                    min = 0,
                    max = 150
                  ),
                  el_form_field(
                    "fcity",
                    "select",
                    label = "City",
                    choices = c(Beijing = "bj", Shanghai = "sh"),
                    rules = el_rule(
                      required = TRUE,
                      message = "Pick a city",
                      trigger = "change"
                    )
                  )
                ),
                verbatimTextOutput("submitted")
              )
            ),

            list(
              name = "data",
              label = "Data",
              content = tagList(
                el_table(id = "tbl", data = head(iris, 5), selection = TRUE),
                verbatimTextOutput("picked"),
                tags$br(),
                el_pagination(
                  "pager",
                  total = 150,
                  page_size = 20,
                  current_page = 1
                )
              )
            ),

            list(
              name = "tree",
              label = "Tree",
              content = tagList(
                el_row(
                  gutter = 20,
                  el_col(
                    span = 12,
                    el_tree(
                      "picker",
                      data = demo_tree,
                      show_checkbox = TRUE,
                      checked = "apple",
                      expanded = "fruit"
                    )
                  ),
                  el_col(
                    span = 12,
                    el_timeline(
                      "log",
                      items = list(
                        list(
                          content = "Order placed",
                          timestamp = "09:15",
                          type = "primary"
                        ),
                        list(
                          content = "Shipped",
                          timestamp = "14:20",
                          type = "success",
                          icon = "el-icon-check",
                          size = "large"
                        ),
                        list(
                          content = "In transit",
                          timestamp = "08:00",
                          color = "#0bbd87"
                        )
                      )
                    )
                  )
                ),
                verbatimTextOutput("checked")
              )
            ),

            list(
              name = "display",
              label = "Display",
              content = tagList(
                el_alert(
                  "hint",
                  title = "Alerts, tags and progress",
                  type = "info",
                  description = "Every component here is a plain function call.",
                  show_icon = TRUE
                ),
                tags$br(),
                el_button("b1", "Default"),
                el_button("b2", "Primary", type = "primary"),
                el_button("b3", "Success", type = "success"),
                el_button("b4", "Danger", type = "danger"),
                tags$br(),
                tags$br(),
                el_tag("t1", label = "default"),
                el_tag("t2", label = "success", type = "success"),
                el_tag(
                  "t3",
                  label = "closable",
                  type = "warning",
                  closable = TRUE
                ),
                tags$br(),
                tags$br(),
                el_progress("pct", percentage = 60),
                tags$br(),
                el_card(
                  header = "A card",
                  "Cards nest any content, including
                      other components."
                ),
                tags$br(),
                el_carousel(
                  "banner",
                  height = "160px",
                  autoplay = FALSE,
                  items = list(
                    list(name = "one", content = slide("First", "#409EFF")),
                    list(name = "two", content = slide("Second", "#67C23A")),
                    list(name = "three", content = slide("Third", "#E6A23C"))
                  )
                )
              )
            ),

            list(
              name = "more",
              label = "More",
              content = tagList(
                el_steps(
                  "wizard",
                  active = 0,
                  finish_status = "success",
                  steps = list(
                    list(title = "Pick"),
                    list(title = "Confirm"),
                    list(title = "Done")
                  )
                ),
                el_button("next_step", "Next step"),
                tags$hr(),
                el_collapse(
                  "panels",
                  value = "p1",
                  items = list(
                    list(
                      name = "p1",
                      title = "A panel holding components",
                      content = tagList(
                        el_input("inside", value = "still live"),
                        el_rate("inside_rate", value = 4)
                      )
                    ),
                    list(
                      name = "p2",
                      title = "Plain text",
                      content = "Just text."
                    )
                  )
                ),
                tags$hr(),
                el_upload(
                  "files",
                  drag = TRUE,
                  multiple = TRUE,
                  tip = "Files arrive as fileInput() would deliver them"
                ),
                tableOutput("uploaded"),
                tags$hr(),
                el_dropdown(
                  "menu",
                  trigger_label = "Actions",
                  items = list(
                    list(command = "edit", label = "Edit"),
                    list(command = "copy", label = "Duplicate")
                  )
                ),
                el_button("open_dialog", "Open dialog", type = "primary"),
                el_button("open_drawer", "Open drawer"),
                el_button("notify", "Notify")
              )
            )
          )
        )
      )
    )
  ),

  el_dialog(
    "dlg",
    title = "A dialog holding components",
    width = "460px",
    content = tagList(
      el_input("dlg_in", value = "still connected"),
      el_rate("dlg_rate", value = 3)
    ),
    footer = el_button("dlg_ok", "OK", type = "primary")
  ),

  el_drawer(
    "drw",
    title = "A drawer",
    size = "320px",
    content = tagList(
      el_switch("drw_sw", value = TRUE),
      tags$p("Drawers nest components too.")
    )
  )
)

server <- function(input, output, session) {
  output$values <- renderPrint({
    list(
      name = input$name,
      city = input$city,
      age = input$age,
      score = input$score,
      stars = input$stars,
      dark = input$dark,
      plan = input$plan,
      langs = input$langs,
      region = input$region_value
    )
  })

  output$submitted <- renderPrint({
    req(input$signup_submit)
    if (!isTRUE(input$signup_valid)) {
      return("Fix the errors above")
    }
    input$signup
  })

  output$picked <- renderPrint({
    rows <- input$tbl_selected_rows
    if (is.null(rows)) "Select some rows" else head(iris, 5)[rows, ]
  })

  output$checked <- renderPrint({
    list(
      checked = input$picker_checked,
      clicked = input$picker,
      menu = input$nav,
      tab = input$section
    )
  })

  output$uploaded <- renderTable({
    req(input$files)
    input$files[, c("name", "size", "type")]
  })

  observeEvent(
    input$score,
    {
      update_el_progress(session, "pct", percentage = input$score)
    },
    ignoreInit = TRUE
  )

  n_steps <- 3L
  observeEvent(input$next_step, {
    current <- input$wizard
    update_el_steps(
      session,
      "wizard",
      active = if (current >= n_steps) 0L else current + 1L
    )
  })

  observeEvent(
    input$open_dialog,
    update_el_dialog(session, "dlg", visible = TRUE)
  )
  observeEvent(input$dlg_ok, update_el_dialog(session, "dlg", visible = FALSE))
  observeEvent(
    input$open_drawer,
    update_el_drawer(session, "drw", visible = TRUE)
  )

  observeEvent(input$notify, {
    el_notification(
      session,
      message = paste("Hello,", input$name),
      title = "Notification",
      type = "success"
    )
  })

  observeEvent(input$menu, {
    el_message(session, message = paste("Command:", input$menu), type = "info")
  })
}

shinyApp(ui, server)
