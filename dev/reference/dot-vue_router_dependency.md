# vue-router, as bundled with the package

vue-router 5.4.0's global build, `VueRouter`, for
[`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md).
As with Vue's, the development build is in the package's sources but not
in what is built for CRAN, which loads it from unpkg when asked for it;
it is versioned one step above the production build, so a page holding
both keeps it.

## Usage

``` r
.vue_router_dependency(dev = .vue_dev())
```

## Arguments

- dev:

  Load the development build.

## Value

An htmlDependency object.
