# Update Element Plus Steps

Update Element Plus Steps

## Usage

``` r
update_el_steps(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  process_status = NULL,
  finish_status = NULL,
  space = NULL,
  direction = NULL,
  align_center = NULL,
  simple = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Steps ID

- active:

  New active step index

- process_status:

  New process status

- finish_status:

  New finish status

- space:

  Step spacing (number or percentage string)

- direction:

  Display direction ("horizontal" or "vertical")

- align_center:

  Center align title and description

- simple:

  Apply simple style

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_steps()`](https://kaipingyang.github.io/shiny.element/reference/el_steps.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_steps(session, "wizard", active = 2)
  })
}
```
