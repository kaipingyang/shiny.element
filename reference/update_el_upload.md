# Update an Element UI Upload

Update an Element UI Upload

## Usage

``` r
update_el_upload(session, id, disabled = NULL, limit = NULL)
```

## Arguments

- session:

  Shiny session object.

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
