# Fixture for test-browser-items.R: every item constructor, in the component
# it belongs to.
library(shiny)

ui <- el_page(
  dev = TRUE,
  el_tabs(
    "tabs",
    tabs = list(
      el_tab_pane("User", "user pane"),
      el_tab_pane("Lazy", tags$span(class = "lazy-body", "late"), lazy = TRUE),
      el_tab_pane("Off", "off", disabled = TRUE)
    )
  ),
  el_collapse(
    "col",
    items = list(
      el_collapse_item("Open", "open body"),
      el_collapse_item("Locked", "locked body", disabled = TRUE)
    )
  ),
  el_timeline(
    "tl",
    items = list(
      el_timeline_item("with", timestamp = "2018-04-15"),
      el_timeline_item(
        "hidden",
        timestamp = "2018-04-13",
        hide_timestamp = TRUE
      )
    )
  ),
  el_descriptions(
    "desc",
    border = TRUE,
    items = list(
      el_descriptions_item("Name", "Ada"),
      el_descriptions_item("Address", "Somewhere", span = 2)
    )
  ),
  el_steps(
    "steps",
    active = 1,
    steps = list(
      el_step("One"),
      el_step("Two"),
      el_step("Three", status = "error")
    )
  ),
  el_breadcrumb(
    "bc",
    items = list(
      el_breadcrumb_item("Home", to = "/"),
      el_breadcrumb_item("Here")
    )
  ),
  el_menu(
    "menu",
    mode = "horizontal",
    items = list(
      el_menu_item("One", "1"),
      el_sub_menu(
        "Two",
        "2",
        el_menu_item("Two-one", "2-1"),
        el_menu_item_group("Group", el_menu_item("Two-two", "2-2"))
      ),
      el_menu_item("Off", "3", disabled = TRUE)
    )
  ),
  el_select(
    "sel",
    choices = list(
      el_option_group(
        "Popular",
        el_option("Shanghai"),
        el_option("Beijing", disabled = TRUE)
      ),
      el_option_group("Other", el_option("Chengdu", value = "cd"))
    )
  ),
  el_anchor(
    "an",
    links = list(
      el_anchor_link("Top", "#top", el_anchor_link("Inner", "#inner"))
    )
  ),
  el_table(
    "tbl",
    data = data.frame(date = "2016-05-03", name = "Tom", city = "LA"),
    columns = list(
      el_table_column("date", "Date", width = 150, sortable = TRUE),
      el_table_column(
        label = "Info",
        el_table_column("name", "Name"),
        el_table_column(label = "Place", el_table_column("city", "City"))
      )
    )
  ),
  el_table_v2(
    "tv",
    data = data.frame(id = 1:3, name = c("a", "b", "c")),
    table_v2_width = 400,
    height = 200,
    columns = list(
      el_table_v2_column("id", "Id", width = 80),
      el_table_v2_column("name", "Name", width = 200)
    )
  ),
  el_skeleton(
    "sk",
    slots = list(
      template = el_skeleton_item("image", style = "width: 80px; height: 80px")
    )
  ),
  el_button("more", "more tabs")
)

server <- function(input, output, session) {
  observeEvent(input$more, {
    insert_el_tab(session, "tabs", el_tab_pane("New", "new pane"))
  })
}

shinyApp(ui, server)
