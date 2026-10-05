# Update Element Plus Alert

Server-side update for
[`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md).

## Usage

``` r
update_el_alert(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  type = NULL,
  description = NULL,
  closable = NULL,
  close_text = NULL,
  show_icon = NULL,
  center = NULL,
  effect = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Alert ID (un-namespaced).

- title:

  New title text.

- type:

  New alert type.

- description:

  New description text. Use `NULL` to leave unchanged.

- closable:

  Whether to show a close button. Default `TRUE`.

- close_text:

  Custom text for the close button. `""` for the default cross.

- show_icon:

  Whether to display the type icon. Default `FALSE`.

- center:

  Whether to centre the content. Default `FALSE`.

- effect:

  Visual effect: `"light"` (default) or `"dark"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_alert(session, "hint", title = "Saved", type = "success")
  })
}
```
