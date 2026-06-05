# Update Element UI Tabs

Server-side update for
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md).
Switches the active tab programmatically.

## Usage

``` r
update_el_tabs(session, id, selected = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Tabs ID (un-namespaced).

- selected:

  New active tab name.
