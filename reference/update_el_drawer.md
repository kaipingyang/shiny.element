# Update Element UI Drawer

Server-side update for
[`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md).
Use `visible = TRUE` to open and `visible = FALSE` to close.

## Usage

``` r
update_el_drawer(session, id, visible = NULL, title = NULL, size = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Drawer ID (un-namespaced).

- visible:

  Logical. `TRUE` to open, `FALSE` to close.

- title:

  New drawer title.

- size:

  New drawer size.
