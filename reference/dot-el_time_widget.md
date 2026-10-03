# Build either time picker

Build either time picker

## Usage

``` r
.el_time_widget(tag, ns_id, init, fields, events, width, slots, form_item)
```

## Arguments

- tag:

  `"el-time-picker"` or `"el-time-select"`.

- ns_id:

  The namespaced id.

- init:

  The initial value.

- fields:

  The props, by their R names, for
  [`.el_props()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_props.md).

- events:

  Events forwarded as `input$<id>_<event>`.

- width, slots:

  As for
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- form_item:

  The label and message arguments, for
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

## Value

A Shiny UI element.
