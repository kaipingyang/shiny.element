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

# A module: the same components inside a namespace, built both in the module
# UI function and by renderUI() in the module server, where the default
# reactive domain is the module's own session.
mod_ui <- function(id) {
  ns <- NS(id)
  tags$div(id = ns("box"),
    el_input(ns("text"), value = "in module"),
    el_select(ns("pick"), choices = c(A = "a", B = "b"), selected = "a"),
    el_table(ns("rows"), data = data.frame(n = 1:2), columns = list(
      list(prop = "n", label = "N"),
      list(label = "", cell = el$button(size = "mini",
        "@click" = "rowAction('go', scope)", "Go")))),
    el_tabs(ns("tabs"), tabs = list(list(name = "one", label = "One", content = "1"))),
    uiOutput(ns("dyn")),
    actionButton(ns("set"), "set"),
    actionButton(ns("add_tab"), "add tab"),
    verbatimTextOutput(ns("dump"))
  )
}

mod_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$dyn <- renderUI(el_switch(ns("flag"), value = TRUE))
    observeEvent(input$set, {
      update_el_input(session, "text", value = "set from module")
      update_el_select(session, "pick", selected = "b")
    })
    observeEvent(input$add_tab, {
      insert_el_tab(session, "tabs", "two", "Two", content = el_rate(ns("stars"), value = 2))
    })
    went <- reactiveVal("none")
    observeEvent(input$rows_go, went(as.character(input$rows_go$row_index)))
    output$dump <- renderPrint({
      for (i in c("text", "pick", "flag", "tabs", "stars")) {
        cat(i, "=", if (is.null(input[[i]])) "<NULL>" else paste(input[[i]], collapse = ","), "\n")
      }
      cat("went", "=", went(), "\n")
    })
  })
}

ui <- el_page(
  title = "integration",
  # Vue's development build, so its warnings reach the console instead of
  # being stripped; test-browser.R asserts there are none.
  dev = TRUE,

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
  # Tabs are plain markup driven by an input binding, so a pane can hold
  # another component and it stays connected to the server.
  el_tabs("tabs", selected = "t2", tabs = list(
    list(name = "t1", label = "T1", content = el_switch("tab_nested", value = TRUE)),
    list(name = "t2", label = "T2", content = "c2"))),
  actionButton("tabs_go", "select t1"),

  # Dialog and drawer are plain markup driven by the shared overlay binding,
  # so their bodies can hold other components and stay mounted while closed.
  el_dialog("dlg", title = "D", visible = FALSE,
            content = el_switch("dlg_nested", value = TRUE)),
  el_drawer("drw", title = "Dr", content = "x", visible = FALSE),
  actionButton("dlg_open", "open dialog"),
  el_pagination("pg", total = 100, current_page = 3, page_size = 20),
  # Collapse is plain markup driven by an input binding, so a panel can hold
  # another component and it stays connected to the server.
  el_collapse("col",
    items = list(
      list(name = "i1", title = "I1", content = el_switch("col_nested", value = TRUE)),
      list(name = "i2", title = "I2", content = "c2")),
    value = "i2"),
  actionButton("col_open", "open i1"),

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

  # Menu: nests in R rather than with v-for, and reports both the selected
  # index and its full path.
  tags$div(style = "width:220px",
    el_menu("nav", active = "m-home", items = list(
      list(index = "m-home", label = "Home", icon = "el-icon-house"),
      list(index = "m-prod", label = "Products", children = list(
        list(index = "m-all", label = "All"),
        list(index = "m-off", label = "Discontinued", disabled = TRUE)
      )),
      list(index = "m-grp", label = "Group", group = TRUE, children = list(
        list(index = "m-in", label = "In group")
      ))
    ))),
  actionButton("nav_pick", "select m-all"),

  # Tree: structure arrives as data rather than tags, and replacing a checked
  # set needs the component's own method.
  tags$div(style = "width:240px",
    el_tree("tree", show_checkbox = TRUE, expanded = "t-fruit",
            checked = c("t-apple"), data = list(
      list(id = "t-fruit", label = "Fruit", children = list(
        list(id = "t-apple", label = "Apple"),
        list(id = "t-plum",  label = "Plum", disabled = TRUE)
      )),
      list(id = "t-grain", label = "Grains")
    ))),
  actionButton("tree_check", "check grains only"),

  # Upload: Element's UI with Shiny's transport, so a whole selection arrives
  # as one batch rather than one job per file.
  el_upload("up", drag = TRUE, multiple = TRUE, tip = "any file"),

  # Carousel: slides are static markup; moving between them needs the
  # component's own setActiveItem.
  tags$div(style = "width:300px",
    el_carousel("car", height = "80px", autoplay = FALSE, items = list(
      list(name = "s1", content = "slide one"),
      list(name = "s2", content = "slide two"),
      list(name = "s3", content = "slide three")
    ))),
  actionButton("car_go", "third slide"),

  # Timeline: entries render through one v-for so they can be replaced.
  tags$div(style = "width:280px",
    el_timeline("tl", items = list(
      list(content = "Created", timestamp = "09:00", type = "primary"),
      list(content = "No stamp")
    ))),
  actionButton("tl_add", "append entry"),

  # Forces the icon font to load, so the offline-assets test has something
  # to observe.
  tags$i(class = "el-icon-edit"),
  # No color argument: guards the null-placeholder regression, since Element's
  # ElProgress calls .length on color and throws on JSON null.
  el_progress("probe_progress", percentage = 40),

  # Two buttons side by side: the mount-point div used to be block-level, so
  # every component started on its own line.
  tags$div(id = "inline_probe",
    el_button("probe_b1", "One"), el_button("probe_b2", "Two")),

  tags$div(id = "call_probe",
    el_button("call_clear", "clearSelection"),
    el_button("call_keys", "getCheckedKeys"),
    el_button("call_validate", "validate"),
    el_button("call_missing", "no such method")),

  # Does a widget survive being wrapped by another component's Vue instance?
  tags$div(id = "nest_probe",
    el_tooltip("tip", el$button(type = "primary", "Hover me"), content = "a hint"),
    # A real component as a tooltip trigger, absorbed rather than nested
    tags$div(id = "nest_raw",
      el_tooltip("wrap", el_button("nested_btn", "Nested"), content = "works"),
      # Two components in one wrapper: the second one's fields are renamed
      el_popover("twoup", el_button("pop_btn", "Open"),
                 body = el_tag("pop_tag", "inside"), title = "Both")),
    el_popconfirm("pc", el_button("pc_btn", "Delete", type = "danger"), title = "Sure?"),
    el_avatar("av", content = "KY"),
    el_breadcrumb("crumb", items = list(list(label = "Home"), list(label = "Here")))),

  # Values set from the server, which Element does not report as `change`
  actionButton("set_values", "set values"),

  verbatimTextOutput("dump"),

  mod_ui("mod")
)

