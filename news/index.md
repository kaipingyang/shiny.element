# Changelog

## shiny.element 0.1.0

First release.

### Element Plus

Built on Element Plus 2.14.7 and Vue 3.5, bundled; the development
versions built on Element UI 2.15.14 and Vue 2.7 are tagged
`v0.1.0-vue2`. The “Migration from Element UI” article lists what
changed for code written for them. In short:

- Each component is its own Vue application, made with
  `Vue.createApp()`: one that fails to mount leaves the rest of the page
  working, and a component Shiny removes is unmounted.
- Every component Element Plus documents is wrapped – 1435 of its
  attributes, 222 events, 151 methods and 233 slots, all of them, each
  attribute bound to Element Plus’s own prop and each method run in a
  browser test – with the components new in Element Plus:
  [`el_input_otp()`](https://kaipingyang.github.io/shiny.element/reference/el_input_otp.md),
  [`el_input_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_input_tag.md),
  [`el_segmented()`](https://kaipingyang.github.io/shiny.element/reference/el_segmented.md),
  [`el_select_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_select_v2.md),
  [`el_mention()`](https://kaipingyang.github.io/shiny.element/reference/el_mention.md),
  [`el_tree_select()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_select.md),
  [`el_tree_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_v2.md),
  [`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md),
  [`el_color_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker_panel.md),
  [`el_date_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker_panel.md),
  [`el_check_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_check_tag.md),
  [`el_anchor()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor.md),
  [`el_tour()`](https://kaipingyang.github.io/shiny.element/reference/el_tour.md),
  [`el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/el_image_viewer.md),
  [`el_countdown()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md),
  [`el_affix()`](https://kaipingyang.github.io/shiny.element/reference/el_affix.md),
  [`el_space()`](https://kaipingyang.github.io/shiny.element/reference/el_space.md),
  [`el_scrollbar()`](https://kaipingyang.github.io/shiny.element/reference/el_scrollbar.md),
  [`el_watermark()`](https://kaipingyang.github.io/shiny.element/reference/el_watermark.md),
  [`el_text()`](https://kaipingyang.github.io/shiny.element/reference/el_text.md),
  [`el_avatar_group()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar_group.md),
  [`el_splitter()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter.md),
  [`el_config_provider()`](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md).
- Icons are Element Plus’s SVG components, by name (`"Search"`); Element
  UI’s class names (`"el-icon-search"`) are read as the same icon.
- Sizes are `"large"`, `"default"` and `"small"`; date formats are
  day.js’s (`"YYYY-MM-DD"`), with Element UI’s tokens converted.
- Themes are CSS variables set on the page: nothing compiled, no sass.
- The default language is English, with Element Plus’s 67 locales
  bundled.
- The website follows element-plus.org: its overview, its component
  groups and pages, each demo in R, its API tables beside the R names,
  and its guides – design, installation, i18n, theming, dark mode,
  custom defaults, transitions – from R.

### What Element Plus writes in JavaScript, from R

- [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  code is evaluated in the browser wherever Element Plus takes a value:
  a VNode built with `Vue.h()` as a message box’s or notification’s
  message, a space’s spacer, a table-v2 column’s `cellRenderer`.
- `el_table_v2(methods =)` gives its slot templates functions of your
  own, so upstream’s row and header renderers port across;
  `auto_resize = TRUE` is Element Plus’s `el-auto-resizer`;
  [`update_el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md)
  replaces its rows and columns from the server.
- `$setInput(name, value)` in any template is Shiny’s `setInputValue()`.
- `virtual_ref` (tooltip, popover, dropdown) is a CSS selector, looked
  up in the browser, including for a target the server draws later; one
  matching several elements gives them a single popup that follows the
  pointer.
- [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md)’s
  `trigger` is Element Plus’s own – how it opens – and the element it
  describes is `reference`, as for
  [`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md).
  `el_popconfirm(popconfirm_width =)` sizes the prompt. Popover and
  popconfirm take the tooltip’s other attributes through `...`.
- `el_load_children(reject = TRUE)` fails a lazy load, so the node can
  be loaded again;
  [`el_tree_select()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_select.md)
  loads lazily from the server as
  [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)
  does. `el_tree(class_field =)`, `el_tree_v2(props =)`,
  `el_select(props =)`, `el_select_v2(props =)`, `el_segmented(props =)`
  and `tag_tooltip` are new.
  [`el_tree_node()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)
  names a tree’s node for
  [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md).
- `el_page(dev = TRUE)` loads Vue’s development build, which is bundled:
  until now it loaded the production build either way, so Vue’s warnings
  never reached the console the tests read.

### A Vue layer, usable on its own

The bridge every component is built on is exported, and knows nothing of
Element: write a Vue 3 component in R with Vue’s own options and use it
as a Shiny input.

- [`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md)
  – a component: `template`, `data`, `methods`, `computed`, `watch`,
  `emits`, `setup`, `components` and the lifecycle hooks under Vue’s
  names (multi-word ones also in snake_case), plus `id`, `input` (the
  field that is `input$<id>`; several for one value) and `use` (Vue’s
  `app.use()`, any plugin with its options). `$emit()` of an event in
  `emits` arrives as `input$<id>_<event>`, several arguments as a list.
- [`render_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/render_vue_data.md)
  – an output that sends a value, not markup, after shinyreact’s
  `reactive_output()`: a component’s field follows it
  (`vue_app(outputs = c(stats = "stats"))`, `vue_store(outputs =)`). It
  waits while its component is hidden, as outputs do, and
  `$recalculating.<id>` tells the template while it runs.
- [`vue_component()`](https://kaipingyang.github.io/shiny.element/reference/vue_component.md)
  – a child component for `components =`, under its name as written or
  in kebab-case (`todo_item` is `<todo-item>`); the dependencies its
  template carries come with it.
- [`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md)
  – state shared by components, `$store.<id>` in every template,
  reported to and set from the server on request.
- [`vue_output()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)
  /
  [`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)
  – like [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) /
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), but a
  render that changes only a component’s data updates it in place,
  keeping the user’s sort, ticks and open tabs. A component given
  another id is another component, and renders afresh.
- [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
  [`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md),
  [`vue_answer()`](https://kaipingyang.github.io/shiny.element/reference/vue_answer.md)
  – set fields (`value` for the input), run methods, answer a component
  that asked the server; they reach `setup()` state too, and bookmarks
  restore it.
- Element is now one plugin among others: a component gets Element Plus
  through `use`, so a Vue component of your own on the same page does
  not.
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)’s
  `report` is now `input` (with `emits` for the rest); `el_call()` is
  [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md);
  `update_vue_data()` is
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md).
  `options(shiny.vue.dev = TRUE)` loads Vue’s development build, as
  `shiny.element.dev` does.

### Breaking changes

Before this first release the API is still allowed to move; from the
first CRAN release on, a change like these goes through a deprecation
first.

- `el_call()` is
  [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md),
  `update_vue_data()` is
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
  and `el_widget(report =)` is `input =`.
- [`insert_el_tab()`](https://kaipingyang.github.io/shiny.element/reference/insert_el_tab.md)’s
  `name` is `tab`, which also takes an
  [`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md).
- `el_table_config()` is gone:
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
  takes a data.frame as it is, and
  [`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md)
  writes the columns.
- Update functions take `NULL` as “leave it”, as Shiny’s do; `NA`
  returns a prop to Element’s default.
- A table in an app is an output:
  [`el_table_output()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md)
  and
  [`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md).
  `input$<id>_selection_rows` is the selected row numbers, and
  `input$<id>_selection_change` the selected rows,
  `data[rows, , drop = FALSE]` of the data shown; `input$<id>_selected`
  and `input$<id>_selected_rows` are gone. A table reports five of
  Element’s events unasked – `selection-change`, `current-change`,
  `sort-change`, `filter-change`, `expand-change` – and the others when
  asked, with `el_table(events =)` or
  [`el_on()`](https://kaipingyang.github.io/shiny.element/reference/el_on.md).

### Items as functions

The parts Element Plus writes as child tags have constructors, as bslib
has
[`nav_panel()`](https://rstudio.github.io/bslib/reference/nav-items.html)
and
[`accordion_panel()`](https://rstudio.github.io/bslib/reference/accordion.html):
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md),
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_sub_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_menu_item_group()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md),
[`el_option_group()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md)
and
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton_item.md).
Each takes the child’s own attributes as arguments – documented,
completed by the editor, checked – and returns the item its parent’s
argument takes, so `el_tabs(tabs = list(el_tab_pane("One", ...)))` and
the plain list it replaces draw the same, and update functions take
items too. A timeline entry’s `hide_timestamp` is new.
[`insert_el_tab()`](https://kaipingyang.github.io/shiny.element/reference/insert_el_tab.md)
takes an
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
as bslib’s
[`nav_insert()`](https://rstudio.github.io/bslib/reference/nav_select.html)
takes a
[`nav_panel()`](https://rstudio.github.io/bslib/reference/nav-items.html);
its `name` argument is now `tab`.

### Behaviour closer to Element Plus

- A dialog or drawer keeps focus inside while open, as Element Plus’s
  focus trap does – the topmost one, when one is opened over another –
  and one closed straight after opening no longer reports `opened`.
- Tabs pass over disabled tabs with the arrow keys, a disabled tab
  cannot be closed, and Enter on the “+” adds one.
- An upload’s file field no longer appears as an extra
  `input$<id>_elfile`.
- An update giving one value for a field that holds several – a multiple
  select’s selection, a checkbox group’s, a table-v2’s expanded rows –
  sends it as a list of one, not a bare value.
- Releasing an interrupted upload warns, once, if Shiny’s internals it
  relies on have moved.
- [`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md)
  draws Element Plus’s own day cell; it used to fill it with a template
  of its own and colour every `.is-selected` on the page.

### Documentation, after Element’s own

The website follows Element’s documentation: a page per component, in
Element Plus’s groups and order (Basic, Configuration, Form, Data,
Navigation, Feedback, Others), each with Element’s demos written in R –
live where they need no server, a screenshot of the running app where
they do – and Element’s API tables with where each attribute, event,
method and slot is in R. The guides cover what Element’s documentation
does not: forms and validation, Shiny integration (events, methods,
modules, bookmarking, data from the server, components of your own),
theming and languages, and what differs from Element in a browser.

### Components

Every component Element Plus 2.14.7 documents is wrapped, services
included, with every documented attribute, event and slot reachable from
R and every method callable by name – measured by `tools/api-coverage`,
not counted by hand. Tabs, collapse, dialog and drawer are reimplemented
as markup so the components inside them stay connected; the “What works”
article lists where they differ from Element’s own.

- **Input** —
  [`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md),
  [`el_input_number()`](https://kaipingyang.github.io/shiny.element/reference/el_input_number.md),
  [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md),
  [`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md),
  [`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md),
  [`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md),
  [`el_slider()`](https://kaipingyang.github.io/shiny.element/reference/el_slider.md),
  [`el_rate()`](https://kaipingyang.github.io/shiny.element/reference/el_rate.md),
  [`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md),
  [`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md),
  [`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md),
  [`el_color_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker.md),
  [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md),
  [`el_cascader_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader_panel.md),
  [`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md),
  [`el_autocomplete()`](https://kaipingyang.github.io/shiny.element/reference/el_autocomplete.md),
  [`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md).
- **Display** —
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md),
  [`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md),
  [`el_progress()`](https://kaipingyang.github.io/shiny.element/reference/el_progress.md),
  [`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md),
  [`el_badge()`](https://kaipingyang.github.io/shiny.element/reference/el_badge.md),
  [`el_card()`](https://kaipingyang.github.io/shiny.element/reference/el_card.md),
  [`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md),
  [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md),
  [`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md),
  [`el_carousel()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel.md),
  [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md),
  [`el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md),
  [`el_divider()`](https://kaipingyang.github.io/shiny.element/reference/el_divider.md),
  [`el_avatar()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar.md),
  [`el_image()`](https://kaipingyang.github.io/shiny.element/reference/el_image.md),
  [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md),
  [`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md),
  [`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md).
- **Navigation** —
  [`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md),
  [`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md),
  [`el_steps()`](https://kaipingyang.github.io/shiny.element/reference/el_steps.md),
  [`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md),
  [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md),
  [`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md),
  [`el_page_header()`](https://kaipingyang.github.io/shiny.element/reference/el_page_header.md),
  [`el_backtop()`](https://kaipingyang.github.io/shiny.element/reference/el_backtop.md),
  [`el_infinite_scroll()`](https://kaipingyang.github.io/shiny.element/reference/el_infinite_scroll.md).
- **Containers** —
  [`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md),
  [`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md),
  [`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md),
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md),
  [`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md),
  [`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md),
  [`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md),
  [`el_header()`](https://kaipingyang.github.io/shiny.element/reference/el_header.md),
  [`el_aside()`](https://kaipingyang.github.io/shiny.element/reference/el_aside.md),
  [`el_main()`](https://kaipingyang.github.io/shiny.element/reference/el_main.md),
  [`el_footer()`](https://kaipingyang.github.io/shiny.element/reference/el_footer.md).
- **Feedback** —
  [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md),
  [`el_notification()`](https://kaipingyang.github.io/shiny.element/reference/el_notification.md),
  [`el_message_box()`](https://kaipingyang.github.io/shiny.element/reference/el_message_box.md),
  [`el_loading()`](https://kaipingyang.github.io/shiny.element/reference/el_loading.md),
  [`el_loading_close()`](https://kaipingyang.github.io/shiny.element/reference/el_loading_close.md).
- **Helpers** —
  [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md),
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md),
  [`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md),
  [`df_to_tree_data()`](https://kaipingyang.github.io/shiny.element/reference/df_to_tree_data.md),
  [`df_to_cascader_options()`](https://kaipingyang.github.io/shiny.element/reference/df_to_cascader_options.md),
  [`el_form_validate()`](https://kaipingyang.github.io/shiny.element/reference/el_form_validate.md).

Most components have a matching `update_el_*()` for server-side updates,
and report their value through `input$<id>` like any other Shiny input.
As with Shiny’s own `update*Input()`, a value set from the server is
reported back through `input$<id>` too.

[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
themes the page around the components with
[`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md),
a bslib theme carrying Element’s colours, font and control sizes, so
Shiny’s own inputs and outputs match the Element ones beside them.
`theme = NULL` leaves Shiny’s plain Bootstrap. Bootstrap’s dark mode –
bslib’s
[`input_dark_mode()`](https://rstudio.github.io/bslib/reference/input_dark_mode.html)
– turns Element Plus’s with it, and bslib’s
[`tooltip()`](https://rstudio.github.io/bslib/reference/tooltip.html)
and
[`popover()`](https://rstudio.github.io/bslib/reference/popover.html)
take a component as their trigger.

Events that fire on every frame – a scroll, a slider or splitter drag, a
tree node dragged over, a colour picked in the panel – reach the server
at most every 200 ms, the last one always, so it hears where the scroll
or the drag ended.

Tabs can be added and removed from the server
([`insert_el_tab()`](https://kaipingyang.github.io/shiny.element/reference/insert_el_tab.md),
[`remove_el_tab()`](https://kaipingyang.github.io/shiny.element/reference/insert_el_tab.md))
or by the user (`editable = TRUE`), and a lazy pane binds its content
when first shown. Messages and notifications given an `id` can be closed
by it
([`el_message_close()`](https://kaipingyang.github.io/shiny.element/reference/el_feedback_close.md),
[`el_notification_close()`](https://kaipingyang.github.io/shiny.element/reference/el_feedback_close.md)).

### Tables

A table is an output in an app, as DT’s and reactable’s are:
`el_table_output("tbl")` in the UI,
`output$tbl <- render_el_table(el_table(data = ...))` in the server.
Rendered again, it is patched in place: the same rows keep the user’s
ticks, sort and open rows. Its inputs are named after the output:

- `input$tbl_selection_rows`, the selected row numbers, integers – after
  Element’s `getSelectionRows()`. It goes into bookmarks, and a
  bookmarked selection is ticked again. `input$tbl` itself is left free:
  Element’s table has no value of its own.
- `input$tbl_selection_change`, the selected rows as R subsets them,
  `data[rows, , drop = FALSE]`: factors, Dates and row names kept, the
  input handler subsetting the data the server keeps.
- `input$tbl_current_change`, `_sort_change`, `_filter_change` and
  `_expand_change`, always; Element’s other events – `row-dblclick`,
  `cell-click` and the rest – when asked, with `el_table(events =)` or
  piped, `el_table(...) |> el_on("row-dblclick")`, under Element’s name
  in snake_case or an input of one’s own
  (`el_on("cell-click", input = "picked")`).

`el_table_column(editable =)` edits a column’s cells in place, in
Element’s input, input-number, select or date picker: a double click
opens the editor, Enter or leaving it commits, Escape abandons, Tab
moves to the next editable cell. The edit is shown at once, applied to
the server’s copy of the data, and reported as `input$<id>_cell_edit`,
`list(row, column, value, old)` with the column’s type. Nothing Excel
does beyond that – ranges, copy and paste, fill, undo – is attempted.

A table output sends its markup once: rendered again with the same
columns and options, it sends only the data that changed, as JSON. While
Shiny recalculates it, Element’s loading mask covers it in place of
Shiny’s fading (`el_table_output(loading = FALSE)` for the fading).

`update_el_table(insert =, replace =, delete =)` changes a few rows and
sends only those; the server’s copy of the data changes as R would
change it, and
[`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md)
reads it, reactively. Rows not touched keep their ticks and open state.

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
returns the table’s specification, drawn when placed, as an htmlwidget
is; without Shiny – R Markdown, Quarto, the site – it is placed as it
is, with no id.

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
columns may carry a `cell` template, drawn once per row with `scope.row`
in reach – a status tag, a progress bar, a column of buttons – and a
`type` of `"index"` or `"expand"`. A button in a cell reports with
`rowAction('edit', scope)`, setting `input$<id>_edit` to the row’s
number and the row. `loading` shows Element’s loading mask, from the
server too.

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
draws no column borders by default, as Element does; pass
`border = TRUE` for them.

`update_el_table(data =)` keeps the columns the table was created with.
It used to re-infer them from the new data, discarding every label,
formatter and template.

A column’s `header` is a template, as its `cell` is: a search box, a
button, any component in the header cell. Group headers nest as deep as
the columns given (they stopped at two levels below the top).

Every `update_el_*()` takes each argument of its component that can
change once it is drawn, under the same name –
`update_el_table(stripe =, table_layout =)`,
`update_el_select(multiple =, filterable =)`,
`update_el_input(maxlength =)`, about 900 in all – each documented on
its help page, inherited from the component’s. `NULL` leaves one as it
is, as in Shiny’s updaters; `NA` returns it to Element’s default. A test
keeps every argument held in a component’s data reachable this way. The
containers drawn as markup (tabs, collapse, dialog, drawer) and the
wrappers (tooltip, popover) keep their own updaters. Each update
function is documented on its component’s page, as bslib documents
[`update_switch()`](https://rstudio.github.io/bslib/reference/input_switch.html)
with
[`input_switch()`](https://rstudio.github.io/bslib/reference/input_switch.html):
one argument, one description.
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md)
reaches a table-v2 with `auto_resize = TRUE`; it used to reach the
resizer around it.

A data.frame inside the data – a row’s own rows, a cell of a list column
– is rows too, and a list column’s cell is its value rather than a list
of one.

The table, table-v2 and calendar pages show Element Plus’s demos with
Element Plus’s data; where a demo changes the component as it runs, the
R version is an app whose server does it.

### Dashboards

A new article builds whole apps: Element’s own admin-layout example
rebuilt in R, a sales overview, and an orders admin page with search,
row actions, server-side sorting and paging, an editing dialog and
confirmed deletes. Each is also in the installed package, under
`examples/dashboards/`.

### Shiny modules

UI functions no longer namespace their `id` from the reactive domain
they are built in; inside a module, wrap the id in `ns()` as for any
Shiny input. Built by
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) in a
module’s server, a component used to be namespaced twice – `ns("x")`
became `"mod-mod-x"` – and never reported. Their `session` argument is
deprecated; a session passed to it still namespaces the id, with a
warning. `update_el_*()` and the other server functions are unchanged:
they namespace the bare id, as `update*Input()` does.

### Without Shiny

Components work on a page with no Shiny behind it – R Markdown, Quarto,
a saved HTML file: they render and respond to the user, with nowhere to
report to. Every call into Shiny is guarded, the tabs, collapse, dialog
and drawer bind themselves when Shiny is absent, and the scripts bring
their own jQuery. The website’s examples are live components built this
way, with a screenshot only where an example needs a server.

### Components rendered by `renderUI()`

A component whose type first appears through
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) or
[`insertUI()`](https://rdrr.io/pkg/shiny/man/insertUI.html) now hears
`update_el_*()` and
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md).
Their handlers registered only on `shiny:connected`, which had already
fired by the time such a component’s script arrived, so every update to
it went nowhere without a word.

### Raw Element tags

`el$` tags are documented for what they are: markup for inside a
component –
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md),
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md),
slots, table cells, a wrapper’s trigger. At the top level of a page
nothing compiles them; the browser console now says so instead of
leaving bare text.

### Every component is a Shiny input

Each component is a host element carrying its id, with Element’s markup
inside and a Shiny input binding on it – the way reactR binds React
components – so the rest of Shiny reaches it as it reaches
[`textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html):
[`shinyjs::hide()`](https://rdrr.io/pkg/shinyjs/man/visibilityFuncs.html),
[`show()`](https://rdrr.io/r/methods/show.html), `toggle()`,
`disable()`, `enable()` and `reset()`,
[`removeUI()`](https://rdrr.io/pkg/shiny/man/insertUI.html) (which
destroys its Vue instance too), bookmarking, shinyvalidate, a test
driver’s `set_inputs()`, and bslib’s containers – a sidebar, a card, a
closed accordion, a nav panel not yet shown. Vue 3, the version Element
Plus runs on, is bundled beside Element Plus, and
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
marks JavaScript the way
[`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html) does,
without depending on htmlwidgets. (Development versions built on vueR’s
htmlwidgets, where the id sat on a hidden element beside the component
and Shiny did not know it was an input.)

[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
builds the same shape for components of your own, and its new `report`
argument names the value – an input made of `el$` tags, as the Shiny
integration article shows, needs no JavaScript.

### Shiny conventions

- **Bookmarking.** Every component’s value goes through
  [`shiny::restoreInput()`](https://rdrr.io/pkg/shiny/man/restoreInput.html),
  so a bookmarked page reopens as it was left – inputs, the selected
  tab, open panels, an open dialog, the pager’s page.
- **Dates.**
  [`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md)
  reports `Date` for `"date"`, `"dates"` and `"daterange"` with the
  default `value_format`, as
  [`dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html) does. A
  `value_format` of your own still reports text in that format.
- **The session argument.** Every server function – `update_el_*()`,
  [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md),
  [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md)
  and the rest – takes the current session by default, as
  [`updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html)
  does. Given an id in the session’s place,
  `update_el_input("name", ...)`, it says so and names the call to write
  instead, as Shiny’s own do.
- **Action buttons.**
  [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)
  and
  [`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md)
  report their clicks as
  [`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  does: 0 on load, classed so that
  [`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)
  and [`req()`](https://rdrr.io/pkg/shiny/man/req.html) treat 0 as not
  yet clicked.
  [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md)
  reports each command as an event, so choosing the same item twice runs
  an observer twice.
- **One input per id.**
  [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md)
  reports to `input$<id>`, as every other input does, rather than
  `input$<id>_value`, and
  [`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md)
  reports its page as `input$<id>` rather than `input$<id>_page`.
- **The server loads.** Where Element takes a JavaScript function to
  fetch data, the server can answer instead: a lazy
  [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md),
  [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md),
  [`el_cascader_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader_panel.md)
  or tree
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
  asks through `input$<id>_load` (`_lazy_load` for a cascader) and
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md)
  replies; a `remote`
  [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
  sends what is typed as `input$<id>_query`, and
  [`update_el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
  with the matches answers it.
- **Labels and errors from the server.** The `update_el_*()` of every
  input takes `label`, as
  [`updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html)
  does, and `error`, Element’s message for a check only the server can
  make; `""` clears it.
- **Validation.** shinyvalidate’s messages show on a component as
  Element shows a failed form rule: framed in red, the message
  underneath – for a labelled component, under the control, replacing
  any `error` it opened with.
- **Labels.** Every input takes `label`, shown above it or, with
  `label_position = "left"` or `"right"`, beside it – also its
  accessible name. The props of Element’s `el-form-item` that suit a
  single input come with it: `label_width`, `label_suffix`, `required`
  (the red asterisk), `error`, `show_message` and `inline_message`; the
  component’s own `size` sizes the label.
  [`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)’s
  trigger text is now `button_label`, as
  [`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)’s
  `buttonLabel`.
- **Element themed from the page’s theme.** The `primary`, `success`,
  `warning`, `danger` and `info` of
  [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)’s
  theme reach Element’s components too, with the tints and shades
  Element derives from each, and `el_theme(element =)` sets any of
  Element’s own theme variables – `list("border-radius-base" = "8px")`.
  They are set as Element Plus’s CSS variables, as its theming guide
  sets them. `use_element(theme =)` does the same elsewhere; its layout
  CSS argument is now `layout_css`.
- **A tree filters as it stands.**
  [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)
  has a default `filter_node_method` – the label contains the text,
  ignoring case – so `call_el(session, "tree", "filter", list(text))`
  needs no JavaScript; Element itself throws without one.
- **More of upstream.**
  [`el_checkbox()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox.md),
  one box as
  [`checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html)
  is, with `indeterminate` for a “check all” box;
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md),
  buttons joined into one bar, each still reporting; an `id` on
  [`el_badge()`](https://kaipingyang.github.io/shiny.element/reference/el_badge.md)
  or
  [`el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md)
  makes it something the server changes
  ([`update_el_badge()`](https://kaipingyang.github.io/shiny.element/reference/el_badge.md),
  [`update_el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md)),
  the link an action link; `el_select(option_template =)`, Element’s
  custom option template; `el_autocomplete(remote = TRUE)`, suggestions
  from the server through `input$<id>_query`. In forms,
  [`el_rule()`](https://kaipingyang.github.io/shiny.element/reference/el_rule.md)
  takes Element’s custom `validator` and the rest of async-validator
  (`enum`, `whitespace`, `transform`),
  [`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)
  every control Element’s form holds – `"checkbox"`, `"time-select"`,
  `"autocomplete"`, `"transfer"`, `"cascader-panel"` added – and
  [`update_el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  replaces the field list (`fields =`) or shows the server’s own errors
  (`errors =`). An update can carry
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions.
- **Closer to Element’s own behaviour.** Dialogs and drawers stack, lock
  scroll and close on Escape through Element’s popup manager, so they
  share one z-index counter with every Element popup and honour
  `el_page(z_index =)`; `opened` and `closed` follow the transitions,
  and a drawer gives focus back. Tabs take the arrow keys and Delete and
  scroll when they overflow; collapse headers take Enter and Space and
  animate; both carry Element’s ARIA.
- **Uploads that fail or are aborted.** Files go up one at a time, as
  [`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) sends
  them; a file that fails, or is stopped with `abort()`, is left out and
  the rest of its batch still arrives. The upload job it interrupted is
  let go of at once, with its temporary directory, rather than kept
  until the session ends.
  [`el_upload_file()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)
  and
  [`el_table_row()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)
  name a file or a row for a method that needs it.
- **Server questions are cleaned up.** A lazy load the server never
  answers settles after 30 seconds, and at once when its component is
  removed or the session ends. A remote select or autocomplete search
  with no answer stops loading after the same 30 seconds; an
  autocomplete typed into faster than the server answers shows the
  answer to the last query, not an earlier one.
- **Tags where a string was expected.** Tags in a component’s data – a
  timeline entry’s `content`, a column’s `header_html`, a form item’s
  `label_html` – are sent as the HTML they stand for, not as a
  serialised object; `update_el_*(label =)` takes tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  and draws them as markup, as `update*Input()` does. Items, steps and
  tabs that are not a list of lists, a `gutter` that is not a number,
  and a `theme_css` that is not a dependency are refused with a message
  saying what was expected.
  [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md)
  loses its `icon` argument, which did nothing: Element’s cascader has
  no icon.
- **Found while writing the component pages.**
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
  columns nest under group headers (`children`);
  [`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)
  has `"textarea"` and `"password"`, and its form-item props
  (`required`, `error`, `label_width`, …) now reach the form item rather
  than the control; a wrapper – a popover’s `body`, a badge – takes
  several components and text side by side;
  [`update_el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md),
  [`update_el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md),
  [`update_el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md)
  and
  [`update_el_infinite_scroll()`](https://kaipingyang.github.io/shiny.element/reference/el_infinite_scroll.md)
  sent field names the component did not have and changed nothing –
  every updater is now checked against its component.
- **Element’s global config.**
  [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
  and
  [`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
  take `size` and `z_index`, as `Vue.use(Element, {size, zIndex})` does;
  a labelled input’s label follows the size too. Element’s `display.css`
  – the `hidden-xs-only` family – is loaded with the rest, and `el`
  gains the registered components it lacked (`button_group`,
  `checkbox_button`, `scrollbar`, `spinner`, `collapse_transition`) and
  loses `anchor`, `anchor_link` and `loading`, which Element 2 does not
  have as tags.
- **Checked arguments.** An enumerated argument Element does not accept
  – `type = "primry"` – is an error listing the values it does, rather
  than a component drawn in its default style.
- **Templates.** Each component’s template travels as a script the
  browser does not parse: nothing flashes before Vue runs, and camelCase
  attribute names reach Vue unchanged.

### Note for users of the development version

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
now takes `id` first, like every other component:

``` r

el_table("my_table", data = df)     # new
el_table(data = df, id = "my_table")  # also fine, and always was
```

Positional calls written against the old `el_table(data, columns, id)`
order still work – the arguments are shifted back with a warning – but
naming them is the way to keep it quiet.

`input$<cascader id>_value` is now `input$<cascader id>`, and
`input$<pager id>_page` is `input$<pager id>`. `update_vue_component()`
and `vue_handler_dependency()` are gone: `update_vue_data()` does the
first’s job, and the bridge loads with every component.
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)’s
first argument is now the page’s theme; its layout CSS is `layout_css`.

### Filling a slot

Every component takes `slots`, a named list, one entry per Element slot:

``` r

el_alert("a", slots = list(title = tags$b("Something went wrong")))

# A component works as slot content too, and keeps reporting its inputs
el_alert("a", slots = list(title = el_tag("sev", "critical", type = "danger")))
```

A scoped slot, where Element hands the template its own data, is written
with
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md):

``` r

el_calendar("cal", slots = list(
  dateCell = template(
    htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
    slot = "dateCell", scope = "{date, data}"
  )
))
```

### Reaching a component’s methods

Element documents methods as well as props.
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md)
invokes one:

``` r

observeEvent(input$clear, {
  call_el(session, "tbl", "clearSelection")
})

# A method with a return value answers asynchronously
observeEvent(input$ask, {
  call_el(session, "tree", "getCheckedKeys")
})
observeEvent(input$tree_get_checked_keys, {
  message("checked: ", paste(input$tree_get_checked_keys, collapse = ", "))
})
```

The answer arrives as `input$<id>_<method>` with the method name in
snake_case. Each component’s help page lists what it accepts under
“Element methods”.

### English by default

[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
and
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
load English for Element Plus’s built-in text – placeholders,
empty-table messages, date-picker buttons. All 67 of its locales are
bundled
([`el_locales()`](https://kaipingyang.github.io/shiny.element/reference/el_locales.md)),
and `options(shiny.element.locale = "zh-cn")` sets one for a whole
session.

### Design notes

- Controls are Vue applications on a host carrying a Shiny input
  binding; containers render as plain markup driven by bindings of their
  own, so they can nest freely.
- Element Plus is bundled in `inst/element-plus/` and Vue in
  `inst/vue3/` rather than loaded from a CDN, so apps work offline.
- `el_page(dev = TRUE)` loads Vue’s development build, which surfaces
  template warnings in the browser console.
