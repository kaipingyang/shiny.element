# Take a component apart so it can be rendered inside another

A component that wraps markup – tooltip, popover, popconfirm – compiles
that markup into its own Vue instance. Vue builds fresh DOM when it
compiles, and Element's tooltip keeps only the first node it is given,
so a component dropped in whole loses its mount point and its instance:
the inner component disappears, its inputs never report, and nothing is
logged.

## Usage

``` r
.el_absorb(ui)
```

## Arguments

- ui:

  Output of
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md),
  or plain markup.

## Value

A list with `markup`, the Vue options to merge (`data`, `methods`,
`watch`, `mounted`, `computed`), and `dependencies`. Plain markup comes
back as `markup` with everything else empty.

## Details

Rather than refusing that, the inner component is taken apart and folded
into the outer one, so the two become a single Vue instance holding both
sets of markup, data and methods. Everything then works as it would
standalone – including `Shiny.setInputValue()` calls, which name their
ids outright.

The wrapper's own fields are prefixed, so nothing it declares can
collide with the absorbed component's.
