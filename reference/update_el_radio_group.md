# Update Element UI Radio Group

Server-side update for
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_radio_group(
  session,
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  value = NULL,
  options = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Radio group input ID (un-namespaced).

- selected, value:

  New selected value. `selected` is Shiny's name, `value` Element's;
  give either.

- choices, options:

  New choices, as for
  [`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
  `choices` is Shiny's name, `options` Element's; give either.

- disabled:

  New disabled state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_radio_group(session, "plan", selected = "pro")
  })
}
```
