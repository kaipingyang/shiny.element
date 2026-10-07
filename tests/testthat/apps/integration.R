# Fixture app for the browser integration tests. Every widget here covers a
# failure that the HTML-level unit tests cannot see; see test-browser.R.
library(shiny)
library(shiny.element)

cascader_opts <- list(
  list(
    value = "zj",
    label = "Zhejiang",
    children = list(
      list(value = "hz", label = "Hangzhou"),
      list(value = "nb", label = "Ningbo")
    )
  ),
  list(
    value = "js",
    label = "Jiangsu",
    children = list(
      list(value = "nj", label = "Nanjing")
    )
  )
)

# A module: the same components inside a namespace, built both in the module
# UI function and by renderUI() in the module server, where the default
# reactive domain is the module's own session.
mod_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    id = ns("box"),
    el_input(ns("text"), value = "in module"),
    el_select(ns("pick"), choices = c(A = "a", B = "b"), selected = "a"),
    el_table(
      ns("rows"),
      data = data.frame(n = 1:2),
      columns = list(
        list(prop = "n", label = "N"),
        list(
          label = "",
          cell = el$button(
            size = "small",
            "@click" = "rowAction('go', scope)",
            "Go"
          )
        )
      )
    ),
    el_tabs(
      ns("tabs"),
      tabs = list(list(name = "one", label = "One", content = "1"))
    ),
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
      insert_el_tab(
        session,
        "tabs",
        "two",
        "Two",
        content = el_rate(ns("stars"), value = 2)
      )
    })
    went <- reactiveVal("none")
    observeEvent(input$rows_go, went(as.character(input$rows_go$row_index)))
    output$dump <- renderPrint({
      for (i in c("text", "pick", "flag", "tabs", "stars")) {
        cat(
          i,
          "=",
          if (is.null(input[[i]])) {
            "<NULL>"
          } else {
            paste(input[[i]], collapse = ",")
          },
          "\n"
        )
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
  el_date_picker(
    "dr",
    type = "daterange",
    value = c("2026-01-01", "2026-01-31")
  ),
  el_date_picker(
    "dmonth",
    type = "month",
    value = "2026-03",
    value_format = "yyyy-MM"
  ),
  el_color_picker("cp", value = "#409EFF"),
  # Tabs are plain markup driven by an input binding, so a pane can hold
  # another component and it stays connected to the server.
  el_tabs(
    "tabs",
    selected = "t2",
    tabs = list(
      list(
        name = "t1",
        label = "T1",
        content = el_switch("tab_nested", value = TRUE)
      ),
      list(name = "t2", label = "T2", content = "c2")
    )
  ),
  actionButton("tabs_go", "select t1"),

  # Dialog and drawer are plain markup driven by the shared overlay binding,
  # so their bodies can hold other components and stay mounted while closed.
  el_dialog(
    "dlg",
    title = "D",
    visible = FALSE,
    content = el_switch("dlg_nested", value = TRUE)
  ),
  el_drawer("drw", title = "Dr", content = "x", visible = FALSE),
  actionButton("dlg_open", "open dialog"),
  el_pagination("pg", total = 100, current_page = 3, page_size = 20),
  # Collapse is plain markup driven by an input binding, so a panel can hold
  # another component and it stays connected to the server.
  el_collapse(
    "col",
    items = list(
      list(
        name = "i1",
        title = "I1",
        content = el_switch("col_nested", value = TRUE)
      ),
      list(name = "i2", title = "I2", content = "c2")
    ),
    value = "i2"
  ),
  actionButton("col_open", "open i1"),

  # Named non-character choices: labels used to be lost and options serialised
  # as a JSON object instead of an array.
  el_radio_group("rg_num", choices = c(First = 1, Second = 2), selected = 1),

  # Steps: reaching "all finished" needs active == number of steps.
  el_steps(
    "stp",
    active = 0,
    finish_status = "success",
    steps = list(list(title = "S1"), list(title = "S2"), list(title = "S3"))
  ),
  actionButton("step_next", "next step"),

  # Table: a data.frame used to serialise column-wise and render nothing.
  el_table(
    id = "tbl",
    data = head(iris, 4),
    selection = TRUE,
    events = "row-click"
  ),
  actionButton("tbl_swap", "swap table data"),

  # A table as an output: input$otbl_selection_rows the row numbers, its selection-change
  # the rows as R subsets them; rendered again with the same data it keeps
  # the ticks, with other data it starts over.
  el_table_output("otbl"),
  actionButton("otbl_again", "render the same rows again"),
  actionButton("otbl_more", "render other rows"),
  actionButton("otbl_slow", "render slowly"),
  # rows edited from the server, one at a time
  actionButton("otbl_insert", "insert a row first"),
  actionButton("otbl_replace", "replace the first row"),
  actionButton("otbl_delete", "delete the first row"),
  # cells edited in place, each edit applied on the server with R's types
  el_table_output("etbl"),
  # a planner: the server keeps the events and answers each request
  el_calendar(
    "plan",
    value = "2026-10-07",
    events = data.frame(
      id = 1:3,
      date = as.Date("2026-10-05") + c(0, 2, 9),
      end = as.Date(c(NA, "2026-10-09", NA)),
      title = c("Standup", "Conference", "Review"),
      type = c("primary", "success", "warning")
    ),
    editable = TRUE
  ),
  # a cached table: renders read back from the cache still patch the page
  el_table_output("ctbl"),
  actionButton("ctbl_four", "four rows"),
  actionButton("ctbl_three", "three rows"),

  # Group headers: a child column's own cell and header templates used to
  # stay in its JSON, never rendered.
  el_table(
    id = "grp_tbl",
    data = data.frame(a = 1:2, b = 3:4, c = 5:6),
    columns = list(
      list(prop = "a", label = "A"),
      list(
        label = "Group",
        children = list(
          list(
            prop = "b",
            header_html = tags$i(class = "grp-head", "Bee"),
            cell = tags$b(class = "grp-cell", "{{scope.row.b}}")
          ),
          list(
            label = "Inner",
            children = list(
              list(
                prop = "c",
                header_html = "<i class='grp-head2'>Sea</i>",
                cell = tags$u(class = "grp-cell2", "{{scope.row.c}}")
              )
            )
          )
        )
      )
    )
  ),

  # Form-item markup given as tags: it used to arrive as serialised JSON.
  el_form(
    id = "htmlf",
    submit_label = NULL,
    el_form_field(
      "hf",
      "input",
      label = "Plain",
      label_html = tags$b(id = "hf-label", "Bold"),
      error_html = tags$em(id = "hf-error", "Bad")
    ),
    el_form_field(
      "hf2",
      "input",
      label = "Plain",
      rules = el_rule(required = TRUE, message = "x"),
      error_html = tags$em(class = "hf2-error", "Needed")
    )
  ),

  # Cascader: its handler script was never loaded, so updates went unheard.
  el_cascader(
    "casc",
    options = cascader_opts,
    value = list("zj", "hz"),
    placeholder = "pick one"
  ),
  actionButton("casc_update", "update cascader"),

  # Layout: these used to emit uncompiled custom tags and, for the container,
  # silently swallow any nested widget.
  tags$div(
    id = "grid",
    style = "width:800px",
    el_row(
      gutter = 20,
      el_col(span = 12, tags$div("left")),
      el_col(span = 12, tags$div("right"))
    )
  ),
  tags$div(
    id = "flexrow",
    style = "width:800px",
    el_row(
      type = "flex",
      justify = "center",
      align = "middle",
      el_col(span = 8, tags$div("centred"))
    )
  ),
  tags$div(
    id = "layout",
    style = "width:800px; height:200px",
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
    id = "signup",
    label_width = "110px",
    reset_label = "Reset",
    el_form_field(
      "fname",
      "input",
      label = "Name",
      rules = el_rule(required = TRUE, message = "name required")
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
        message = "pick a city",
        trigger = "change"
      )
    )
  ),
  actionButton("form_prefill", "prefill form"),

  # Menu: nests in R rather than with v-for, and reports both the selected
  # index and its full path.
  tags$div(
    style = "width:220px",
    el_menu(
      "nav",
      active = "m-home",
      items = list(
        list(index = "m-home", label = "Home", icon = "el-icon-house"),
        list(
          index = "m-prod",
          label = "Products",
          children = list(
            list(index = "m-all", label = "All"),
            list(index = "m-off", label = "Discontinued", disabled = TRUE)
          )
        ),
        list(
          index = "m-grp",
          label = "Group",
          group = TRUE,
          children = list(
            list(index = "m-in", label = "In group")
          )
        )
      )
    )
  ),
  actionButton("nav_pick", "select m-all"),

  # Tree: structure arrives as data rather than tags, and replacing a checked
  # set needs the component's own method.
  tags$div(
    style = "width:240px",
    el_tree(
      "tree",
      show_checkbox = TRUE,
      expanded = "t-fruit",
      checked = c("t-apple"),
      data = list(
        list(
          id = "t-fruit",
          label = "Fruit",
          children = list(
            list(id = "t-apple", label = "Apple"),
            list(id = "t-plum", label = "Plum", disabled = TRUE)
          )
        ),
        list(id = "t-grain", label = "Grains")
      )
    )
  ),
  actionButton("tree_check", "check grains only"),

  # Upload: Element's UI with Shiny's transport, so a whole selection arrives
  # as one batch rather than one job per file.
  el_upload("up", drag = TRUE, multiple = TRUE, tip = "any file"),

  # Carousel: slides are static markup; moving between them needs the
  # component's own setActiveItem.
  tags$div(
    style = "width:300px",
    el_carousel(
      "car",
      height = "80px",
      autoplay = FALSE,
      items = list(
        list(name = "s1", content = "slide one"),
        list(name = "s2", content = "slide two"),
        list(name = "s3", content = "slide three")
      )
    )
  ),
  actionButton("car_go", "third slide"),

  # Timeline: entries render through one v-for so they can be replaced.
  tags$div(
    style = "width:280px",
    el_timeline(
      "tl",
      items = list(
        list(content = "Created", timestamp = "09:00", type = "primary"),
        list(content = "No stamp")
      )
    )
  ),
  actionButton("tl_add", "append entry"),

  # An icon outside any component, drawn by the page
  el_icon("Edit"),
  # No color argument: guards the null-placeholder regression, since Element's
  # ElProgress calls .length on color and throws on JSON null.
  el_progress("probe_progress", percentage = 40),

  # Two buttons side by side: the mount-point div used to be block-level, so
  # every component started on its own line.
  tags$div(
    id = "inline_probe",
    el_button("probe_b1", "One"),
    el_button("probe_b2", "Two")
  ),

  tags$div(
    id = "call_probe",
    el_button("call_clear", "clearSelection"),
    el_button("call_keys", "getCheckedKeys"),
    el_button("call_validate", "validate"),
    el_button("call_missing", "no such method")
  ),

  # Does a widget survive being wrapped by another component's Vue instance?
  tags$div(
    id = "nest_probe",
    el_tooltip(
      "tip",
      el$button(type = "primary", "Hover me"),
      content = "a hint"
    ),
    # A real component as a tooltip trigger, absorbed rather than nested
    tags$div(
      id = "nest_raw",
      el_tooltip("wrap", el_button("nested_btn", "Nested"), content = "works"),
      # Two components in one wrapper: the second one's fields are renamed
      el_popover(
        "twoup",
        el_button("pop_btn", "Open"),
        body = el_tag("pop_tag", "inside"),
        title = "Both"
      )
    ),
    el_popconfirm(
      "pc",
      el_button("pc_btn", "Delete", type = "danger"),
      title = "Sure?"
    ),
    el_avatar("av", content = "KY"),
    el_breadcrumb(
      "crumb",
      items = list(list(label = "Home"), list(label = "Here"))
    )
  ),

  # Values set from the server, which Element does not report as `change`
  actionButton("set_values", "set values"),

  verbatimTextOutput("dump"),

  # The rest of the Shiny ecosystem addresses a component by its id
  if (requireNamespace("shinyjs", quietly = TRUE)) shinyjs::useShinyjs(),
  el_input("js_hide", value = "hide me"),
  el_input("js_off", value = "disable me"),
  el_input("js_gone", value = "remove me"),
  actionButton("js_go", "shinyjs"),
  el_input("val_email", placeholder = "Email"),
  el_input(
    "val_name",
    label = "Name",
    label_position = "left",
    error = "Taken"
  ),
  el_select("lab_city", choices = c("bj", "sh"), label = "City"),
  el_switch("lab_on", label = "Notify", label_position = "left"),
  actionButton("val_go", "validate"),

  # Components added in the upstream pass
  el_checkbox("cb1", "I agree"),
  actionButton("cb_set", "set checkbox"),
  el_button_group(el_button("grp_a", "A"), el_button("grp_b", "B"), id = "grp"),
  el_badge(el_button("bdg_btn", "Inbox"), value = 3, id = "bdg"),
  actionButton("bdg_set", "set badge"),
  el_link("More", id = "lnk", type = "primary"),
  el_autocomplete("ac_remote", remote = TRUE),
  el_form(
    id = "dyn",
    submit_label = NULL,
    el_form_field("email", "input", label = "Email"),
    el_form_field(
      "even",
      "input-number",
      label = "Even",
      value = 1,
      rules = el_rule(
        validator = JS(
          "function(rule, value, callback) {",
          "  value % 2 === 0 ? callback() : callback(new Error('An even number'));",
          "}"
        ),
        trigger = "change"
      )
    )
  ),
  actionButton("dyn_add", "add field"),
  actionButton("dyn_err", "server error"),
  actionButton("dyn_check", "validate"),
  verbatimTextOutput("new_dump"),

  # An action button, and an input absorbed into a wrapper
  el_button("act_btn", "Act"),
  actionButton("tree_filter", "filter tree"),
  actionButton("tbl_pick", "select row 2 by method"),
  actionButton("carousel_forward", "carousel next by method"),
  actionButton("menu_open_btn", "open submenu by method"),
  el_tooltip(
    "abs_tip",
    el_switch("abs_sw", value = FALSE),
    content = "Absorbed"
  ),
  verbatimTextOutput("act_dump"),

  # The server answering what Element would fetch with a JS function
  el_input("upd_lab", label = "Old", label_suffix = ":"),
  actionButton("upd_tag", "tag label"),
  actionButton("upd_go", "update label"),
  actionButton("upd_clear", "clear error"),
  el_tree("lz_tree", lazy = TRUE, node_key = "id", is_leaf_field = "leaf"),
  el_cascader("lz_casc", props = list(lazy = TRUE)),
  el_select("rm_sel", filterable = TRUE, remote = TRUE),
  # Remote searches no observer answers
  el_select("rm_none", filterable = TRUE, remote = TRUE),
  el_autocomplete("ac_none", remote = TRUE),
  el_table(
    id = "lz_tbl",
    row_key = "id",
    lazy = TRUE,
    data = data.frame(
      id = c(1, 2),
      name = c("a", "b"),
      hasChildren = c(TRUE, FALSE)
    )
  ),

  # A component type that appears nowhere else on the page, only through
  # renderUI(): its handler script arrives after shiny:connected has fired.
  uiOutput("late"),
  actionButton("late_set", "set late"),
  actionButton("late_call", "call late"),
  verbatimTextOutput("late_dump"),

  mod_ui("mod")
)

server <- function(input, output, session) {
  mod_server("mod")

  if (requireNamespace("shinyvalidate", quietly = TRUE)) {
    iv <- shinyvalidate::InputValidator$new()
    iv$add_rule("val_email", shinyvalidate::sv_required("An email, please"))
    iv$add_rule("val_name", shinyvalidate::sv_required("A name, please"))
    observeEvent(input$val_go, iv$enable())
  }

  observeEvent(
    input$cb_set,
    update_el_checkbox(session, "cb1", value = TRUE, label = "Agreed")
  )
  observeEvent(input$bdg_set, update_el_badge(session, "bdg", value = 42))
  observeEvent(input$ac_remote_query, {
    update_el_autocomplete(
      session,
      "ac_remote",
      suggestions = paste0(input$ac_remote_query, c("-x", "-y"))
    )
  })
  observeEvent(
    input$dyn_add,
    update_el_form(
      session,
      "dyn",
      fields = list(
        el_form_field("email", "input", label = "Email"),
        el_form_field("phone", "input", label = "Phone", value = "555"),
        el_form_field("even", "input-number", label = "Even", value = 1)
      )
    )
  )
  observeEvent(
    input$dyn_err,
    update_el_form(session, "dyn", errors = list(email = "Taken"))
  )
  observeEvent(input$dyn_check, el_form_validate(session, "dyn"))
  output$new_dump <- renderPrint({
    cat("cb1 =", format(input$cb1), "\n")
    cat("grp_a =", format(input$grp_a), "\n")
    cat("lnk =", format(input$lnk), "\n")
    cat("dyn_fields =", paste(names(input$dyn), collapse = ","), "\n")
    cat("dyn_phone =", format(input$dyn$phone), "\n")
    cat("dyn_valid =", format(input$dyn_valid), "\n")
  })
  act_fired <- reactiveVal(0)
  observeEvent(input$act_btn, act_fired(act_fired() + 1))
  output$act_dump <- renderPrint({
    cat("act_class =", paste(class(input$act_btn), collapse = "/"), "\n")
    cat("act_fired =", act_fired(), "\n")
    cat("abs_sw =", format(input$abs_sw), "\n")
  })
  observeEvent(
    input$tree_filter,
    call_el(session, "tree", "filter", list("app"))
  )
  observeEvent(input$carousel_forward, call_el(session, "car", "next"))
  observeEvent(
    input$menu_open_btn,
    call_el(session, "nav", "open", list("m-prod"))
  )
  observeEvent(input$tbl_pick, {
    call_el(session, "tbl", "clearSelection")
    call_el(session, "tbl", "toggleRowSelection", list(el_table_row(2), TRUE))
  })
  observeEvent(
    input$upd_go,
    update_el_input(session, "upd_lab", label = "New", error = "Taken")
  )
  observeEvent(input$upd_clear, update_el_input(session, "upd_lab", error = ""))
  # a label given as tags is drawn as HTML, as update*Input() draws it
  observeEvent(
    input$upd_tag,
    update_el_input(session, "upd_lab", label = tags$b(id = "upd-b", "Bold"))
  )
  observeEvent(input$lz_tree_load, {
    q <- input$lz_tree_load
    el_load_children(
      session,
      "lz_tree",
      q,
      if (q$level == 0) {
        list(list(id = "root", label = "Root"))
      } else {
        list(list(id = paste0(q$key, "-child"), label = "Child", leaf = TRUE))
      }
    )
  })
  observeEvent(input$lz_casc_lazy_load, {
    q <- input$lz_casc_lazy_load
    el_load_children(
      session,
      "lz_casc",
      q,
      if (q$level == 0) {
        list(list(value = "asia", label = "Asia"))
      } else {
        list(list(value = "cn", label = "China", leaf = TRUE))
      }
    )
  })
  observeEvent(input$rm_sel_query, {
    update_el_select(
      session,
      "rm_sel",
      choices = paste0(input$rm_sel_query, c("-1", "-2"))
    )
  })
  observeEvent(input$lz_tbl_load, {
    el_load_children(
      session,
      "lz_tbl",
      input$lz_tbl_load,
      data.frame(id = 11, name = "a-child", hasChildren = FALSE)
    )
  })

  observeEvent(input$js_go, {
    shinyjs::hide("js_hide")
    shinyjs::disable("js_off")
    removeUI("#js_gone")
  })

  output$late <- renderUI(el_time_picker("late_tp", value = "09:00:00"))
  observeEvent(
    input$late_set,
    update_el_time_picker(session, "late_tp", value = "10:30:00")
  )
  observeEvent(input$late_call, call_el(session, "late_tp", "focus"))
  output$late_dump <- renderPrint({
    cat(
      "late_tp",
      "=",
      if (is.null(input$late_tp)) "<NULL>" else input$late_tp,
      "\n"
    )
    cat(
      "late_focus",
      "=",
      if (is.null(input$late_tp_focus)) "<NULL>" else "TRUE",
      "\n"
    )
  })
  fmt <- function(x) {
    if (is.null(x)) {
      return("<NULL>")
    }
    paste(format(x), collapse = ",")
  }

  output$dump <- renderPrint({
    invalidateLater(1000, session)
    ids <- c(
      "inp",
      "sel",
      "sw",
      "sld",
      "rate",
      "rg",
      "cg",
      "num",
      "dp",
      "cp",
      "tabs",
      "pg",
      "pg_size",
      "col",
      "rg_num",
      "stp",
      "tbl_selection_rows",
      "otbl_selection_rows",
      "casc",
      "sw_nested",
      "sld_nested",
      "signup_submit",
      "signup_valid",
      "nav",
      "nav_path",
      "tree",
      "tree_checked",
      "car",
      "car_name",
      "col_nested",
      "tab_nested",
      "dlg",
      "drw",
      "dlg_nested"
    )
    for (i in ids) {
      cat(i, "=", fmt(input[[i]]), "\n")
    }
    for (i in c("dp", "dr", "dmonth")) {
      cat(paste0(i, "_class"), "=", class(input[[i]])[1], "\n")
    }
    cat(
      "up_rows",
      "=",
      if (is.null(input$up)) "<NULL>" else nrow(input$up),
      "\n"
    )
    # each name with what its file holds: a POST landing under another
    # file's name shows here
    cat(
      "up_files",
      "=",
      if (is.null(input$up)) {
        "<NULL>"
      } else {
        paste(
          input$up$name,
          vapply(
            input$up$datapath,
            function(p) readLines(p, warn = FALSE)[1],
            ""
          ),
          sep = ":",
          collapse = ","
        )
      },
      "\n"
    )
    cat(
      "up_error",
      "=",
      if (is.null(input$up_error)) "<NULL>" else input$up_error,
      "\n"
    )
    # Upload jobs the session still holds: one a failed file left behind
    # used to stay until the session ended
    ctx <- session$.__enclos_env__$private$fileUploadContext
    cat("up_jobs", "=", ctx$.__enclos_env__$private$operations$size(), "\n")
    # Forwarded Element events are latched by the observers below, which is
    # how an app acts on each one -- repeats included.
    cat("events_seen", "=", paste(names(seen_events), collapse = "/"), "\n")
    for (nm in c("called_keys", "called_validate", "row_index")) {
      if (!is.null(seen_events[[nm]])) {
        cat(nm, "=", fmt(seen_events[[nm]]), "\n")
      }
    }
    cat("raw_row_click", "=", fmt(input$tbl_row_click), "\n")
    shown <- el_table_data(id = "otbl")
    if (!is.null(shown)) {
      cat("otbl_shown", "=", paste(rownames(shown), collapse = ","), "\n")
    }
    cat("ctbl_runs", "=", session$userData$ctbl_runs %||% 0, "\n")
    p <- plan()
    cat("plan", "=", paste(p$id, format(p$date), p$title, collapse = ";"), "\n")
    if (!is.null(input$plan_dates)) {
      cat(
        "plan_dates",
        "=",
        paste(format(input$plan_dates$start), format(input$plan_dates$end)),
        "\n"
      )
    }
    cat("plan_click", "=", input$plan_click$title %||% "", "\n")
    if (!is.null(input$ctbl_selection_change)) {
      cat(
        "ctbl_picked",
        "=",
        paste(rownames(input$ctbl_selection_change), collapse = ","),
        "\n"
      )
    }
    edited <- input$etbl_cell_edit
    if (!is.null(edited)) {
      cat(
        "etbl_edit",
        "=",
        paste(
          edited$row,
          edited$column,
          class(edited$value)[1],
          format(edited$value)
        ),
        "\n"
      )
      cat("etbl_shown", "=", format(el_table_data(id = "etbl")$made[1]), "\n")
    }
    picked <- input$otbl_selection_change
    if (!is.null(picked)) {
      cat(
        "otbl_picked",
        "=",
        paste(class(picked$made), paste(rownames(picked), collapse = ",")),
        "\n"
      )
    }
  })

  otbl_rows <- reactiveVal(4)
  # sent before the table is drawn: applied once it is
  observeEvent(
    TRUE,
    update_el_table(session, "otbl", stripe = TRUE),
    once = TRUE
  )
  observeEvent(input$otbl_more, otbl_rows(3))
  new_car <- function(name) {
    car <- head(mtcars[, 1:3], 1)
    car$made <- as.Date("2021-01-01")
    rownames(car) <- name
    car
  }
  observeEvent(input$otbl_insert, {
    update_el_table(session, "otbl", insert = new_car("New car"), at = 1)
  })
  observeEvent(input$otbl_replace, {
    car <- new_car("Swapped")
    car$mpg <- 99
    update_el_table(session, "otbl", replace = car, at = 1)
  })
  observeEvent(input$otbl_delete, update_el_table(session, "otbl", delete = 1))
  plan <- reactiveVal(data.frame(
    id = 1:3,
    date = as.Date("2026-10-05") + c(0, 2, 9),
    end = as.Date(c(NA, "2026-10-09", NA)),
    title = c("Standup", "Conference", "Review"),
    type = c("primary", "success", "warning")
  ))
  observeEvent(input$plan_add, {
    ev <- input$plan_add
    new <- data.frame(
      id = max(plan()$id) + 1L,
      date = ev$date,
      end = if (is.null(ev$end)) as.Date(NA) else ev$end,
      title = ev$title,
      type = ev$type
    )
    plan(rbind(plan(), new))
    update_el_calendar(session, "plan", insert = new)
  })
  observeEvent(input$plan_update, {
    u <- input$plan_update
    d <- plan()
    i <- which(d$id == u$id)
    for (k in intersect(names(u$changes), names(d))) {
      d[[k]][i] <- if (is.null(u$changes[[k]])) NA else u$changes[[k]]
    }
    plan(d)
    update_el_calendar(session, "plan", replace = d[i, ])
  })
  observeEvent(input$plan_delete, {
    plan(plan()[plan()$id != input$plan_delete$id, ])
    update_el_calendar(session, "plan", delete = input$plan_delete$id)
  })
  ctbl_n <- reactiveVal(3)
  ctbl_runs <- 0
  observeEvent(input$ctbl_four, ctbl_n(4))
  observeEvent(input$ctbl_three, ctbl_n(3))
  output$ctbl <- bindCache(
    render_el_table({
      ctbl_runs <<- ctbl_runs + 1
      session$userData$ctbl_runs <- ctbl_runs
      el_table(data = head(mtcars[, 1:2], ctbl_n()), selection = TRUE)
    }),
    ctbl_n()
  )
  output$etbl <- render_el_table({
    cars <- head(mtcars[, 1:2], 2)
    cars$made <- as.Date("2020-01-01") + 0:1
    el_table(
      data = cars,
      columns = list(
        el_table_column("mpg", "MPG", editable = "number"),
        el_table_column("made", "Made", editable = "date")
      )
    )
  })
  otbl_slow_seen <- NULL
  output$otbl <- render_el_table({
    input$otbl_again
    # a slow render, once per click: the table's mask shows while it runs
    if (!identical(input$otbl_slow, otbl_slow_seen)) {
      otbl_slow_seen <<- input$otbl_slow
      if (isTRUE(otbl_slow_seen > 0)) Sys.sleep(2)
    }
    cars <- head(mtcars[, 1:3], otbl_rows())
    cars$made <- as.Date("2020-01-01") + seq_len(nrow(cars))
    el_table(data = cars, selection = TRUE)
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

  # call_el(): a command, a query, and a promise-returning method
  observeEvent(input$call_clear, {
    call_el(session, "tbl", "clearSelection")
  })
  observeEvent(input$call_keys, {
    call_el(session, "tree", "getCheckedKeys")
  })
  observeEvent(input$call_validate, {
    call_el(session, "signup", "validate")
  })
  observeEvent(input$call_missing, {
    call_el(session, "tbl", "noSuchMethod")
  })
  observeEvent(input$tbl_clear_selection, {
    seen_events$called_clear <- "fired"
  })
  observeEvent(input$tree_get_checked_keys, {
    seen_events$called_keys <- paste(
      input$tree_get_checked_keys,
      collapse = "/"
    )
  })
  observeEvent(input$signup_validate, {
    seen_events$called_validate <- as.character(input$signup_validate)
  })

  n_steps <- 3L
  observeEvent(input$step_next, {
    current <- input$stp
    update_el_steps(
      session,
      "stp",
      active = if (current >= n_steps) 0L else current + 1L
    )
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
    update_el_timeline(
      session,
      "tl",
      items = list(
        list(content = "Created", timestamp = "09:00", type = "primary"),
        list(content = "No stamp"),
        list(content = "Appended", timestamp = "10:00", type = "success")
      )
    )
  })

  observeEvent(input$tree_check, {
    update_el_tree(session, "tree", checked = "t-grain")
  })

  observeEvent(input$nav_pick, {
    update_el_menu(session, "nav", active = "m-all")
  })

  observeEvent(input$form_prefill, {
    update_el_form(session, "signup", model = list(fname = "Ada", fcity = "sh"))
  })

  observeEvent(input$set_values, {
    update_el_input(session, "inp", value = "from server")
    update_el_select(session, "sel", selected = "a")
    update_el_switch(session, "sw", value = FALSE)
    update_el_slider(session, "sld", value = 7)
    update_el_input_number(session, "num", value = 9)
  })

  observeEvent(input$casc_update, {
    update_el_cascader(
      session,
      "casc",
      value = list("js", "nj"),
      placeholder = "updated",
      disabled = TRUE
    )
  })
}

shinyApp(ui, server)
