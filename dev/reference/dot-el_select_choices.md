# Split a select's choices into loose options and option groups

Groups are written the way
[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)
takes them – a named list whose elements are vectors,
`list(East = c("NY", "NJ"))` – or as
`list(label =, disabled =, options =)` when a group needs its own
`disabled`. Anything else is an ungrouped choice.

## Usage

``` r
.el_select_choices(choices)
```

## Arguments

- choices:

  The choices as given.

## Value

A list of `options` and `groups`.
