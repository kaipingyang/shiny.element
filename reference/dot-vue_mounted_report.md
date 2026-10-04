# A mounted hook reporting fields as Shiny inputs

Sends each field once the socket is connected (a send before is
dropped), and again after every update (`_svReport`), as Shiny's own
`update*Input()` reports the new value.

## Usage

``` r
.vue_mounted_report(bindings)
```

## Arguments

- bindings:

  `c(<inputId> = "<field or expression>")`.

## Value

A [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
function, with the bindings as its `vue_report` attribute.
