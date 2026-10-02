# shiny.element 0.1.0

First release.

## Components

Every component Element UI 2.15.14 documents is wrapped -- 82 tags, services
included -- with everything each one documents reachable from R: 757
attributes, 115 events, 60 methods and 48 slots.

* **Input** — `el_input()`, `el_input_number()`, `el_select()`,
  `el_radio_group()`, `el_checkbox_group()`, `el_switch()`, `el_slider()`,
  `el_rate()`, `el_date_picker()`, `el_time_picker()`, `el_time_select()`,
  `el_color_picker()`, `el_cascader()`, `el_cascader_panel()`, `el_upload()`,
  `el_autocomplete()`, `el_transfer()`.
* **Display** — `el_table()`, `el_tag()`, `el_progress()`, `el_alert()`,
  `el_badge()`, `el_card()`, `el_calendar()`, `el_tree()`, `el_timeline()`,
  `el_carousel()`, `el_icon()`, `el_link()`, `el_divider()`, `el_avatar()`,
  `el_image()`, `el_tooltip()`, `el_popover()`, `el_popconfirm()`.
* **Navigation** — `el_menu()`, `el_tabs()`, `el_steps()`, `el_pagination()`,
  `el_dropdown()`, `el_breadcrumb()`, `el_page_header()`, `el_backtop()`,
  `el_infinite_scroll()`.
* **Containers** — `el_collapse()`, `el_dialog()`, `el_drawer()`, `el_form()`,
  `el_row()`, `el_col()`, `el_container()`, `el_header()`, `el_aside()`,
  `el_main()`, `el_footer()`.
* **Feedback** — `el_message()`, `el_notification()`, `el_message_box()`,
  `el_loading()`, `el_loading_close()`.
* **Helpers** — `el_page()`, `el_theme()`, `use_element()`, `el_table_config()`,
  `df_to_tree_data()`, `df_to_cascader_options()`, `el_form_validate()`.

Most components have a matching `update_el_*()` for server-side updates, and
report their value through `input$<id>` like any other Shiny input.
As with Shiny's own `update*Input()`, a value set from the server is reported
back through `input$<id>` too.

`el_page()` themes the page around the components with `el_theme()`, a bslib
theme carrying Element's colours, font and control sizes, so Shiny's own
inputs and outputs match the Element ones beside them. `theme = NULL` leaves
Shiny's plain Bootstrap.

Tabs can be added and removed from the server (`insert_el_tab()`,
`remove_el_tab()`) or by the user (`editable = TRUE`), and a lazy pane binds
its content when first shown. Messages and notifications given an `id` can be
closed by it (`el_message_close()`, `el_notification_close()`).

## Tables

`el_table()` columns may carry a `cell` template, drawn once per row with
`scope.row` in reach -- a status tag, a progress bar, a column of buttons --
and a `type` of `"index"` or `"expand"`. A button in a cell reports with
`rowAction('edit', scope)`, setting `input$<id>_edit` to the row's number
and the row. `loading` shows Element's loading mask, from the server too.

`el_table()` draws no column borders by default, as Element does; pass
`border = TRUE` for them.

`update_el_table(data =)` keeps the columns the table was created with.
It used to re-infer them from the new data, discarding every label,
formatter and template.

## Dashboards

A new article builds whole apps: Element's own admin-layout example rebuilt
in R, a sales overview, and an orders admin page with search, row actions,
server-side sorting and paging, an editing dialog and confirmed deletes.
Each is also in the installed package, under `examples/dashboards/`.

## Shiny modules

UI functions no longer namespace their `id` from the reactive domain they
are built in; inside a module, wrap the id in `ns()` as for any Shiny
input. Built by `renderUI()` in a module's server, a component used to be
namespaced twice -- `ns("x")` became `"mod-mod-x"` -- and never reported.
Their `session` argument is deprecated; a session passed to it still
namespaces the id, with a warning. `update_el_*()` and the other server
functions are unchanged: they namespace the bare id, as `update*Input()`
does.

## Without Shiny

Components work on a page with no Shiny behind it -- R Markdown, Quarto, a
saved HTML file: they render and respond to the user, with nowhere to
report to. Every call into Shiny is guarded, the tabs, collapse, dialog and
drawer bind themselves when Shiny is absent, and the scripts bring their own
jQuery. The website's examples are live components built this way, with a
screenshot only where an example needs a server.

## Components rendered by `renderUI()`

A component whose type first appears through `renderUI()` or `insertUI()`
now hears `update_el_*()` and `el_call()`. Their handlers registered only on
`shiny:connected`, which had already fired by the time such a component's
script arrived, so every update to it went nowhere without a word.

