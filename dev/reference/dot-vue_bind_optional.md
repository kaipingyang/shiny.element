# A tag's attributes with a group of optional props bound

One `v-bind` per element: an attribute list that has one already – a
user's root tag in a component's markup – gets one merged object, the
existing one spread last so that it wins. The binding goes first among
the attributes, so an explicit binding of the same prop after it wins as
well (Vue 3 merges `v-bind` and attributes in source order).

## Usage

``` r
.vue_bind_optional(attrs, group)
```

## Arguments

- attrs:

  A tag's attributes, a named list.

- group:

  The group's name, as given to
  [`.vue_optional_props()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_optional_props.md).

## Value

The attributes.
