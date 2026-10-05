# Update Element Plus Tag

Server-side update for
[`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md).

## Usage

``` r
update_el_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  type = NULL,
  closable = NULL,
  size = NULL,
  effect = NULL,
  color = NULL,
  hit = NULL,
  disable_transitions = NULL,
  round = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tag ID (un-namespaced).

- label:

  New label text.

- type:

  New colour type.

- closable:

  New closable state.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- effect:

  Visual effect: `"light"` (default), `"dark"`, `"plain"`.

- color:

  Custom background colour (CSS string). `NULL` for themed colour.

- hit:

  Whether to show a solid border. Default `FALSE`.

- disable_transitions:

  Disable the zoom-in-center animation. Default `FALSE`.

- round:

  Whether Tag is rounded. Element Plus's `round` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tag(session, "status", label = "done", type = "success")
  })
}
```
