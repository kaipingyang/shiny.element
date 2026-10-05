# Update Element Plus Check Tag

Update Element Plus Check Tag

## Usage

``` r
update_el_check_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  disabled = NULL,
  type = NULL
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

- type:

  `"primary"` (the default), `"success"`, `"info"`, `"warning"` or
  `"danger"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_check_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_check_tag.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

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
