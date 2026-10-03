# Element Plus Cascader

Pick a path through nested options – a region, then a country, then a
city – from a dropdown of side-by-side columns.

## Usage

``` r
el_cascader(
  id = NULL,
  options = list(),
  value = NULL,
  placeholder = "Please select",
  props = NULL,
  clearable = FALSE,
  filterable = FALSE,
  disabled = FALSE,
  size = NULL,
  show_all_levels = TRUE,
  collapse_tags = FALSE,
  separator = " / ",
  debounce = 300,
  popper_class = NULL,
  filter_method = NULL,
  before_filter = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  height = NULL,
  item_size = NULL,
  max_collapse_tags = NULL,
  max_collapse_tags_tooltip_height = NULL,
  persistent = NULL,
  placement = NULL,
  popper_append_to_body = NULL,
  popper_style = NULL,
  show_checked_strategy = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  virtual_scroll = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Cascader ID (auto-generated if NULL)

- options:

  Nested options, each `list(value =, label =, children =)`.
  [`df_to_cascader_options()`](https://kaipingyang.github.io/shiny.element/reference/df_to_cascader_options.md)
  builds them from a data.frame.

- value:

  Initially selected path, as a vector of values from the top level down
  – or a list of paths with `props = list(multiple = TRUE)`.

- placeholder:

  Placeholder text

- props:

  Element's `props`, as a named list: `multiple`, `checkStrictly`,
  `expandTrigger` (`"click"` or `"hover"`), `lazy`, `lazyLoad`, and the
  field names `value`, `label`, `children`, `disabled`, `leaf`. With
  `lazy = TRUE` and no `lazyLoad` of your own, the server loads each
  column: see "Shiny inputs".

- clearable:

  Whether clearable

- filterable:

  Whether filterable (searchable)

- disabled:

  Whether disabled

- size:

  Size of cascader: `"large"`, `"default"` or `"small"`.

- show_all_levels:

  Whether to show all levels in input

- collapse_tags:

  Whether to collapse tags in multiple mode

- separator:

  Separator for display

- debounce:

  Debounce delay for filter

- popper_class:

  Extra class name for the dropdown panel.

- filter_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function filtering the options as the user types.

- before_filter:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called before filtering; returning `false` cancels it.

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- clear_icon:

  Custom clear icon component. Element Plus's `clear-icon` (string /
  Component). An icon's name, such as `"Search"`.

- collapse_tags_tooltip:

  Whether show all selected tags when mouse hover text of collapse-tags.
  To use this, `collapse-tags` must be true. Element Plus's
  `collapse-tags-tooltip` (boolean).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- fallback_placements:

  List of possible positions for Tooltip popper.js. Element Plus's
  `fallback-placements` (`Placement[]`).

- fit_input_width:

  Whether the width of the suggestion panel is the same as the input, if
  the value is `number`, then the width is fixed. Element Plus's
  `fit-input-width` (boolean / number).

- height:

  Menu height for virtual scrolling (px). Element Plus's `height`
  (number).

- item_size:

  Node height for virtual scrolling (px). Element Plus's `item-size`
  (number).

- max_collapse_tags:

  The max tags number to be shown. To use this, `collapse-tags` must be
  true. Element Plus's `max-collapse-tags` (number).

- max_collapse_tags_tooltip_height:

  Max height of collapse-tags tooltip. Element Plus's
  `max-collapse-tags-tooltip-height` (string / number).

- persistent:

  When dropdown is inactive and `persistent` is `false`, dropdown will
  be destroyed. Element Plus's `persistent` (boolean).

- placement:

  Position of dropdown. Element Plus's `placement` (enum).

- popper_append_to_body:

  Whether to append the popper menu to body. If the positioning of the
  popper is wrong, you can try to set this prop to false. Element Plus's
  `popper-append-to-body` (boolean).

- popper_style:

  Custom style for Cascader's dropdown and tags' tooltip. Element Plus's
  `popper-style` (string / object).

- show_checked_strategy:

  Strategy for displaying checked nodes in multiple selection mode. Use
  `parent` when you want things tidy. Use `child` when every single item
  matters. Element Plus's `show-checked-strategy` ('parent' \| 'child').

- tag_effect:

  Tag effect. Element Plus's `tag-effect` ('light' \| 'dark' \|
  'plain').

- tag_type:

  Tag type. Element Plus's `tag-type` ('success' \| 'info' \| 'warning'
  \| 'danger').

- teleported:

  Whether cascader popup is teleported. Element Plus's `teleported`
  (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- virtual_scroll:

  Whether to enable virtual scrolling for large data. Element Plus's
  `virtual-scroll` (boolean).

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the selected path, on load and on change.

- `input$<id>_lazy_load` – with `props = list(lazy = TRUE)`, a column to
  load: `level` (0 for the first), `value` and `path` of the option
  opened, and `request`. Answer with
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md),
  passing the input back; each child is
  `list(value =, label =, leaf = TRUE)` for one with nothing below.

- `input$<id>_expand_change`, `_blur`, `_focus`, `_visible_change`,
  `_remove_tag` – Element's events.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `getCheckedNodes()` – Get an array of currently selected node

## Examples

``` r
# Basic cascader usage
cascader_options <- list(
  list(
    value = "guide",
    label = "Guide",
    children = list(
      list(value = "principle", label = "Principle"),
      list(value = "navigation", label = "Navigation")
    )
  ),
  list(
    value = "component",
    label = "Component",
    children = list(
      list(value = "basic", label = "Basic"),
      list(value = "form", label = "Form", disabled = TRUE)
    )
  )
)

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_cascader(
      id = "cascader1",
      options = cascader_options,
      placeholder = "Please select",
      clearable = TRUE
    ),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$cascader1)
  }
  shinyApp(ui, server)
}

# Advanced: custom props and update
custom_props <- list(
  expandTrigger = "hover",
  multiple = FALSE,
  checkStrictly = FALSE,
  emitPath = TRUE,
  lazy = FALSE,
  value = "value",
  label = "label",
  children = "children"
)

# Update cascader options in server:
# update_el_cascader(session, "cascader1", options = new_options)
```
