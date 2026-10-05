# Update Element Plus Select

Server-side update for
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  multiple_limit = NULL,
  loading = NULL,
  loading_text = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL,
  multiple = NULL,
  size = NULL,
  collapse_tags = NULL,
  value_key = NULL,
  name = NULL,
  autocomplete = NULL,
  automatic_dropdown = NULL,
  allow_create = NULL,
  popper_class = NULL,
  reserve_keyword = NULL,
  remote = NULL,
  filter_method = NULL,
  remote_method = NULL,
  append_to = NULL,
  aria_label = NULL,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  debounce = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  max_collapse_tags = NULL,
  offset = NULL,
  persistent = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  remote_show_suffix = NULL,
  show_arrow = NULL,
  suffix_icon = NULL,
  suffix_transition = NULL,
  tabindex = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  tag_tooltip = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Select input ID (un-namespaced).

- selected, value:

  New selected value(s). `selected` is Shiny's name, `value` Element's;
  give either.

- choices, options:

  New choices, in any form
  [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
  takes. `choices` is Shiny's name, `options` Element's; give either.

- disabled, placeholder, clearable, filterable, multiple_limit:

  New values for these props.

- loading, loading_text, no_match_text, no_data_text:

  The remote-search state: show the spinner while options are fetched,
  and the messages for no match and no data.

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

- multiple:

  Whether multiple items can be selected. Default `FALSE`.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- collapse_tags:

  Whether to collapse selected tags into a summary when
  `multiple = TRUE`. Default `FALSE`.

- value_key:

  Key that identifies an option when values are objects. Default
  `"value"`.

- name:

  Native `name` attribute.

- autocomplete:

  Native `autocomplete` attribute. Default `"off"`.

- automatic_dropdown:

  Whether a filterable select opens its menu on focus.

- allow_create:

  Whether the user may create options not in the list. Needs
  `filterable = TRUE`.

- popper_class:

  Extra class name for the dropdown panel.

- reserve_keyword:

  Whether a multiple filterable select keeps the search term after
  selecting.

- remote:

  Whether options are fetched from the server as the user types. Needs
  `filterable = TRUE`; see "Shiny inputs".

- filter_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function filtering the options as the user types.

- remote_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function fetching options in the browser instead of from the server.
  Needs `remote = TRUE`.

- append_to:

  Which element the select dropdown appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- clear_icon:

  Custom clear icon component. Element Plus's `clear-icon` (string /
  Component). An icon's name, such as `"Search"`.

- collapse_tags_tooltip:

  Whether show all selected tags when mouse hover text of collapse-tags.
  To use this, `collapse-tags` must be true. Element Plus's
  `collapse-tags-tooltip` (boolean).

- debounce:

  Debounce delay during remote search, in milliseconds. Element Plus's
  `debounce` (number).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- fallback_placements:

  List of possible positions for dropdown popper.js. Element Plus's
  `fallback-placements` (`Placement[]`).

- fit_input_width:

  Whether the width of the dropdown is the same as the input. Element
  Plus's `fit-input-width` (boolean).

- max_collapse_tags:

  The max tags number to be shown. To use this, `collapse-tags` must be
  true. Element Plus's `max-collapse-tags` (number).

- offset:

  Offset of the dropdown. Element Plus's `offset` (number).

- persistent:

  When select dropdown is inactive and `persistent` is `false`, select
  dropdown will be destroyed. Element Plus's `persistent` (boolean).

- placement:

  Position of dropdown. Element Plus's `placement` (enum).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- popper_style:

  Custom style for Select's dropdown and tags' tooltip. Element Plus's
  `popper-style` (string / object).

- remote_show_suffix:

  In remote search method show suffix icon. Element Plus's
  `remote-show-suffix` (boolean).

- show_arrow:

  Whether the dropdown has an arrow. Element Plus's `show-arrow`
  (boolean).

- suffix_icon:

  Custom suffix icon component. Element Plus's `suffix-icon` (string /
  Component). An icon's name, such as `"Search"`.

- suffix_transition:

  Animation when dropdown appears/disappears icon. Element Plus's
  `suffix-transition` (boolean).

- tabindex:

  Tabindex for input. Element Plus's `tabindex` (string / number).

- tag_effect:

  Tag effect. Element Plus's `tag-effect` (” \| 'light' \| 'dark' \|
  'plain').

- tag_type:

  Tag type. Element Plus's `tag-type` (” \| 'success' \| 'info' \|
  'warning' \| 'danger').

- teleported:

  Whether select dropdown is teleported, if `true` it will be teleported
  to where `append-to` sets. Element Plus's `teleported` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- tag_tooltip:

  Settings for the tooltip listing collapsed tags, with `collapse_tags`
  and `collapse_tags_tooltip`: a named list of tooltip attributes
  (`placement`, `effect`, ...). Element Plus's `tag-tooltip`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_select(session, "city", selected = "sh")
  })
}
```
