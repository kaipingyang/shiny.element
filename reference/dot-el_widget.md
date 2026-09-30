# Assemble a component: mount point, Vue instance, dependencies

Every control in this package has the same shape: a host `div` holding
the Element markup, a Vue instance mounted on it, and the scripts that
let `update_el_*()` and
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md)
reach it. Writing that out per component meant repeating three things
that are easy to get wrong and were each added to fix a bug:

## Usage

``` r
.el_widget(
  id,
  markup,
  data,
  methods = NULL,
  watch = NULL,
  mounted = NULL,
  computed = NULL,
  dependency = NULL,
  head = NULL,
  width = NULL
)
```

## Arguments

- id:

  The namespaced element id.

- markup:

  The Element markup to mount on, usually one
  [`htmltools::tag()`](https://rstudio.github.io/htmltools/reference/builder.html).

- data:

  The Vue instance's data. Every field that `update_el_*()` may set has
  to be declared here – Vue does not track one that is not.

- methods, watch, mounted, computed:

  Vue options, included when not `NULL`.

- dependency:

  htmlDependency objects to attach.

- head:

  Tags to place before the host, such as a `<style>` block.

- width:

  Component width, as a CSS unit. Applied to the Element markup itself –
  the host carries `display: contents` and generates no box, so a width
  set on it would do nothing.

## Value

A Shiny UI element with its dependencies attached.

## Details

- `display: contents` on the host, or every component starts its own
  line;

- `width = 0, height = 0` on the widget, or it holds open a 960x500 box
  until its script runs and the page jumps;

- the `el` selector pointing at the host, which Vue compiles in place.
