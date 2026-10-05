# Update Element Plus Input Tag

Server-side update for
[`el_input_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_input_tag.md).

## Usage

``` r
update_el_input_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  max = NULL,
  tag_type = NULL,
  tag_effect = NULL,
  effect = NULL,
  trigger = NULL,
  draggable = NULL,
  delimiter = NULL,
  size = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  save_on_blur = NULL,
  clearable = NULL,
  clear_icon = NULL,
  validate_event = NULL,
  readonly = NULL,
  autofocus = NULL,
  tabindex = NULL,
  max_collapse_tags = NULL,
  maxlength = NULL,
  minlength = NULL,
  placeholder = NULL,
  autocomplete = NULL,
  aria_label = NULL
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

- max:

  Max number tags that can be enter. Element Plus's `max` (number).

- tag_type:

  Tag type. Element Plus's `tag-type` (” \| 'success' \| 'info' \|
  'warning' \| 'danger').

- tag_effect:

  Tag effect. Element Plus's `tag-effect` (” \| 'light' \| 'dark' \|
  'plain').

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- trigger:

  The key to trigger input tag. Element Plus's `trigger` ('Enter' \|
  'Space').

- draggable:

  Whether tags can be dragged. Element Plus's `draggable` (boolean).

- delimiter:

  Add a tag when a delimiter is matched. Element Plus's `delimiter`
  (string / regex).

- size:

  Input box size. Element Plus's `size` ('large' \| 'default' \|
  'small').

- collapse_tags:

  Whether to collapse tags to a text when multiple selecting. Element
  Plus's `collapse-tags` (boolean).

- collapse_tags_tooltip:

  Whether show all selected tags when mouse hover text of collapse-tags.
  To use this, collapse-tags must be true. Element Plus's
  `collapse-tags-tooltip` (boolean).

- save_on_blur:

  Whether to save the input value when the input loses focus. Element
  Plus's `save-on-blur` (boolean).

- clearable:

  Whether to show clear button. Element Plus's `clearable` (boolean).

- clear_icon:

  Custom clear icon component. Element Plus's `clear-icon` (string /
  Component). An icon's name, such as `"Search"`.

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- readonly:

  Same as `readonly` in native input. Element Plus's `readonly`
  (boolean).

- autofocus:

  Same as `autofocus` in native input. Element Plus's `autofocus`
  (boolean).

- tabindex:

  Same as `tabindex` in native input. Element Plus's `tabindex` (string
  / number).

- max_collapse_tags:

  The max tags number to be shown. To use this, collapse-tags must be
  true. Element Plus's `max-collapse-tags` (number).

- maxlength:

  Same as `maxlength` in native input. Element Plus's `maxlength`
  (string / number).

- minlength:

  Same as `minlength` in native input. Element Plus's `minlength`
  (string / number).

- placeholder:

  Placeholder of input. Element Plus's `placeholder` (string).

- autocomplete:

  Same as `autocomplete` in native input. Element Plus's `autocomplete`
  (string).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_input_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_input_tag.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_input_tag(session, "x", value = NULL))
}
```
