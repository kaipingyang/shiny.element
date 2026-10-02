# Update Element UI Link

Server-side update for an
[`el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md)
given an `id`.

## Usage

``` r
update_el_link(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  href = NULL,
  type = NULL,
  underline = NULL,
  disabled = NULL,
  icon = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateActionLink()`](https://rdrr.io/pkg/shiny/man/updateActionButton.html).

- id:

  Link ID (un-namespaced).

- label, href, type, underline, disabled, icon:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$more, update_el_link(session, "more", label = "Show less"))
}
```
