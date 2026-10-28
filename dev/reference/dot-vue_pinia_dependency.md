# Pinia, as bundled with the package

Pinia 4.1.0's global build, `Pinia`, which
[`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md)'s
stores are made with. As with Vue's, the development build is in the
package's sources only, loaded from unpkg on a CRAN install, versioned
one step above the production build.

## Usage

``` r
.vue_pinia_dependency(dev = .vue_dev())
```

## Arguments

- dev:

  Load the development build.

## Value

An htmlDependency object.
