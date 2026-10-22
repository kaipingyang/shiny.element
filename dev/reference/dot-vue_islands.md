# Shiny UI in a template, taken out of it: islands

Vue compiles a template and owns the elements it draws: it drops
`<script>`s, and re-creates what `v-if` and `v-for` show, so a Shiny
input in a template loses its binding when Vue draws it again, an
htmlwidget its data, a component of its own (a host) its template. Such
UI is taken out: rendered beside the template, as Shiny renders it, in a
hidden holder, and the template gets `<shiny-island name="k">` in its
place, which moves the UI in while Vue shows it and back out –
suspended, its state kept – when Vue removes it. Scripts and styles
found loose in the template go to the holder too.

## Usage

``` r
.vue_islands(template, components = TRUE)
```

## Arguments

- template:

  A tag, or a list of them.

- components:

  Whether components of their own (hosts) and tags marked
  `data-shiny-island` are islands too. A component library that folds
  its components into one another, and places its containers itself,
  leaves them in the template: `FALSE`.

## Value

A list: `template`, with placeholders; `holder`, a tag or `NULL`.

## Details

An island is a tag with a Shiny input's, output's or htmlwidget's class,
a component of its own (`data-shiny-vue`), a
[`conditionalPanel()`](https://rdrr.io/pkg/shiny/man/conditionalPanel.html)
(`data-display-if`), or a tag marked `data-shiny-island`.
