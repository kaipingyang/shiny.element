# Update Element UI Dialog

Server-side update for
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md).
Use `visible = TRUE` to open the dialog and `visible = FALSE` to close
it programmatically.

## Usage

``` r
update_el_dialog(session, id, visible = NULL, title = NULL, width = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Dialog ID (un-namespaced).

- visible:

  Logical. `TRUE` to open, `FALSE` to close.

- title:

  New dialog title text.

- width:

  New dialog width (e.g. `"60%"`, `"400px"`).
