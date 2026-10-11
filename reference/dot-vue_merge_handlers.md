# One event's handlers given more than once on a tag, as one

A component's own handler of an event – `@change="handleChange"` – and
the one forwarding it or the user's `on` can land on its tag together:
htmltools would join them into one attribute, `"handleChange svOn1"`,
which Vue cannot compile, and the component would not mount.

## Usage

``` r
.vue_merge_handlers(attribs)
```

## Arguments

- attribs:

  A tag's attributes.

## Value

The attributes, each `@<event>` once.
