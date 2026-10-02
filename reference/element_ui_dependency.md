# Element UI Dependency

Element UI Dependency

## Usage

``` r
element_ui_dependency(offline = TRUE)
```

## Arguments

- offline:

  Serve Element UI from the copy bundled with this package (the default)
  instead of the unpkg CDN. The bundled files are byte-identical to the
  CDN's. A runtime CDN dependency leaves the page blank on an intranet,
  offline, or whenever unpkg is unreachable, so the local copy is the
  safer default; pass `FALSE` to trade that for a smaller deployment
  bundle.

## Value

An htmlDependency object for Element UI.

## Examples

``` r
element_ui_dependency()
#> List of 10
#>  $ name      : chr "element-ui"
#>  $ version   : chr "2.15.14"
#>  $ src       :List of 1
#>   ..$ file: chr "/home/runner/work/_temp/Library/shiny.element/element-ui"
#>  $ meta      : NULL
#>  $ script    : chr "index.js"
#>  $ stylesheet: chr [1:2] "theme-chalk/index.css" "theme-chalk/display.css"
#>  $ head      : chr "<style>.el-table .el-table__expanded-cell[class*=cell]{padding:20px 50px}</style>"
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi TRUE
#>  - attr(*, "class")= chr "html_dependency"
element_ui_dependency(offline = FALSE)
#> List of 10
#>  $ name      : chr "element-ui"
#>  $ version   : chr "2.15.14"
#>  $ src       :List of 1
#>   ..$ href: chr "https://unpkg.com/element-ui@2.15.14/lib/"
#>  $ meta      : NULL
#>  $ script    : chr "index.js"
#>  $ stylesheet: chr [1:2] "theme-chalk/index.css" "theme-chalk/display.css"
#>  $ head      : chr "<style>.el-table .el-table__expanded-cell[class*=cell]{padding:20px 50px}</style>"
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi TRUE
#>  - attr(*, "class")= chr "html_dependency"
```
