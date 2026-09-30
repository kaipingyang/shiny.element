# Feedback Handler Dependency

Loads the JavaScript handlers for
[`el_notification()`](https://kaipingyang.github.io/shiny.element/reference/el_notification.md)
and
[`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md).
Automatically included by
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
and
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md).

## Usage

``` r
el_feedback_dependency()
```

## Value

An htmlDependency object.

## Examples

``` r
el_feedback_dependency()
#> List of 10
#>  $ name      : chr "el-feedback-handler"
#>  $ version   : chr "1.0.0"
#>  $ src       :List of 1
#>   ..$ file: chr "/home/runner/work/_temp/Library/shiny.element/js"
#>  $ meta      : NULL
#>  $ script    : chr "el-feedback-handler.js"
#>  $ stylesheet: NULL
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi TRUE
#>  - attr(*, "class")= chr "html_dependency"
```
