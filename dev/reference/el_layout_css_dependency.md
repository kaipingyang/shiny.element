# Element Plus Layout CSS Dependency

Provides default CSS styles for Element-UI layout and grid components,
including el-container, el-header, el-main, el-footer, el-aside, el-row,
el-col, etc. This dependency is automatically attached by el_page() for
consistent layout appearance.

## Usage

``` r
el_layout_css_dependency()
```

## Value

An htmlDependency object.

## Examples

``` r
el_layout_css_dependency()
#> List of 10
#>  $ name      : chr "el-layout-css"
#>  $ version   : chr "1.0.0"
#>  $ src       :List of 1
#>   ..$ file: chr "css"
#>  $ meta      : NULL
#>  $ script    : NULL
#>  $ stylesheet: chr "el-layout.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : chr "shiny.element"
#>  $ all_files : logi TRUE
#>  - attr(*, "class")= chr "html_dependency"
```
