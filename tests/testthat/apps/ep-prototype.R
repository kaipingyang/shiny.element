# Element Plus prototype: the bridge on Vue 3, five components, overlays,
# dynamic UI and the theme.
library(shiny)
library(shiny.element)

ui <- el_page(
  theme = el_theme(primary = "#7c3aed"),
  el_button("btn", "Click", type = "primary"),
  el_input("inp", value = "hello", label = "Name"),
  el_select("sel", choices = c(A = "a", B = "b", C = "c"), selected = "b"),
  el_table("tbl", data = head(iris, 3), selection = TRUE),
  el_table(id = "grp", data = data.frame(a = 1:2, b = 3:4, c = 5:6),
    columns = list(
      list(prop = "a", label = "A"),
      list(label = "Group", children = list(
        list(prop = "b", header_html = tags$i(class = "grp-head", "Bee"),
             cell = tags$b(class = "grp-cell", "{{scope.row.b}}")),
        list(label = "Inner", children = list(
          list(prop = "c", cell = tags$u(class = "grp-cell2", "{{scope.row.c}}")))))))),
  el_form(id = "frm",
    el_form_field("fname", "input", label = "Name",
                  rules = el_rule(required = TRUE, message = "name required")),
    el_form_field("fage", "input-number", label = "Age", value = 18)),
  actionButton("upd", "update"),
  actionButton("add", "insert"),
  actionButton("rm", "remove"),
  actionButton("call", "call"),
  el_button("open_dlg", "Open dialog"),
  el_dialog("dlg", title = "Dialog", el_input("dlg_inp", value = "inside"),
            el_select("dlg_sel", choices = c("x", "y"))),
  el_button("open_drw", "Open drawer"),
  el_drawer("drw", title = "Drawer", el_switch("drw_sw", value = TRUE)),
  uiOutput("dyn"),
  # Components Element Plus added
  el_segmented("seg", options = c(Day = "d", Week = "w"), value = "w"),
  el_input_tag("itag", value = c("a", "b")),
  el_select_v2("sv2", options = paste("Option", 1:2000), value = "Option 5"),
  el_tree_select("tsel", value = "web", data = list(
    list(value = "eng", label = "Engineering", children = list(
      list(value = "web", label = "Web"))))),
  el_check_tag("ctag", "Pinned", value = TRUE),
  el_input_otp("otp", length = 4),
  el_table_v2("tv2", data = data.frame(n = 1:5000, sq = (1:5000)^2), height = 200),
  el_space(el_button("sp1", "One"), el_button("sp2", "Two"), size = 30),
  tags$div(id = "slot"),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  observeEvent(input$open_dlg, update_el_dialog(session, "dlg", visible = TRUE))
  observeEvent(input$open_drw, update_el_drawer(session, "drw", visible = TRUE))
  observeEvent(input$upd, {
    update_el_input(session, "inp", value = "updated", label = "New name")
    update_el_select(session, "sel", selected = "c")
    update_el_table(session, "tbl", data = head(iris, 5))
  })
  observeEvent(input$call, el_call(session, "tbl", "toggleRowSelection",
                                   list(el_table_row(2), TRUE)))
  output$dyn <- renderUI(el_input("dyn_inp", value = "dynamic"))
  observeEvent(input$add, insertUI("#slot", ui = el_switch("ins_sw", value = TRUE)))
  observeEvent(input$rm, removeUI("#ins_sw"))
  output$dump <- renderPrint({
    invalidateLater(500)
    ids <- c("seg", "itag", "sv2", "tsel", "ctag", "otp", "sp2",
             "btn", "inp", "sel", "tbl_selected_rows", "fname", "frm_submit",
             "dlg", "drw", "dlg_inp", "drw_sw", "dyn_inp", "ins_sw", "open_dlg")
    for (i in ids) cat(i, "=", if (is.null(input[[i]])) "<NULL>" else paste(format(input[[i]]), collapse = ","), "\n")
  })
}

shinyApp(ui, server)
