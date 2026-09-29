# Element UI Dependency

Element UI Dependency

## Usage

``` r
element_ui_dependency(offline = TRUE)
```

## Arguments

- offline:

  Serve Element UI from the copy bundled with this package (the default)
  instead of the unpkg CDN. The bundled files are byte-identical to the
  CDN's. A runtime CDN dependency leaves the page blank on an intranet,
  offline, or whenever unpkg is unreachable, so the local copy is the
  safer default; pass `FALSE` to trade that for a smaller deployment
  bundle.

## Value

An htmlDependency object for Element UI.
