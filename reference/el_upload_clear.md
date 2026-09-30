# Clear an Element UI Upload's file list

Empties the list of chosen files, as you would after a form is
submitted. It does not undo an upload that has already happened.

## Usage

``` r
el_upload_clear(session, id)
```

## Arguments

- session:

  Shiny session object.

- id:

  Upload ID (un-namespaced).

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
