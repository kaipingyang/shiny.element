# Load All Element-UI Dependencies Convenience function to load Vue, Element-UI, and layout CSS dependencies. Use this when you want to use Element-UI components in non-el_page layouts (e.g., bslib::page_sidebar, shiny::navbarPage).

Load All Element-UI Dependencies

Convenience function to load Vue, Element-UI, and layout CSS
dependencies. Use this when you want to use Element-UI components in
non-el_page layouts (e.g., bslib::page_sidebar, shiny::navbarPage).

## Usage

``` r
use_element(theme = el_layout_css_dependency())
```

## Arguments

- theme:

  CSS dependency function or list (optional, default is
  el_layout_css_dependency())

## Value

A list of htmlDependency objects

## Examples

``` r
 
if (FALSE) { # \dontrun{  
library(bslib)  
ui <- page_sidebar(  
  use_element(),  
  el_button("btn1", "Click me")  
)  
} # }  
```
