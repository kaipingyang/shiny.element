# Update Element Plus Button

Server-side update for
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md).
Supports all visual states including `size`, `plain`, `round`, and
`loading`.

## Usage

``` r
update_el_button(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  type = NULL,
  size = NULL,
  plain = NULL,
  round = NULL,
  loading = NULL,
  disabled = NULL,
  circle = NULL,
  icon = NULL,
  autofocus = NULL,
  auto_insert_space = NULL,
  bg = NULL,
  color = NULL,
  dark = NULL,
  dashed = NULL,
  link = NULL,
  loading_icon = NULL,
  tag = NULL,
  text = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Button ID (un-namespaced).

- label:

  New label text.

- type:

  New button type.

- size:

  New button size.

- plain:

  New plain state.

- round:

  New round state.

- loading:

  New loading state.

- disabled:

  New disabled state.

- circle:

  Whether to render as a circle button (icon only, no label). Default
  `FALSE`.

- icon:

  Either an Element icon class name such as `"el-icon-search"`, which
  Element renders itself and `update_el_button()` can change, or a tag
  (for example from
  [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)),
  which is inserted as button content.

- autofocus:

  Whether the button takes focus on page load. Default `FALSE`.

- auto_insert_space:

  Automatically insert a space between two chinese characters(this will
  only take effect when the text length is 2 and all characters are in
  Chinese.). Element Plus's `auto-insert-space` (boolean).

- bg:

  Determine whether the text button background color is always on.
  Element Plus's `bg` (boolean).

- color:

  Custom button color, automatically calculate `hover` and `active`
  color. Works with `link`/`text` buttons since. Element Plus's `color`
  (string).

- dark:

  Dark mode, which automatically converts `color` to dark mode colors.
  Element Plus's `dark` (boolean).

- dashed:

  Determine whether it's a dashed button. Element Plus's `dashed`
  (boolean).

- link:

  Determine whether it's a link button. Element Plus's `link` (boolean).

- loading_icon:

  Customize loading icon component. Element Plus's `loading-icon`
  (string / Component). An icon's name, such as `"Search"`.

- tag:

  Custom element tag. Element Plus's `tag` (string / Component). An
  icon's name, such as `"Search"`.

- text:

  Determine whether it's a text button. Element Plus's `text` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_button(session, "save", loading = TRUE)
  })
}
```
