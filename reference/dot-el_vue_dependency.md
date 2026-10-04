# Vue, as bundled with the package

Vue 3, the global build with the template compiler, from `inst/vue3`:
components are compiled in the browser from their x-template. The
development build keeps Vue's warnings (`[Vue warn]`), which the
production build strips. It is versioned one step above the production
build, so on a page holding both – `el_page(dev = TRUE)` beside
components that bring the default – htmltools keeps the development one.

## Usage

``` r
.el_vue_dependency(dev = .vue_dev())
```

## Arguments

- dev:

  Load `vue.global.js` rather than `vue.global.prod.js`.

## Value

An htmlDependency object.
