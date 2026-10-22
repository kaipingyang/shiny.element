# The page's loading mask

Element's own full-screen loading mask – its markup, drawn by its
stylesheet in the page's head, so it shows before any script runs and
takes the page's theme and dark mode – and a script removing it once
every component host on the page has mounted (`[data-shiny-vue-root]`
for each `[data-shiny-vue]`, as the bridge leaves them) and Shiny is
connected, or after 10 seconds. A page drawn later, by
[`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), has
its components drawn as it arrives: its mask is never shown (a rule
hides it inside an output, as Shiny runs the script there with no
`document.currentScript` to find it by) and is removed.

## Usage

``` r
.el_page_loading()
```

## Value

A tag list.
