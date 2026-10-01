# Update Element UI Checkbox Group

Server-side update for
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md).
Pass only the fields to change; `NULL` fields are excluded from the
update message.

## Usage

``` r
update_el_checkbox_group(
  session,
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  min = NULL,
  max = NULL,
  value = NULL,
  options = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Checkbox group ID (un-namespaced).

- selected, value:

  New character vector of checked values. `selected` is Shiny's name,
  `value` Element's; give either.

- choices, options:

  New choices, as for
  [`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md).
  `choices` is Shiny's name, `options` Element's; give either.

- disabled:

  New disabled state.

- min:

  New minimum checked count.

- max:

  New maximum checked count.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_checkbox_group(session, "langs", selected = c("r", "py"))
  })
}
```
