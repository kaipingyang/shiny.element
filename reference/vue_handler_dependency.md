# Vue Handler Dependency

Registers custom JavaScript handlers for Shiny-to-Vue communication.
This dependency loads `vue_handlers.js`, which enables R to update Vue
component fields or entire data objects via `update_vue_component` and
`update_vue_data` custom messages. It should be included in the UI
(typically via
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md))
to ensure all Vue update handlers are available.

## Usage

``` r
vue_handler_dependency()
```

## Value

An htmlDependency object for vue_handlers.js