server <- function(input, output, session) {
  mod_server("mod")
  fmt <- function(x) {
    if (is.null(x)) return("<NULL>")
    paste(format(x), collapse = ",")
  }

  output$dump <- renderPrint({
    invalidateLater(1000, session)
    ids <- c("inp", "sel", "sw", "sld", "rate", "rg", "cg", "num", "dp", "cp",
             "tabs", "pg_page", "pg_size", "col", "rg_num", "stp",
             "tbl_selected_rows", "casc_value", "sw_nested", "sld_nested",
             "signup_submit", "signup_valid", "nav", "nav_path",
             "tree", "tree_checked", "car", "car_name", "col_nested",
             "tab_nested", "dlg", "drw", "dlg_nested")
    for (i in ids) cat(i, "=", fmt(input[[i]]), "\n")
    cat("up_rows", "=", if (is.null(input$up)) "<NULL>" else nrow(input$up), "\n")
    # Forwarded Element events are latched by the observers below, which is
    # how an app acts on each one -- repeats included.
    cat("events_seen", "=", paste(names(seen_events), collapse = "/"), "\n")
    for (nm in c("called_keys", "called_validate", "row_index")) {
      if (!is.null(seen_events[[nm]])) cat(nm, "=", fmt(seen_events[[nm]]), "\n")
    }
    cat("raw_row_click", "=", fmt(input$tbl_row_click), "\n")
  })

  # Prove a forwarded event reaches the server at all
  seen_events <- reactiveValues()
  observeEvent(input$tbl_row_click, {
    seen_events$tbl_row_click <- "fired"
    # A row event is a named list; its row_index indexes the original data
    seen_events$row_index <- input$tbl_row_click$row_index
  })
  observeEvent(input$inp_focus, {
    seen_events$inp_focus <- "fired"
  })
  observeEvent(input$tree_node_expand, {
    seen_events$tree_node_expand <- "fired"
  })
  observeEvent(input$pc_confirm, {
    seen_events$pc_confirm <- "fired"
  })

  # el_call(): a command, a query, and a promise-returning method
  observeEvent(input$call_clear, {
    el_call(session, "tbl", "clearSelection")
  })
  observeEvent(input$call_keys, {
    el_call(session, "tree", "getCheckedKeys")
  })
  observeEvent(input$call_validate, {
    el_call(session, "signup", "validate")
  })
  observeEvent(input$call_missing, {
    el_call(session, "tbl", "noSuchMethod")
  })
  observeEvent(input$tbl_clear_selection, {
    seen_events$called_clear <- "fired"
  })
  observeEvent(input$tree_get_checked_keys, {
    seen_events$called_keys <- paste(input$tree_get_checked_keys, collapse = "/")
  })
  observeEvent(input$signup_validate, {
    seen_events$called_validate <- as.character(input$signup_validate)
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

  observeEvent(input$dlg_open, {
    update_el_dialog(session, "dlg", visible = TRUE)
  })

  observeEvent(input$tabs_go, {
    update_el_tabs(session, "tabs", selected = "t1")
  })

  observeEvent(input$col_open, {
    update_el_collapse(session, "col", value = "i1")
  })

  observeEvent(input$car_go, {
    update_el_carousel(session, "car", active = 2)
  })

  observeEvent(input$tl_add, {
    update_el_timeline(session, "tl", items = list(
      list(content = "Created", timestamp = "09:00", type = "primary"),
      list(content = "No stamp"),
      list(content = "Appended", timestamp = "10:00", type = "success")
    ))
  })

  observeEvent(input$tree_check, {
    update_el_tree(session, "tree", checked = "t-grain")
  })

  observeEvent(input$nav_pick, {
    update_el_menu(session, "nav", active = "m-all")
  })

  observeEvent(input$form_prefill, {
    update_el_form(session, "signup",
                   model = list(fname = "Ada", fcity = "sh"))
  })

  observeEvent(input$set_values, {
    update_el_input(session, "inp", value = "from server")
    update_el_select(session, "sel", selected = "a")
    update_el_switch(session, "sw", value = FALSE)
    update_el_slider(session, "sld", value = 7)
    update_el_input_number(session, "num", value = 9)
  })

  observeEvent(input$casc_update, {
    update_el_cascader(session, "casc",
                       value = list("js", "nj"), placeholder = "updated",
                       disabled = TRUE)
  })
}

shinyApp(ui, server)
