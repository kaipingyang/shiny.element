# Update Element Plus Virtualized Select

Server-side update for
[`el_select_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_select_v2.md).

## Usage

``` r
update_el_select_v2(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  multiple = NULL,
  value_key = NULL,
  size = NULL,
  clearable = NULL,
  clear_icon = NULL,
  collapse_tags = NULL,
  multiple_limit = NULL,
  effect = NULL,
  autocomplete = NULL,
  placeholder = NULL,
  filterable = NULL,
  allow_create = NULL,
  filter_method = NULL,
  loading = NULL,
  loading_text = NULL,
  reserve_keyword = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  popper_class = NULL,
  popper_style = NULL,
  teleported = NULL,
  append_to = NULL,
  persistent = NULL,
  popper_options = NULL,
  automatic_dropdown = NULL,
  fit_input_width = NULL,
  suffix_icon = NULL,
  height = NULL,
  item_height = NULL,
  estimated_option_height = NULL,
  scrollbar_always_on = NULL,
  remote = NULL,
  debounce = NULL,
  remote_method = NULL,
  remote_show_suffix = NULL,
  validate_event = NULL,
  offset = NULL,
  show_arrow = NULL,
  placement = NULL,
  fallback_placements = NULL,
  collapse_tags_tooltip = NULL,
  max_collapse_tags = NULL,
  tag_type = NULL,
  tag_effect = NULL,
  aria_label = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  popper_append_to_body = NULL,
  tabindex = NULL,
  props = NULL,
  tag_tooltip = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- value, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component; `""` clears it.

- multiple:

  Is multiple. Element Plus's `multiple` (boolean).

- value_key:

  Unique identity key name for value, required when value is an object.
  Element Plus's `value-key` (string).

- size:

  Size of component. Element Plus's `size` (” \| 'large' \| 'default' \|
  'small').

- clearable:

  Whether select can be cleared. Element Plus's `clearable` (boolean).

- clear_icon:

  Custom clear icon. Element Plus's `clear-icon` (string / Component).
  An icon's name, such as `"Search"`.

- collapse_tags:

  Whether to collapse tags to a text when multiple selecting. Element
  Plus's `collapse-tags` (boolean).

- multiple_limit:

  Maximum number of options user can select when multiple is true. No
  limit when set to 0. Element Plus's `multiple-limit` (number).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- autocomplete:

  Autocomplete of select input. Element Plus's `autocomplete` (string).

- placeholder:

  Placeholder. Element Plus's `placeholder` (string).

- filterable:

  Whether Select is filterable. Element Plus's `filterable` (boolean).

- allow_create:

  Whether creating new items is allowed. To use this, `filterable` must
  be true. Element Plus's `allow-create` (boolean).

- filter_method:

  Custom filter method, the first parameter is the current input value.
  To use this, `filterable` must be true method. Element Plus's
  `filter-method` ((query: string) =\> void). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- loading:

  Whether Select is loading data from server. Element Plus's `loading`
  (boolean).

- loading_text:

  Displayed text while loading data from server, default is 'Loading'.
  Element Plus's `loading-text` (string).

- reserve_keyword:

  Whether reserve the keyword after select filtered option. Element
  Plus's `reserve-keyword` (boolean).

- no_match_text:

  Displayed text when no data matches the filtering query, you can also
  use slot `empty`, default is 'No matching data'. Element Plus's
  `no-match-text` (string).

- no_data_text:

  Displayed text when there is no options, you can also use slot empty.
  Element Plus's `no-data-text` (string).

- popper_class:

  Custom class name for Select's dropdown and tags' tooltip. Element
  Plus's `popper-class` (string / object).

- popper_style:

  Custom style for Select's dropdown and tags' tooltip. Element Plus's
  `popper-style` (string / object).

- teleported:

  Whether select dropdown is teleported, if `true` it will be teleported
  to where `append-to` sets. Element Plus's `teleported` (boolean).

- append_to:

  Which element the select dropdown appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- persistent:

  When select dropdown is inactive and `persistent` is `false`, select
  dropdown will be destroyed. Element Plus's `persistent` (boolean).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- automatic_dropdown:

  For non-filterable Select, this prop decides if the option menu pops
  up when the input is focused. Element Plus's `automatic-dropdown`
  (boolean).

- fit_input_width:

  Whether the width of the dropdown is the same as the input, if the
  value is `number`, then the width is fixed. Element Plus's
  `fit-input-width` (boolean / number).

- suffix_icon:

  Custom suffix icon component. Element Plus's `suffix-icon` (string /
  Component). An icon's name, such as `"Search"`.

- height:

  The height of the dropdown panel, 34px for each item. Element Plus's
  `height` (number).

- item_height:

  The height of the dropdown item. Element Plus's `item-height`
  (number).

- estimated_option_height:

  Controls virtual-list sizing mode: if undefined, the list uses fixed
  item height from `item-height`; if provided, the list uses dynamic
  item sizing and this value as the estimated item height. Element
  Plus's `estimated-option-height` (number).

- scrollbar_always_on:

  Controls whether the scrollbar is always displayed. Element Plus's
  `scrollbar-always-on` (boolean).

- remote:

  Whether search data from server. Element Plus's `remote` (boolean).

- debounce:

  Debounce delay during remote search, in milliseconds. Element Plus's
  `debounce` (number).

- remote_method:

  Function that gets called when the input value changes. Its parameter
  is the current input value. To use this, `filterable` must be true.
  Element Plus's `remote-method` ((query: string) =\> void). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- remote_show_suffix:

  In remote search method show suffix icon. Element Plus's
  `remote-show-suffix` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- offset:

  Offset of the dropdown. Element Plus's `offset` (number).

- show_arrow:

  Whether the dropdown has an arrow. Element Plus's `show-arrow`
  (boolean).

- placement:

  Position of dropdown. Element Plus's `placement` (enum).

- fallback_placements:

  List of possible positions for dropdown popper.js. Element Plus's
  `fallback-placements` (`Placement[]`).

- collapse_tags_tooltip:

  Whether show all selected tags when mouse hover text of collapse-tags.
  To use this, `collapse-tags` must be true. Element Plus's
  `collapse-tags-tooltip` (boolean).

- max_collapse_tags:

  The max tags number to be shown. To use this, `collapse-tags` must be
  true. Element Plus's `max-collapse-tags` (number).

- tag_type:

  Tag type. Element Plus's `tag-type` (” \| 'success' \| 'info' \|
  'warning' \| 'danger').

- tag_effect:

  Tag effect. Element Plus's `tag-effect` (” \| 'light' \| 'dark' \|
  'plain').

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- popper_append_to_body:

  Whether to append the popper menu to body. If the positioning of the
  popper is wrong, you can try to set this prop to false. Element Plus's
  `popper-append-to-body` (boolean).

- tabindex:

  Tabindex for input. Element Plus's `tabindex` (string / number).

- props:

  Which field of an option holds what, when the options are records
  named otherwise: `list(value =, label =, disabled =, options =)`,
  Element Plus's `props`.

- tag_tooltip:

  Settings for the tooltip listing collapsed tags, with `collapse_tags`
  and `collapse_tags_tooltip`: a named list of tooltip attributes
  (`placement`, `effect`, ...). Element Plus's `tag-tooltip`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_select_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_select_v2.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_select_v2(session, "x", value = NULL))
}
```
