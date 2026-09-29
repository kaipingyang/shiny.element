# Update Element UI Drawer

Server-side update for
[`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md).

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

  Open or close it.

- title:

  New header text.

- size:

  New width or height.

## Value

Called for its side effect; returns `NULL` invisibly.
