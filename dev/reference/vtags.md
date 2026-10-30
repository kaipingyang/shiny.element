# Vue's built-in components, as tags

A tag generator for each component Vue – and the page's
[`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md)
– registers in every app, as `tags$p` is for HTML and a component
library's tag set for its components:
`vtags$transition(name = "fade", ...)` writes
`<transition name="fade">`. They belong in a Vue template – a
[`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md)'s,
a component's markup, a slot – where a Vue app compiles them; Vue's own
names, snake_case for kebab-case (`keep_alive` is `<keep-alive>`).
Directives go on them as on any tag:
`vtags$component(is = v_bind("view"))`.

## Usage

``` r
vtags
```

## Value

A named list of tag-generating functions.

## Details

- `transition`, `transition_group`: Vue's enter and leave animations;

- `keep_alive`: keeps the components it switches between alive;

- `teleport`: draws its content elsewhere, `to = "body"`;

- `suspense`: waits for async components;

- `component`: a component chosen by `is`;

- `slot`: a slot of a
  [`vue_component()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_component.md)'s
  own template;

- `router_view`, `router_link`: the route's component, a link to a route
  ([`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md)).

## See also

[directives](https://kaipingyang.github.io/shiny.element/dev/reference/directives.md)
for
[`v_if()`](https://kaipingyang.github.io/shiny.element/dev/reference/directives.md)
and the rest.

## Examples

``` r
names(vtags)
#> [1] "transition"       "transition_group" "keep_alive"       "teleport"        
#> [5] "suspense"         "component"        "slot"             "router_view"     
#> [9] "router_link"     

vue_app(
  "fade",
  htmltools::tags$div(
    htmltools::tags$button(v_on(click = "show = !show"), "Toggle"),
    vtags$transition(
      name = "fade",
      htmltools::tags$p(v_if("show"), "Hello")
    )
  ),
  data = list(show = TRUE)
)
#> <div id="fade" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div>
#>   <button @click="show = !show">Toggle</button>
#>   <transition name="fade">
#>     <p v-if="show">Hello</p>
#>   </transition>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"show":true}},"evals":[]}</script>
#> </div>
```
