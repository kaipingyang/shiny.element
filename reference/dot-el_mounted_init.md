# Build a Vue `mounted` hook that reports initial values to Shiny

Element UI components only emit `@change` on user interaction, and Vue
`watch` handlers do not fire on mount. Without this hook the
corresponding `input$<id>` stays `NULL` until the user first touches the
widget, unlike standard Shiny inputs which report their value
immediately.

## Usage

``` r
.el_mounted_init(bindings)
```

## Arguments

- bindings:

  Named character vector. Names are fully namespaced Shiny input ids,
  values are Vue data field names read off the instance, e.g.
  `c(my_slider = "value")`.

## Value

An [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
object for the Vue `mounted` option.

## Details

The send is deferred until `shiny:connected` when the socket is not up
yet: htmlwidgets' `renderValue()` runs before the Shiny WebSocket is
established, and `Shiny.setInputValue()` called then is silently
dropped.
