# Vue, as bundled with the package

Vue 3, the global build with the template compiler, from `inst/vue3`:
components are compiled in the browser from their x-template. The
development build keeps Vue's warnings (`[Vue warn]`), which the
production build strips. It is versioned one step above the production
build, so on a page holding both, htmltools keeps the development one.

## Usage

``` r
.vue_vue_dependency(dev = .vue_dev())
```

## Arguments

- dev:

  Load `vue.global.js` rather than `vue.global.prod.js`.

## Value

An htmlDependency object.

## Details

The development build is in the package's sources but not in what is
built from them for CRAN, to keep the package small: installed from
CRAN, it is loaded from the unpkg CDN, the same build unminified.
