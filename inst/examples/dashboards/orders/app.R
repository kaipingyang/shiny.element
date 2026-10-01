# An orders admin page: search, a table with row actions, server-side
# sorting and paging, a dialog to add and edit, and confirmation to delete.
#
#   shiny::runApp(system.file("examples/dashboards/orders", package = "shiny.element"))

library(shiny)
library(shiny.element)

set.seed(1)
n <- 57
statuses <- c(Pending = "pending", Paid = "paid", Shipped = "shipped",
              Refunded = "refunded")
cities <- c("Beijing", "Shanghai", "Shenzhen", "Hangzhou")
seed_orders <- data.frame(
  id       = 1000 + seq_len(n),
  date     = format(as.Date("2026-09-30") - sample(0:60, n, TRUE)),
  customer = sample(c("Ada Lovelace", "Grace Hopper", "Alan Turing", "Linus Torvalds",
                      "Ken Thompson", "Barbara Liskov", "Donald Knuth"), n, TRUE),
  city     = sample(cities, n, TRUE),
  amount   = round(runif(n, 20, 900), 2),
  status   = sample(unname(statuses), n, TRUE, prob = c(.2, .4, .3, .1)),
  items    = sample(c("Laptop", "Monitor, cable", "Keyboard, mouse", "Dock"), n, TRUE)
)

# A tag type per status, chosen in the browser for each row
status_tag <- el$tag(
  size = "small",
  ":type" = paste0("({pending: 'warning', paid: 'success', shipped: '', ",
                   "refunded: 'info'})[scope.row.status]"),
  "{{ scope.row.status }}"
)

columns <- list(
  list(type = "expand", cell = tags$div(
    tags$b("Items: "), "{{ scope.row.items }}", tags$br(),
    tags$b("Ships to: "), "{{ scope.row.city }}")),
  list(prop = "id", label = "Order", width = "80"),
  list(prop = "date", label = "Date", width = "115", sortable = "custom"),
  list(prop = "customer", label = "Customer", min_width = "140"),
  list(prop = "amount", label = "Amount", width = "110", align = "right",
       sortable = "custom",
       formatter = htmlwidgets::JS("function(r, c, v) { return '$' + v.toFixed(2); }")),
  list(prop = "status", label = "Status", width = "100", cell = status_tag),
  # Pinned to the right edge, so the buttons stay in view when the table
  # is narrower than its columns and scrolls sideways
  list(label = "", width = "160", fixed = "right", cell = tagList(
    el$button(size = "mini", "@click" = "rowAction('edit', scope)", "Edit"),
    el$button(size = "mini", type = "danger", plain = NA,
              "@click" = "rowAction('delete', scope)", "Delete")))
)

ui <- el_page(
  el_breadcrumb("crumbs", items = list(list(label = "Home"), list(label = "Orders"))),
  tags$div(
    style = "display: flex; flex-wrap: wrap; gap: 10px; margin: 18px 0",
    el_input("q", placeholder = "Customer or order number", clearable = TRUE,
             prefix_icon = "el-icon-search", width = "240px"),
    el_select("status", choices = statuses, multiple = TRUE, collapse_tags = TRUE,
              placeholder = "Any status", clearable = TRUE, width = "200px"),
    el_date_picker("dates", type = "daterange", start_placeholder = "From",
                   end_placeholder = "To", width = "260px"),
    el_button("search", "Search", type = "primary", icon = "el-icon-search"),
    el_button("reset", "Reset"),
    tags$div(style = "flex: 1"),
    el_button("add", "New order", type = "primary", plain = TRUE, icon = "el-icon-plus"),
    el_button("remove_many", "Delete selected", type = "danger", plain = TRUE,
              disabled = TRUE)
  ),
  el_table("orders", selection = TRUE, row_key = "id", columns = columns,
           empty_text = "No orders match"),
  tags$div(style = "margin-top: 16px; text-align: right",
    el_pagination("pager", total = n, page_size = 10, page_sizes = c(10, 20, 50),
                  layout = "total, sizes, prev, pager, next", background = TRUE)),

  el_dialog("editor", title = "Order", width = "560px",
    # The dialog's footer holds the buttons, so the form draws none of its own
    content = el_form(id = "order_form", label_width = "90px", submit_label = NULL,
      el_form_field("customer", "input", label = "Customer",
                    rules = el_rule(required = TRUE, message = "Who is it for?")),
      el_form_field("city", "select", label = "City", choices = cities,
                    rules = el_rule(required = TRUE, message = "Pick a city",
                                    trigger = "change")),
      el_form_field("amount", "input-number", label = "Amount", min = 0,
                    precision = 2, step = 10),
      el_form_field("status", "radio-group", label = "Status", choices = statuses,
                    value = "pending"),
      el_form_field("date", "date-picker", label = "Date",
                    value_format = "yyyy-MM-dd")),
    footer = tagList(el_button("cancel", "Cancel"),
                     el_button("save", "Save", type = "primary")))
)

