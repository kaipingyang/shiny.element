# Clear an Element UI Upload's file list

Empties the list of chosen files, as you would after a form is
submitted. It does not undo an upload that has already happened.

## Usage

``` r
el_upload_clear(session = shiny::getDefaultReactiveDomain(), id)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Upload ID (un-namespaced). This is Element's `data` prop, renamed to
  keep it distinct from the uploaded file itself.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    el_upload_clear(session, "files")
  })
}
```