## Raw Element tags

`el$` tags are documented for what they are: markup for inside a component
-- `el_widget()`, `template()`, slots, table cells, a wrapper's trigger. At
the top level of a page nothing compiles them; the browser console now says
so instead of leaving bare text.

## Every component is a Shiny input

Each component is a host element carrying its id, with Element's markup
inside and a Shiny input binding on it -- the way reactR binds React
components -- so the rest of Shiny reaches it as it reaches `textInput()`:
`shinyjs::hide()` and `disable()`, `removeUI()` (which destroys its Vue
instance too), bookmarking, shinyvalidate, a test driver's `set_inputs()`.
Vue 2.7.14, the version Element UI 2 runs on, is bundled beside Element, and
`JS()` marks JavaScript the way `htmlwidgets::JS()` does, without depending
on htmlwidgets. (Development versions built on vueR's htmlwidgets, where the
id sat on a hidden element beside the component and Shiny did not know it
was an input.)

`el_widget()` builds the same shape for components of your own, and its new
`report` argument names the value -- an input made of `el$` tags, as the
limitations article shows, needs no JavaScript.

## Shiny conventions

* **Bookmarking.** Every component's value goes through
  `shiny::restoreInput()`, so a bookmarked page reopens as it was left --
  inputs, the selected tab, open panels, an open dialog, the pager's page.
* **Dates.** `el_date_picker()` reports `Date` for `"date"`, `"dates"` and
  `"daterange"` with the default `value_format`, as `dateInput()` does. A
  `value_format` of your own still reports text in that format.
* **The session argument.** Every server function -- `update_el_*()`,
  `el_message()`, `el_call()` and the rest -- takes the current session by
  default, as `updateTextInput()` does. Given an id in the session's place,
  `update_el_input("name", ...)`, it says so and names the call to write
  instead, as Shiny's own do.
* **Action buttons.** `el_button()` and `el_tag()` report their clicks as
  `actionButton()` does: 0 on load, classed so that `observeEvent()` and
  `req()` treat 0 as not yet clicked. `el_dropdown()` reports each command
  as an event, so choosing the same item twice runs an observer twice.
* **One input per id.** `el_cascader()` reports to `input$<id>`, as every
  other input does, rather than `input$<id>_value`, and `el_pagination()`
  reports its page as `input$<id>` rather than `input$<id>_page`.
* **The server loads.** Where Element takes a JavaScript function to fetch
  data, the server can answer instead: a lazy `el_tree()`, `el_cascader()`,
  `el_cascader_panel()` or tree `el_table()` asks through `input$<id>_load`
  (`_lazy_load` for a cascader) and `el_load_children()` replies; a
  `remote` `el_select()` sends what is typed as `input$<id>_query`, and
  `update_el_select()` with the matches answers it.
* **Labels and errors from the server.** The `update_el_*()` of every input
  takes `label`, as `updateTextInput()` does, and `error`, Element's
  message for a check only the server can make; `""` clears it.
* **Validation.** shinyvalidate's messages show on a component as Element
  shows a failed form rule: framed in red, the message underneath -- for a
  labelled component, under the control, replacing any `error` it opened
  with.
* **Labels.** Every input takes `label`, shown above it or, with
  `label_position = "left"` or `"right"`, beside it -- also its accessible
  name. The props of Element's `el-form-item` that suit a single input come
  with it: `label_width`, `label_suffix`, `required` (the red asterisk),
  `error`, `show_message` and `inline_message`; the component's own `size`
  sizes the label. `el_upload()`'s trigger text is now `button_label`, as
  `fileInput()`'s `buttonLabel`.
* **Element themed from the page's theme.** The `primary`, `success`,
  `warning`, `danger` and `info` of `el_page()`'s theme reach Element's
  components too, with the tints and shades Element derives from each, and
  `el_theme(element =)` sets any of Element's own theme variables --
  `list("border-radius-base" = "8px")`. Element's stylesheet is built for
  the theme as upstream builds one: brand colours replaced in place, as its
  theme picker does, or its Sass sources -- bundled -- compiled, as its theme
  tool does. `use_element(theme =)` does the same elsewhere; its layout CSS
  argument is now `layout_css`.
* **A tree filters as it stands.** `el_tree()` has a default
  `filter_node_method` -- the label contains the text, ignoring case -- so
  `el_call(session, "tree", "filter", list(text))` needs no JavaScript;
  Element itself throws without one.
