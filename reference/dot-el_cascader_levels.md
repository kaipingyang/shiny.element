# Each level of a cascader's path as an input of its own

A watcher of the value, run at once: it sets each level's input on load
– once Shiny is connected – and whenever the value changes, whoever
changes it. A Vue event would miss the value given at first and the one
[`update_el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md)
sets, which Element emits nothing for.

## Usage

``` r
.el_cascader_levels(level_inputs, props)
```

## Arguments

- level_inputs:

  Input ids, one per level, or `NULL`.

- props:

  The cascader's `props`.

## Value

A `watch` list for
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md),
or `NULL`.
