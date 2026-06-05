# Update Element UI Alert

Server-side update for
[`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md).

## Usage

``` r
update_el_alert(session, id, title = NULL, type = NULL, description = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Alert ID (un-namespaced).

- title:

  New title text.

- type:

  New alert type.

- description:

  New description text. Use `NULL` to leave unchanged.
