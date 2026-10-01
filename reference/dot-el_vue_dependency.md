# Vue, as bundled with the package

Vue 2.7.14, the version Element UI 2 runs on, from `inst/vue`. The
development build is versioned one step above the production one, so
that when a page asks for it anywhere – `el_page(dev = TRUE)` –
htmltools keeps it over the production copy every component brings,
rather than loading Vue twice.

## Usage

``` r
.el_vue_dependency(dev = getOption("shiny.element.dev", FALSE))
```

## Arguments

- dev:

  Load the development build, which reports template errors.

## Value

An htmlDependency object.
