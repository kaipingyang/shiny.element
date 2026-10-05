# Update Element Plus Dropdown

Server-side update for
[`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md).

## Usage

``` r
update_el_dropdown(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  trigger = NULL,
  type = NULL,
  size = NULL,
  split_button = NULL,
  hide_on_click = NULL,
  placement = NULL,
  show_timeout = NULL,
  hide_timeout = NULL,
  tabindex = NULL,
  append_to = NULL,
  button_props = NULL,
  effect = NULL,
  max_height = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_options = NULL,
  popper_style = NULL,
  role = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Dropdown ID (un-namespaced).

- disabled:

  New disabled state.

- trigger:

  Trigger event: `"hover"` (default) or `"click"`.

- type:

  Button type when `split_button = TRUE`: `"primary"`, etc.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- split_button:

  Whether to render as a split button (main + dropdown arrow). Default
  `FALSE`.

- hide_on_click:

  Whether to close the menu after an item is clicked. Default `TRUE`.

- placement:

  Dropdown placement: `"bottom-end"` (default), `"bottom"`,
  `"bottom-start"`, `"top"`, `"top-start"`, `"top-end"`.

- show_timeout:

  Delay in ms before the menu appears, for `trigger = "hover"`.

- hide_timeout:

  Delay in ms before the menu hides, for `trigger = "hover"`.

- tabindex:

  Tab index of the dropdown trigger.

- append_to:

  Which element the dropdown CONTENT appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- button_props:

  Props for the button component, refer to Button Attributes. Element
  Plus's `button-props` (object).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- max_height:

  The max height of menu. Element Plus's `max-height` (string / number).

- persistent:

  When dropdown inactive and `persistent` is `false` , dropdown menu
  will be destroyed. Element Plus's `persistent` (boolean).

- popper_class:

  Custom class name for Dropdown's dropdown. Element Plus's
  `popper-class` (string / object).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- popper_style:

  Custom style for Dropdown's dropdown. Element Plus's `popper-style`
  (string / object).

- role:

  The ARIA role attribute for the dropdown menu. Depending on the use
  case, you may want to change this to 'navigation'. Element Plus's
  `role` (enum).

- show_arrow:

  Whether the tooltip content has an arrow. Element Plus's `show-arrow`
  (boolean).

- teleported:

  Whether the dropdown popup is teleported to the body. Element Plus's
  `teleported` (boolean).

- trigger_keys:

  Specify which keys on the keyboard can trigger when pressed. Element
  Plus's `trigger-keys` (`string[]`).

- virtual_ref:

  A CSS selector, `"#help-icon"`, for an element elsewhere on the page
  that the dropdown is attached to, in place of a trigger of its own.
  Element Plus's `virtual-ref` takes the element itself; the selector is
  looked up in the browser.

- virtual_triggering:

  Whether virtual triggering is enabled. Element Plus's
  `virtual-triggering` (boolean); `TRUE` when `virtual_ref` is given.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_dropdown(session, "actions", disabled = TRUE)
  })
}
```