server <- function(input, output, session) {
  orders  <- reactiveVal(seed_orders)
  query   <- reactiveVal(list())
  sorting <- reactiveVal(list(column = "date", order = "descending"))
  editing <- reactiveVal(NULL)     # the id being edited; NA for a new order

  # ── search ──────────────────────────────────────────────────────────────
  observeEvent(input$search, {
    query(list(q = input$q, status = input$status, dates = input$dates))
  })
  observeEvent(input$reset, {
    update_el_input(session, "q", value = "")
    update_el_select(session, "status", selected = list())
    update_el_date_picker(session, "dates", value = list())
    query(list())
  })

  matching <- reactive({
    d <- orders()
    q <- query()
    if (length(q$q) && nzchar(q$q)) {
      hit <- grepl(q$q, d$customer, ignore.case = TRUE) | grepl(q$q, d$id, fixed = TRUE)
      d <- d[hit, ]
    }
    if (length(q$status)) d <- d[d$status %in% q$status, ]
    if (length(q$dates) == 2) d <- d[d$date >= q$dates[1] & d$date <= q$dates[2], ]
    s <- sorting()
    if (length(s$order) && !is.null(s$column)) {
      d <- d[order(d[[s$column]], decreasing = s$order == "descending"), ]
    }
    d
  })

  # ── sorting and paging, both done here rather than in the browser ───────
  observeEvent(input$orders_sort_change, sorting(input$orders_sort_change))

  page <- reactive({
    d <- matching()
    size <- input$pager_size %||% 10
    first <- ((input$pager_page %||% 1) - 1) * size
    d[seq_len(nrow(d)) > first & seq_len(nrow(d)) <= first + size, ]
  })

  observe({
    update_el_pagination(session, "pager", total = nrow(matching()))
  })
  observe({
    update_el_table(session, "orders", data = page())
  })

  # ── selection ────────────────────────────────────────────────────────────
  observe({
    update_el_button(session, "remove_many",
                     disabled = !length(input$orders_selected_rows))
  })

  # ── add and edit ─────────────────────────────────────────────────────────
  open_editor <- function(row) {
    editing(row$id)
    update_el_form(session, "order_form", model = row[c("customer", "city", "amount",
                                                         "status", "date")])
    update_el_dialog(session, "editor", visible = TRUE)
  }
  observeEvent(input$add, {
    open_editor(list(id = NA, customer = "", city = "", amount = 0,
                     status = "pending", date = format(Sys.Date())))
  })
  observeEvent(input$orders_edit, open_editor(input$orders_edit$row))
  observeEvent(input$cancel, update_el_dialog(session, "editor", visible = FALSE))
  observeEvent(input$save, el_form_validate(session, "order_form"))

  observeEvent(input$order_form_submit, {
    req(isTRUE(input$order_form_valid))
    m <- input$order_form
    d <- orders()
    if (is.na(editing())) {
      row <- data.frame(id = max(d$id) + 1, date = m$date, customer = m$customer,
                        city = m$city, amount = m$amount, status = m$status,
                        items = "")
      orders(rbind(row, d))
      el_message(session, sprintf("Order %d added", row$id), type = "success")
    } else {
      i <- match(editing(), d$id)
      d[i, c("customer", "city", "amount", "status", "date")] <-
        list(m$customer, m$city, m$amount, m$status, m$date)
      orders(d)
      el_message(session, sprintf("Order %d saved", editing()), type = "success")
    }
    update_el_dialog(session, "editor", visible = FALSE)
  })

  # ── delete, one or many, after asking ───────────────────────────────────
  doomed <- reactiveVal(NULL)
  ask_delete <- function(ids) {
    doomed(ids)
    el_message_box(session, "confirm_delete",
                   sprintf("Delete %s? This cannot be undone.",
                           if (length(ids) == 1) paste("order", ids)
                           else paste(length(ids), "orders")),
                   title = "Delete", type = "warning",
                   confirm_button_text = "Delete", cancel_button_text = "Keep")
  }
  observeEvent(input$orders_delete, ask_delete(input$orders_delete$row$id))
  observeEvent(input$remove_many, {
    ask_delete(page()$id[input$orders_selected_rows])
  })
  observeEvent(input$confirm_delete, {
    req(identical(input$confirm_delete, "confirm"))
    orders(orders()[!orders()$id %in% doomed(), ])
    el_message(session, sprintf("Deleted %d order(s)", length(doomed())),
               type = "success")
  })
}

shinyApp(ui, server)
