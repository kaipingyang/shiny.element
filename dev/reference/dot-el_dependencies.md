# What every component needs

One set for every component, as bslib's components share one: the Vue
host's (jQuery, Vue core, the bridge), Element Plus and Element's side
of the bridge, in load order – whether the component is a Vue app
(input, select, table) or markup with Element's classes (tabs, dialog,
card, row). Every component carries them, as Shiny's inputs carry
selectize and htmlwidgets their libraries, so it works on any page;
htmltools keeps one copy, the first, so a page that loads Element from
the CDN (`use_element(offline = FALSE)` before its components) keeps
that one. What belongs to the page – its theme, locale, global config,
the feedback handlers – stays with
[`use_element()`](https://kaipingyang.github.io/shiny.element/dev/reference/use_element.md)
and
[`el_page()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_page.md).
Made once per R session and mode.

## Usage

``` r
.el_dependencies()
```

## Value

A list of htmlDependency objects.
