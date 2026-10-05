# Update Element Plus Cascader

Update Element Plus Cascader

## Usage

``` r
update_el_cascader(
  session = shiny::getDefaultReactiveDomain(),
  id,
  options = NULL,
  value = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  props = NULL,
  size = NULL,
  show_all_levels = NULL,
  collapse_tags = NULL,
  separator = NULL,
  debounce = NULL,
  popper_class = NULL,
  filter_method = NULL,
  before_filter = NULL,
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
  virtual_scroll = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Cascader ID

- options:

  New cascader options

- value:

  New selected value

- placeholder:

  New placeholder text

- clearable:

  Whether clearable

- filterable:

  Whether filterable

- disabled:

  Whether disabled

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- props:

  Element's `props`, as a named list: `multiple`, `checkStrictly`,
  `expandTrigger` (`"click"` or `"hover"`), `lazy`, `lazyLoad`, and the
  field names `value`, `label`, `children`, `disabled`, `leaf`. With
  `lazy = TRUE` and no `lazyLoad` of your own, the server loads each
  column: see "Shiny inputs".

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

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_cascader(session, "region", value = list("zj", "hz"))
  })
}
```
