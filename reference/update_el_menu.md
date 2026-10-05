# Update an Element Plus Menu

Update an Element Plus Menu

## Usage

``` r
update_el_menu(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  collapse = NULL,
  mode = NULL,
  unique_opened = NULL,
  background_color = NULL,
  text_color = NULL,
  active_text_color = NULL,
  menu_trigger = NULL,
  collapse_transition = NULL,
  router = NULL,
  close_on_click_outside = NULL,
  ellipsis = NULL,
  ellipsis_icon = NULL,
  hide_timeout = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_effect = NULL,
  popper_offset = NULL,
  popper_style = NULL,
  show_timeout = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Menu ID (un-namespaced).

- active:

  Index of the item to select.

- collapse:

  New collapsed state.

- mode:

  `"vertical"` (default) or `"horizontal"`.

- unique_opened:

  Keep only one submenu open at a time.

- background_color, text_color, active_text_color:

  Menu colours.

- menu_trigger:

  How a horizontal sub-menu opens: `"hover"` (default) or `"click"`.

- collapse_transition:

  Whether to animate collapsing. Default `TRUE`.

- router:

  Whether to use vue-router mode, taking each index as a path.

- close_on_click_outside:

  Optional, whether menu is collapsed when clicking outside. Element
  Plus's `close-on-click-outside` (boolean).

- ellipsis:

  Whether the menu is ellipsis (available only in horizontal mode).
  Element Plus's `ellipsis` (boolean).

- ellipsis_icon:

  Custom ellipsis icon (available only in horizontal mode and ellipsis
  is true). Element Plus's `ellipsis-icon` (string / Component). An
  icon's name, such as `"Search"`.

- hide_timeout:

  Control timeout for all menus before hiding. Element Plus's
  `hide-timeout` (number).

- persistent:

  When menu inactive and `persistent` is `false` , dropdown menu will be
  destroyed. Element Plus's `persistent` (boolean).

- popper_class:

  Custom class name for all popup menus and titles' tooltips. Element
  Plus's `popper-class` (string).

- popper_effect:

  Tooltip theme, built-in theme: `dark` / `light` when menu is
  collapsed. Element Plus's `popper-effect` ('dark' \| 'light' /
  string).

- popper_offset:

  Offset of the popper (effective for all submenus). Element Plus's
  `popper-offset` (number).

- popper_style:

  Custom style for all popup menus and titles' tooltips. Element Plus's
  `popper-style` (string / object).

- show_timeout:

  Control timeout for all menus before showing. Element Plus's
  `show-timeout` (number).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_menu(session, "nav", active = "data")
  })
}
```
