# VueUse, for a component's `setup()`

VueUse 15.0.0 – the version the bundled component library is built with
– as the global `VueUse`: its composables (`useTransition`,
`useElementSize`, `useCssVar`, `useDebounceFn`, `useStorage`, ...) in a
component's `setup()`, as `VueUse.useTransition(...)`. Give it to the
component that uses it, `vue_app(dependencies = vueuse_dependency())`,
or put it on the page; it carries Vue, which it needs loaded before it,
so either works. No page loads it unless asked: the two files are 149
KB.

## Usage

``` r
vueuse_dependency()
```

## Value

A list of htmlDependency objects: Vue, `@vueuse/shared`, `@vueuse/core`.

## Examples

``` r
# A number counting up to its value
vue_app(
  "count",
  htmltools::tags$b("{{ Math.round(shown) }}"),
  setup = JS(
    "function() {",
    "  var target = Vue.ref(0);",
    "  var shown = VueUse.useTransition(target, { duration: 1500 });",
    "  Vue.onMounted(function() { target.value = 172000; });",
    "  return { shown: shown };",
    "}"
  ),
  dependencies = vueuse_dependency()
)
#> <div id="count" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><b>{{ Math.round(shown) }}</b></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[],"setup":"function() {\n  var target = Vue.ref(0);\n  var shown = VueUse.useTransition(target, { duration: 1500 });\n  Vue.onMounted(function() { target.value = 172000; });\n  return { shown: shown };\n}"},"evals":["options.setup"]}</script>
#> </div>
```
