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

## Examples

``` r
vue_handler_dependency()
#> List of 10
#>  $ name      : chr "vue-handlers"
#>  $ version   : chr "1.0.0"
#>  $ src       :List of 1
#>   ..$ file: chr "/home/runner/work/_temp/Library/shiny.element/js"
#>  $ meta      : NULL
#>  $ script    : chr "vue-handlers.js"
#>  $ stylesheet: NULL
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi TRUE
#>  - attr(*, "class")= chr "html_dependency"
```
