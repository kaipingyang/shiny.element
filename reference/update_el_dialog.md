# Update Element UI Dialog

Server-side update for
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md).

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

  Open or close it.

- title:

  New header text.

- width:

  New width.

## Value

Called for its side effect; returns `NULL` invisibly.
