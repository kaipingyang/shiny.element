# Update Element Plus Check Tag

Update Element Plus Check Tag

## Usage

``` r
update_el_check_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateCheckboxInput()`](https://rdrr.io/pkg/shiny/man/updateCheckboxInput.html).

- id:

  Tag ID (un-namespaced).

- value, label, disabled:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$clear,
    update_el_check_tag(session, "pinned", value = FALSE)
  )
}
```
