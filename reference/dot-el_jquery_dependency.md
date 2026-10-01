# jQuery, for the package's scripts

Every handler and binding script is written against jQuery, which a
Shiny page always has. A page without Shiny – R Markdown, Quarto, the
package's own website – may not, and the scripts stopped at their first
line. The dependency is jquerylib's, under the name Shiny's own uses, so
a Shiny page still loads one copy, the newer.

## Usage

``` r
.el_jquery_dependency()
```

## Value

An htmlDependency object.
