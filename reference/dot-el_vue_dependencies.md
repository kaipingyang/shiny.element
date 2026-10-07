# The scripts every Vue component needs

jQuery, Vue, the generic bridge (`shiny-vue.js`: mounting, the Shiny
input binding, serialising values, forwarding events), Element Plus and
Element's side of the bridge (`el-events.js`), in load order. Every
component carries Element Plus, as Shiny's inputs carry selectize and
htmlwidgets their libraries, so it works on any page; htmltools keeps
one copy, the first, so a page that loads Element from the CDN
(`use_element(offline = FALSE)` before its components) keeps that one.
What belongs to the page – its theme, locale, global config, the
feedback handlers – stays with
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
and
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md).

## Usage

``` r
.el_vue_dependencies()
```

## Value

A list of htmlDependency objects.
