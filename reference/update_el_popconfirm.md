# Update Element UI Confirmation Bubble

Server-side update for
[`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/reference/el_popconfirm.md).

## Usage

``` r
update_el_popconfirm(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  confirm_button_text = NULL,
  cancel_button_text = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Popconfirm ID (un-namespaced).

- title, confirm_button_text, cancel_button_text:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$row_click, {
    update_el_popconfirm(session, "del",
                         title = paste0("Delete ", selected_name(), "?"))
  })
}
```
