# shiny.element

Use [Element Plus](https://element-plus.org/), the Vue 3 component
library, in Shiny — inputs, tables, trees, dialogs, menus, every
component it documents — each reporting through `input$<id>` and
updatable from the server, like any other Shiny input.

Element Plus 2.14.7, its icons and Vue 3.5 ship inside the package, so
apps work without a network connection.

## Lifecycle

shiny.element is experimental: until 1.0.0 an argument or a function may
change when a better design turns up, and every such change is listed
under “Breaking changes” in NEWS. From the first CRAN release on,
nothing is removed without first being deprecated, with a warning, for
at least one minor release. Element Plus is followed as upstream
changes: what it deprecates is deprecated here too, and what it removes
goes with the next upgrade.

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
is the page’s look: a bslib theme carrying Element Plus’s own colours,
font and sizes, so Shiny’s
[`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html) or
[`textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html) sit beside
Element Plus components without clashing. It is
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)’s
default. `el_theme(primary = "#7c3aed")` changes the brand colour – on
Element Plus’s components as well as Bootstrap’s – and
`el_theme(element =)` any of its CSS variables; any
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
replaces it, and `theme = NULL` leaves Shiny’s plain Bootstrap.

## Components

The components follow Element Plus’s own documentation, group by group:

|  |  |
|----|----|
| **Basic** | [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md) [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md) [`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md) [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md) [`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md) [`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md) [`el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md) [`el_text()`](https://kaipingyang.github.io/shiny.element/reference/el_text.md) [`el_scrollbar()`](https://kaipingyang.github.io/shiny.element/reference/el_scrollbar.md) [`el_space()`](https://kaipingyang.github.io/shiny.element/reference/el_space.md) [`el_splitter()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter.md) |
| **Configuration** | [`el_config_provider()`](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md) |
| **Form** | [`el_autocomplete()`](https://kaipingyang.github.io/shiny.element/reference/el_autocomplete.md) [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md) [`el_checkbox()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox.md) [`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md) [`el_color_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker.md) [`el_color_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker_panel.md) [`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md) [`el_date_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker_panel.md) [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md) [`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md) [`el_input_number()`](https://kaipingyang.github.io/shiny.element/reference/el_input_number.md) [`el_input_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_input_tag.md) [`el_input_otp()`](https://kaipingyang.github.io/shiny.element/reference/el_input_otp.md) [`el_mention()`](https://kaipingyang.github.io/shiny.element/reference/el_mention.md) [`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md) [`el_rate()`](https://kaipingyang.github.io/shiny.element/reference/el_rate.md) [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md) [`el_select_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_select_v2.md) [`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md) [`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md) [`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md) [`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md) [`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md) [`el_tree_select()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_select.md) [`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md) |
| **Data** | [`el_avatar()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar.md) [`el_badge()`](https://kaipingyang.github.io/shiny.element/reference/el_badge.md) [`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md) [`el_card()`](https://kaipingyang.github.io/shiny.element/reference/el_card.md) [`el_carousel()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel.md) [`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md) [`el_descriptions()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions.md) [`el_empty()`](https://kaipingyang.github.io/shiny.element/reference/el_empty.md) [`el_image()`](https://kaipingyang.github.io/shiny.element/reference/el_image.md) [`el_infinite_scroll()`](https://kaipingyang.github.io/shiny.element/reference/el_infinite_scroll.md) [`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md) [`el_progress()`](https://kaipingyang.github.io/shiny.element/reference/el_progress.md) [`el_result()`](https://kaipingyang.github.io/shiny.element/reference/el_result.md) [`el_skeleton()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton.md) [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md) [`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md) [`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md) [`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md) [`el_tour()`](https://kaipingyang.github.io/shiny.element/reference/el_tour.md) [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md) [`el_tree_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_v2.md) [`el_statistic()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md) [`el_segmented()`](https://kaipingyang.github.io/shiny.element/reference/el_segmented.md) |
| **Navigation** | [`el_affix()`](https://kaipingyang.github.io/shiny.element/reference/el_affix.md) [`el_anchor()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor.md) [`el_backtop()`](https://kaipingyang.github.io/shiny.element/reference/el_backtop.md) [`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md) [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md) [`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md) [`el_page_header()`](https://kaipingyang.github.io/shiny.element/reference/el_page_header.md) [`el_steps()`](https://kaipingyang.github.io/shiny.element/reference/el_steps.md) [`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md) |
| **Feedback** | [`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md) [`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md) [`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md) [`el_loading()`](https://kaipingyang.github.io/shiny.element/reference/el_loading.md) [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md) [`el_message_box()`](https://kaipingyang.github.io/shiny.element/reference/el_message_box.md) [`el_notification()`](https://kaipingyang.github.io/shiny.element/reference/el_notification.md) [`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md) [`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md) [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md) |
| **Others** | [`el_divider()`](https://kaipingyang.github.io/shiny.element/reference/el_divider.md) [`el_watermark()`](https://kaipingyang.github.io/shiny.element/reference/el_watermark.md) |

[Each has a
page](https://kaipingyang.github.io/shiny.element/articles/components.html),
as on element-plus.org: its demos in R and its API tables beside the R
names.

![Buttons](https://kaipingyang.github.io/shiny.element/shots/button-basic.png)![Form](https://kaipingyang.github.io/shiny.element/shots/form-basic-form.png)![Table](https://kaipingyang.github.io/shiny.element/shots/table-fixed-column-and-group-header.png)![Tree](https://kaipingyang.github.io/shiny.element/shots/tree-checking-tree.png)

`el_page(dev = TRUE)` loads Vue’s development build, which reports
template errors in the browser console instead of failing silently. The
package’s own test suite runs in this mode and asserts that the console
stays clean.

## Learn more

- [Installation & Quick
  Start](https://kaipingyang.github.io/shiny.element/articles/shiny.element.html)
- [Components](https://kaipingyang.github.io/shiny.element/articles/components.html)
  – one page per Element Plus component
- Element Plus’s guides from R:
  [i18n](https://kaipingyang.github.io/shiny.element/articles/i18n.html),
  [Theming](https://kaipingyang.github.io/shiny.element/articles/theming.html),
  [Dark
  Mode](https://kaipingyang.github.io/shiny.element/articles/dark-mode.html),
  [Custom
  Defaults](https://kaipingyang.github.io/shiny.element/articles/custom-defaults.html),
  [Built-in
  Transitions](https://kaipingyang.github.io/shiny.element/articles/transitions.html),
  [Migration from Element
  UI](https://kaipingyang.github.io/shiny.element/articles/migration.html)
- [Forms and
  validation](https://kaipingyang.github.io/shiny.element/articles/forms.html),
  [Shiny
  integration](https://kaipingyang.github.io/shiny.element/articles/shiny.html)
- [Dashboards](https://kaipingyang.github.io/shiny.element/articles/dashboards.html)
  – whole apps: an admin layout, a sales overview, an orders admin page
- [Function
  reference](https://kaipingyang.github.io/shiny.element/reference/index.html)

## Licence

MIT. The bundled Element Plus, its icons and Vue are MIT-licensed by
their authors; see `LICENSE.note`.
