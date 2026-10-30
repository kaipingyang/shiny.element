# Directives in a template, as the attributes they stand for

Run on every template before it is drawn
([`.vue_islands()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_islands.md),
`.vue_template()`,
[`.vue_tags_as_html()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_tags_as_html.md)):
a
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md),
[`v_model()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
or
[`v_on()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_on.md)
as an attribute's value gives the attribute its prefix – `:`,
`v-model:`, `@` – and a directive given unnamed becomes its attributes.
Nothing else is touched.

## Usage

``` r
.vue_directives(x)
```

## Arguments

- x:

  A tag, a tag list, or anything else (returned as it is).

## Value

`x`, its directives as attributes.
