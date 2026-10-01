# Update an Element UI Upload

Update an Element UI Upload

## Usage

``` r
update_el_upload(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  limit = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Upload ID (un-namespaced).

- disabled:

  New disabled state.

- limit:

  New maximum number of files.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_upload(session, "files", disabled = TRUE)
  })
}
```
