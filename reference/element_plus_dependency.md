# Element Plus Dependency

Element Plus's script and stylesheets – its components, its dark mode
variables and its display classes (`hidden-xs-only`, ...) – and its
icons, which are components registered on every app by name.

## Usage

``` r
element_plus_dependency(offline = TRUE)
```

## Arguments

- offline:

  Serve Element Plus from the copy bundled with this package (the
  default) instead of the unpkg CDN. The bundled files are
  byte-identical to the CDN's. A runtime CDN dependency leaves the page
  blank on an intranet, offline, or whenever unpkg is unreachable, so
  the local copy is the safer default; pass `FALSE` to trade that for a
  smaller deployment bundle.

## Value

A list of htmlDependency objects.

## Examples

``` r
element_plus_dependency()
#> [[1]]
#> List of 10
#>  $ name      : chr "element-plus"
#>  $ version   : chr "2.14.7"
#>  $ src       :List of 1
#>   ..$ file: chr "/home/runner/work/_temp/Library/shiny.element/element-plus"
#>  $ meta      : NULL
#>  $ script    : chr "dist/index.full.min.js"
#>  $ stylesheet: chr [1:3] "theme-chalk/index.css" "theme-chalk/dark/css-vars.css" "theme-chalk/display.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
#> 
#> [[2]]
#> List of 10
#>  $ name      : chr "element-plus-icons"
#>  $ version   : chr "2.3.2"
#>  $ src       :List of 1
#>   ..$ file: chr "/home/runner/work/_temp/Library/shiny.element/element-plus"
#>  $ meta      : NULL
#>  $ script    : chr "icons-vue.iife.min.js"
#>  $ stylesheet: NULL
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
#> 
element_plus_dependency(offline = FALSE)
#> [[1]]
#> List of 10
#>  $ name      : chr "element-plus"
#>  $ version   : chr "2.14.7"
#>  $ src       :List of 1
#>   ..$ href: chr "https://unpkg.com/element-plus@2.14.7/"
#>  $ meta      : NULL
#>  $ script    : chr "dist/index.full.min.js"
#>  $ stylesheet: chr [1:3] "theme-chalk/index.css" "theme-chalk/dark/css-vars.css" "theme-chalk/display.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
#> 
#> [[2]]
#> List of 10
#>  $ name      : chr "element-plus-icons"
#>  $ version   : chr "2.3.2"
#>  $ src       :List of 1
#>   ..$ href: chr "https://unpkg.com/@element-plus/icons-vue@2.3.2/dist/"
#>  $ meta      : NULL
#>  $ script    : chr "index.iife.min.js"
#>  $ stylesheet: NULL
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
#> 
```
