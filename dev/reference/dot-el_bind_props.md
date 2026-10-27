# Bind optional props on their tag, as one group

The group is named after the tag (`el-select` -\> `select`), or the next
free name when a component folded into the same instance has taken it.

## Usage

``` r
.el_bind_props(tag, props, taken = character())
```

## Arguments

- tag:

  The Element tag the props belong to.

- props:

  Output of
  [`.el_props()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-el_props.md).

- taken:

  Group names already used in the instance.

## Value

`list(tag =, props =)`: the tag with its `v-bind`, and the props with
`groups` (`<group> = <entries>`) in place of `entries`.
