# Shape choices for a control's option tag

`el-option` takes the display text as its `label` attribute, while
`el-radio` and `el-checkbox` take the display text as their default
slot. Normalising here keeps one template able to render all three.

## Usage

``` r
.el_form_options(choices, option_tag)
```

## Arguments

- choices:

  Anything
  [`.vue_choices()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_choices.md)
  accepts.

- option_tag:

  The child tag this control uses.

## Value

A list of `list(label=, value=, text=)` items, `label` only for
`el-option`.