* **More of upstream.** `el_checkbox()`, one box as `checkboxInput()` is,
  with `indeterminate` for a "check all" box; `el_button_group()`, buttons
  joined into one bar, each still reporting; an `id` on `el_badge()` or
  `el_link()` makes it something the server changes (`update_el_badge()`,
  `update_el_link()`), the link an action link; `el_select(option_template
  =)`, Element's custom option template; `el_autocomplete(remote = TRUE)`,
  suggestions from the server through `input$<id>_query`. In forms,
  `el_rule()` takes Element's custom `validator` and the rest of
  async-validator (`enum`, `whitespace`, `transform`), `el_form_field()`
  every control Element's form holds -- `"checkbox"`, `"time-select"`,
  `"autocomplete"`, `"transfer"`, `"cascader-panel"` added -- and
  `update_el_form()` replaces the field list (`fields =`) or shows the
  server's own errors (`errors =`). An update can carry `JS()` functions.
* **Element's global config.** `el_page()` and `use_element()` take `size`
  and `z_index`, as `Vue.use(Element, {size, zIndex})` does; a labelled
  input's label follows the size too. Element's `display.css` -- the
  `hidden-xs-only` family -- is loaded with the rest, and `el` gains the
  registered components it lacked (`button_group`, `checkbox_button`,
  `scrollbar`, `spinner`, `collapse_transition`) and loses `anchor`,
  `anchor_link` and `loading`, which Element 2 does not have as tags.
* **Checked arguments.** An enumerated argument Element does not accept --
  `type = "primry"` -- is an error listing the values it does, rather than
  a component drawn in its default style.
* **Templates.** Each component's template travels as a script the browser
  does not parse: nothing flashes before Vue runs, and camelCase attribute
  names reach Vue unchanged.

## Note for users of the development version

`el_table()` now takes `id` first, like every other component:

```r
el_table("my_table", data = df)     # new
el_table(data = df, id = "my_table")  # also fine, and always was
```

Positional calls written against the old `el_table(data, columns, id)` order
still work -- the arguments are shifted back with a warning -- but naming them
is the way to keep it quiet.

`input$<cascader id>_value` is now `input$<cascader id>`, and
`input$<pager id>_page` is `input$<pager id>`. `update_vue_component()` and
`vue_handler_dependency()` are gone: `update_vue_data()` does the first's
job, and the bridge loads with every component. `use_element()`'s first
argument is now the page's theme; its layout CSS is `layout_css`.

## Filling a slot

Every component takes `slots`, a named list, one entry per Element slot:

```r
el_alert("a", slots = list(title = tags$b("Something went wrong")))

# A component works as slot content too, and keeps reporting its inputs
el_alert("a", slots = list(title = el_tag("sev", "critical", type = "danger")))
```

A scoped slot, where Element hands the template its own data, is written with
`template()`:

```r
el_calendar("cal", slots = list(
  dateCell = template(
    htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
    slot = "dateCell", scope = "{date, data}"
  )
))
```

## Reaching a component's methods

Element documents methods as well as props. `el_call()` invokes one:

```r
observeEvent(input$clear, {
  el_call(session, "tbl", "clearSelection")
})

# A method with a return value answers asynchronously
observeEvent(input$ask, {
  el_call(session, "tree", "getCheckedKeys")
})
observeEvent(input$tree_get_checked_keys, {
  message("checked: ", paste(input$tree_get_checked_keys, collapse = ", "))
})
```

The answer arrives as `input$<id>_<method>` with the method name in
snake_case. Each component's help page lists what it accepts under
"Element methods".

## Element UI 2.15.14, and English by default

The bundled Element UI is 2.15.14, the last 2.x release; 2.13.2 was two
minor versions behind. That brings `el_descriptions()`, `el_statistic()`,
`el_empty()`, `el_result()` and `el_skeleton()`, and a handful of new props
on existing components.

`el_page()` and `use_element()` now load English for Element's built-in text
-- placeholders, empty-table messages, date-picker buttons. Element's own
default is Simplified Chinese, which is what every page showed before. All 59
of Element's locales are bundled (`el_locales()`), and
`options(shiny.element.locale = "zh-CN")` sets one for a whole session.

## Design notes

* Controls are Vue instances on a host carrying a Shiny input binding;
  containers render as plain markup driven by bindings of their own, so they
  can nest freely.
* Element UI is bundled in `inst/element-ui/` rather than loaded from a CDN, so
  apps work offline.
* `el_page(dev = TRUE)` loads Vue's development build, which surfaces template
  warnings in the browser console.
