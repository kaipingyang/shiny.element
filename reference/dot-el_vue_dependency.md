# Vue, as bundled with the package

Vue 3, the global build with the template compiler, from `inst/vue3`:
components are compiled in the browser from their x-template. `dev` is
kept for the argument's sake; the production build is the only one
bundled.

## Usage

``` r
.el_vue_dependency(dev = getOption("shiny.element.dev", FALSE))
```

## Arguments

- dev:

  Unused.

## Value

An htmlDependency object.
