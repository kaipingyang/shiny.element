# Update Element Plus Checkbox

Server-side update for
[`el_checkbox()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox.md).

## Usage

``` r
update_el_checkbox(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  indeterminate = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateCheckboxInput()`](https://rdrr.io/pkg/shiny/man/updateCheckboxInput.html).

- id:

  Checkbox ID (un-namespaced).

- value:

  Whether the box is ticked.

- label:

  The box's new text.

- indeterminate, disabled:

  New states; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function: the "check all" box follows the group
  observeEvent(input$cities, {
    n <- length(input$cities)
    update_el_checkbox(session, "all", value = n == 4,
                       indeterminate = n > 0 && n < 4)
  }, ignoreNULL = FALSE)
}
```
