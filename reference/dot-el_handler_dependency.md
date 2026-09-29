# Build a component's JS handler dependency

Every handler is paired with el-update.js, the shared updater it calls.
htmltools de-duplicates the shared entry, so listing it here rather than
relying on
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
guarantees it is present and loaded first, whatever the page is built
from.

## Usage

``` r
.el_handler_dependency(name)
```

## Arguments

- name:

  The component's handler name, e.g. `"input"` for
  `el-input-handler.js`.

## Value

A list of htmlDependency objects.
