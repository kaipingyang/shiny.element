# Update Element Plus Switch

Server-side update for
[`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md).
Pass only the fields to change; `NULL` fields are excluded from the
update message.

## Usage

``` r
update_el_switch(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  label = NULL,
  error = NULL,
  active_value = NULL,
  inactive_value = NULL,
  name = NULL,
  validate_event = NULL,
  active_action_icon = NULL,
  active_icon = NULL,
  aria_label = NULL,
  before_change = NULL,
  border_color = NULL,
  inactive_action_icon = NULL,
  inactive_icon = NULL,
  inline_prompt = NULL,
  loading = NULL,
  size = NULL,
  tabindex = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Switch ID (un-namespaced).

- value:

  New switch value.

- disabled:

  New disabled state.

- active_text:

  New active text.

- inactive_text:

  New inactive text.

- active_color:

  New active background color.

- inactive_color:

  New inactive background color.

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

- active_value:

  Value reported to Shiny when switch is on. Default `TRUE`.

- inactive_value:

  Value reported to Shiny when switch is off. Default `FALSE`.

- name:

  Native `name` attribute of the inner checkbox.

- validate_event:

  Whether a change triggers form validation. Default `TRUE`.

- active_action_icon:

  Component of the icon displayed in action when in `on` state. Element
  Plus's `active-action-icon` (string / Component). An icon's name, such
  as `"Search"`.

- active_icon:

  Component of the icon displayed when in `on` state, overrides
  `active-text`. Element Plus's `active-icon` (string / Component). An
  icon's name, such as `"Search"`.

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- before_change:

  Before-change hook before the switch state changes. If `false` is
  returned or a `Promise` is returned and then is rejected, will stop
  switching. Element Plus's `before-change` (() =\> Promise \| boolean).

- border_color:

  Border color of the switch ( use CSS var `--el-switch-border-color`
  instead ). Element Plus's `border-color` (string).

- inactive_action_icon:

  Component of the icon displayed in action when in `off` state. Element
  Plus's `inactive-action-icon` (string / Component). An icon's name,
  such as `"Search"`.

- inactive_icon:

  Component of the icon displayed when in `off` state, overrides
  `inactive-text`. Element Plus's `inactive-icon` (string / Component).
  An icon's name, such as `"Search"`.

- inline_prompt:

  Whether icon or text is displayed inside dot, only the first character
  will be rendered for text. Element Plus's `inline-prompt` (boolean).

- loading:

  Whether Switch is in loading state. Element Plus's `loading`
  (boolean).

- size:

  Size of Switch. Element Plus's `size` (” \| 'large' \| 'default' \|
  'small').

- tabindex:

  Tabindex for input. Element Plus's `tabindex` (string / number).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_switch(session, "live", value = TRUE)
  })
}
```
