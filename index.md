# shiny.element

Use [Element UI](https://element.eleme.io/) components in Shiny —
inputs, tables, trees, dialogs, menus — each reporting through
`input$<id>` and updatable from the server, like any other Shiny input.

Element UI ships inside the package, so apps work without a network
connection.

## Installation

``` r

remotes::install_github("kaipingyang/shiny.element")
```

## Quick start

``` r

library(shiny)
library(shiny.element)

ui <- el_page(
  el_input("name", label = "Name", placeholder = "Your name"),
  el_rate("score", value = 3),
  el_button("save", "Save", type = "primary"),
  el_alert("hint", title = "Nothing saved yet", type = "info")
)

server <- function(input, output, session) {
  observeEvent(input$save, {
    update_el_alert(session, "hint",
      title = paste0("Saved ", input$name, " (", input$score, "/5)"),
      type = "success"
    )
  })
}

shinyApp(ui, server)
```

[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
sets up the Vue root and loads the dependencies. Inside an existing
layout — a
[`fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html), or
bslib’s `page_sidebar()` — call
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
once at the top instead:

``` r

ui <- bslib::page_sidebar(
  theme = el_theme(),
  use_element(),
  sidebar = bslib::sidebar(el_select("metric", choices = c("Mean", "Median"))),
  el_table(data = head(iris), id = "summary")
)
```

[`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)
is the page’s look: a bslib theme carrying Element’s own colours, font
and sizes, so Shiny’s
[`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html) or
[`textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html) sit beside
Element components without clashing. It is
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)’s
default. `el_theme(primary = "#7c3aed")` changes the brand colour – on
Element’s components as well as Bootstrap’s; any
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
replaces it, and `theme = NULL` leaves Shiny’s plain Bootstrap.

## Components

|  |  |
|----|----|
| **Form** | [`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md) [`el_input_number()`](https://kaipingyang.github.io/shiny.element/reference/el_input_number.md) [`el_autocomplete()`](https://kaipingyang.github.io/shiny.element/reference/el_autocomplete.md) [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md) [`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md) [`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md) [`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md) [`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md) [`el_rate()`](https://kaipingyang.github.io/shiny.element/reference/el_rate.md) [`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md) [`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md) [`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md) [`el_color_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker.md) [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md) [`el_cascader_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader_panel.md) [`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md) [`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md) [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md) |
| **Data** | [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md) [`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md) [`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md) [`el_progress()`](https://kaipingyang.github.io/shiny.element/reference/el_progress.md) [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md) [`el_badge()`](https://kaipingyang.github.io/shiny.element/reference/el_badge.md) [`el_avatar()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar.md) [`el_image()`](https://kaipingyang.github.io/shiny.element/reference/el_image.md) [`el_descriptions()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions.md) [`el_statistic()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md) [`el_empty()`](https://kaipingyang.github.io/shiny.element/reference/el_empty.md) [`el_result()`](https://kaipingyang.github.io/shiny.element/reference/el_result.md) [`el_skeleton()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton.md) [`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md) [`el_card()`](https://kaipingyang.github.io/shiny.element/reference/el_card.md) [`el_carousel()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel.md) [`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md) [`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md) |
| **Navigation** | [`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md) [`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md) [`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md) [`el_page_header()`](https://kaipingyang.github.io/shiny.element/reference/el_page_header.md) [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md) [`el_steps()`](https://kaipingyang.github.io/shiny.element/reference/el_steps.md) [`el_backtop()`](https://kaipingyang.github.io/shiny.element/reference/el_backtop.md) [`el_infinite_scroll()`](https://kaipingyang.github.io/shiny.element/reference/el_infinite_scroll.md) |
| **Feedback** | [`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md) [`el_loading()`](https://kaipingyang.github.io/shiny.element/reference/el_loading.md) [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md) [`el_message_box()`](https://kaipingyang.github.io/shiny.element/reference/el_message_box.md) [`el_notification()`](https://kaipingyang.github.io/shiny.element/reference/el_notification.md) [`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md) [`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md) [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md) [`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md) [`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md) |
| **Layout and basics** | [`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md) [`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md) [`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md) [`el_header()`](https://kaipingyang.github.io/shiny.element/reference/el_header.md) [`el_aside()`](https://kaipingyang.github.io/shiny.element/reference/el_aside.md) [`el_main()`](https://kaipingyang.github.io/shiny.element/reference/el_main.md) [`el_footer()`](https://kaipingyang.github.io/shiny.element/reference/el_footer.md) [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md) [`el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md) [`el_divider()`](https://kaipingyang.github.io/shiny.element/reference/el_divider.md) [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md) |

The [component
gallery](https://kaipingyang.github.io/shiny.element/articles/components.html)
shows each one rendered, with the code that produced it.

![Buttons](https://kaipingyang.github.io/shiny.element/shots/components-button.png)![Steps](https://kaipingyang.github.io/shiny.element/shots/components-steps.png)![Table](https://kaipingyang.github.io/shiny.element/shots/components-table.png)![Tree](https://kaipingyang.github.io/shiny.element/shots/components-tree.png)

## Reading and writing values

Every component reports through `input$<id>`, and every component has a
matching `update_el_*()`:

``` r

server <- function(input, output, session) {
  # read
  output$chosen <- renderText(input$city)

  # write
  observeEvent(input$reset, {
    update_el_select(session, "city", selected = "beijing")
  })
}
```

Tables take a data frame directly, and
[`el_table_config()`](https://kaipingyang.github.io/shiny.element/reference/el_table_config.md)
derives the column definitions from it:

``` r

cfg <- el_table_config(iris, max_rows = 20)
el_table(data = cfg$data, columns = cfg$columns, id = "iris")
```

## Layout

[`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md)
/
[`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md)
implement Element’s 24-column grid, and
[`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md)
its header/aside/main/footer frame. Both nest freely and accept any
Shiny UI inside, including other Element components.

For whole-page structure, bslib’s `page_sidebar()` and
`layout_columns()` remain the better tool — they handle responsive
breakpoints and theming that Element’s grid does not. Mixing the two is
supported: use bslib for the page, Element for the controls.

## Debugging

`el_page(dev = TRUE)` loads Vue’s development build, which reports
template errors in the browser console instead of failing silently. The
package’s own test suite runs in this mode and asserts that the console
stays clean.

## Learn more

- [Component
  gallery](https://kaipingyang.github.io/shiny.element/articles/components.html)
- [Dashboards](https://kaipingyang.github.io/shiny.element/articles/dashboards.html)
  – whole apps: Element’s own admin layout, a sales overview, an orders
  admin page
- [Function
  reference](https://kaipingyang.github.io/shiny.element/reference/index.html)

## Licence

MIT. The bundled Element UI distribution is MIT-licensed by ElemeFE; see
`LICENSE.note`.
