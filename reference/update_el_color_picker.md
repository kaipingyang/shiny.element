# Update Element Plus Color Picker

Server-side update for
[`el_color_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker.md).

## Usage

``` r
update_el_color_picker(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  size = NULL,
  show_alpha = NULL,
  color_format = NULL,
  predefine = NULL,
  popper_class = NULL,
  append_to = NULL,
  aria_label = NULL,
  clearable = NULL,
  empty_values = NULL,
  persistent = NULL,
  popper_style = NULL,
  tabindex = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Color picker ID (un-namespaced).

- value:

  New colour string.

- disabled:

  New disabled state.

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

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- show_alpha:

  Whether to show an alpha channel slider. Default `FALSE`. When `TRUE`,
  the returned value is an `rgba(...)` string.

- color_format:

  Output format: `NULL` (auto), `"hex"`, `"rgb"`, `"hsv"`, `"hsl"`.

- predefine:

  Character vector of preset colour swatches. `NULL` for none.

- popper_class:

  Extra class name for the dropdown panel.

- append_to:

  Which element the color-picker panel appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- aria_label:

  ColorPicker aria-label. Element Plus's `aria-label` (string).

- clearable:

  Whether to show clear button. Element Plus's `clearable` (boolean).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- persistent:

  When color-picker inactive and persistent is false, the color panel
  will be destroyed. Element Plus's `persistent` (boolean).

- popper_style:

  Custom style for ColorPicker's dropdown. Element Plus's `popper-style`
  (string / object).

- tabindex:

  ColorPicker tabindex. Element Plus's `tabindex` (string / number).

- teleported:

  Whether color-picker popper is teleported to the body. Element Plus's
  `teleported` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_color_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_color_picker(session, "shade", value = "#67C23A")
  })
}
```
