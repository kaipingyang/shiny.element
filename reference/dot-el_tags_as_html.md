# Tags in Vue data, as the HTML they stand for

A field of a component's data travels as JSON, where a tag – an item's
`content = tags$b("x")`, a column's header – would arrive as its
serialised object, and show as that, or as `[object Object]`. Every tag
and tag list found in the data is rendered to its HTML string instead,
which is what a `v-html` field reads; a field shown as text shows the
markup rather than an object.

## Usage

``` r
.el_tags_as_html(x)
```

## Arguments

- x:

  A list of options or an update message.

## Value

`x`, with tags replaced by strings.
