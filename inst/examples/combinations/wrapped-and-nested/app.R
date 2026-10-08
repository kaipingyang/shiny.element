# Controls folded into a space, a collapse and a tooltip, inside tabs
# inside a config provider; a module; a form in a dialog that is destroyed
# on close; a popover filtering a table output.
#
#   shiny::runApp(system.file("examples/combinations/wrapped-and-nested", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/wrapped-and-nested.R).

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

people <- data.frame(
  name = c("Ada", "Grace", "Linus", "Margaret"),
  team = c("core", "ui", "core", "docs"),
  age = c(36, 45, 28, 51)
)

# a module, wrapped twice over, updated through its own session
mod_ui <- function(id) {
  ns <- NS(id)
  el_card(
    header = "module",
    el_space(
      el_tooltip(
        ns("tip"),
        el_button(ns("btn"), "Module button", type = "primary"),
        content = "inside a tooltip, inside a space"
      ),
      el_select(
        ns("pick"),
        choices = c("x", "y", "z"),
        selected = "x",
        width = "120px"
      )
    ),
    textOutput(ns("said"))
  )
}
mod_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$said <- renderText(paste(
      "btn",
      input$btn %||% 0,
      "pick",
      input$pick %||% ""
    ))
    observeEvent(input$btn, {
      update_el_button(session, "btn", label = paste("Clicked", input$btn))
      update_el_select(session, "pick", selected = "z")
    })
  })
}

ui <- el_page(
  el_config_provider(
    id = "cfg",
    size = "small",
    el_tabs(
      "tabs",
      tabs = list(
        list(
          name = "one",
          label = "Nested",
          content = tagList(
            el_collapse(
              "coll",
              value = "a",
              items = list(
                list(
                  name = "a",
                  title = "Wrapped controls",
                  content = el_space(
                    id = "space1",
                    el_button("b1", "First"),
                    el_button("b2", "Second", type = "success"),
                    el_input("in1", value = "hello", width = "160px"),
                    el_switch("sw1", value = TRUE)
                  )
                ),
                list(
                  name = "b",
                  title = "Slider in a closed panel",
                  content = el_slider("sl_hidden", value = 30)
                )
              )
            ),
            el_button("upd_wrapped", "Update the wrapped ones"),
            mod_ui("m1"),
            verbatimTextOutput("dump1")
          )
        ),
        list(
          name = "two",
          label = "Dialog + form",
          content = tagList(
            el_button("open_dlg", "Open dialog", type = "primary"),
            el_dialog(
              "dlg",
              title = "Edit",
              destroy_on_close = TRUE,
              content = el_form(
                id = "frm",
                label_width = "100px",
                el_form_field(
                  "who",
                  "select",
                  label = "Who",
                  choices = people$name,
                  rules = el_rule(
                    required = TRUE,
                    message = "Pick someone",
                    trigger = "change"
                  )
                ),
                el_form_item(
                  "When",
                  el_form_field("d", "date-picker", style = "width: 100%"),
                  "-",
                  el_form_field("t", "time-picker", style = "width: 100%")
                ),
                el_form_field("note", "textarea", label = "Note")
              )
            ),
            verbatimTextOutput("dump2")
          )
        ),
        list(
          name = "three",
          label = "Table + popover",
          content = tagList(
            el_popover(
              "pop",
              reference = el_button("pop_btn", "Filter"),
              trigger = "click",
              popover_width = 260,
              body = tagList(
                el_select(
                  "team",
                  choices = c("all", unique(people$team)),
                  selected = "all",
                  teleported = FALSE
                ),
                el_slider("min_age", value = 0, max = 60)
              )
            ),
            el_table_output("tbl"),
            el_pagination(
              "pg",
              total = 4,
              page_size = 2,
              layout = "prev, pager, next"
            ),
            verbatimTextOutput("dump3")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  mod_server("m1")
  output$dump1 <- renderText(inputs_text(list(
    b1 = input$b1,
    b2 = input$b2,
    in1 = input$in1,
    sw1 = input$sw1,
    sl = input$sl_hidden,
    coll = input$coll
  )))
  observeEvent(input$upd_wrapped, {
    update_el_button(session, "b2", label = "Second (updated)", type = "danger")
    update_el_input(session, "in1", value = "changed")
    update_el_switch(session, "sw1", value = FALSE)
    update_el_slider(session, "sl_hidden", value = 77)
  })
  observeEvent(input$open_dlg, update_el_dialog(session, "dlg", visible = TRUE))
  output$dump2 <- renderText(inputs_text(list(
    frm = input$frm,
    valid = input$frm_valid,
    submit = input$frm_submit,
    dlg = input$dlg
  )))
  shown <- reactive({
    d <- people
    if (!is.null(input$team) && input$team != "all") {
      d <- d[d$team == input$team, ]
    }
    d <- d[d$age >= (input$min_age %||% 0), ]
    d
  })
  output$tbl <- render_el_table({
    d <- shown()
    page <- input$pg %||% 1
    rows <- d[seq_len(nrow(d)) %in% ((page - 1) * 2 + 1:2), , drop = FALSE]
    el_table(data = rows, selection = TRUE)
  })
  observe(update_el_pagination(session, "pg", total = nrow(shown())))
  output$dump3 <- renderText(inputs_text(list(
    team = input$team,
    min_age = input$min_age,
    pg = input$pg,
    rows = input$tbl_selection_rows,
    pop = input$pop
  )))
}

shinyApp(ui, server)
