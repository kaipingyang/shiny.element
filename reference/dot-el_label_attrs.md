# Tie a component's Element tag to its label

A component whose Element tag hands an `id` on to a native input – an
input, a select, a picker – is labelled with `for`; any other, with
`aria-labelledby` on its root.

## Usage

``` r
.el_label_attrs(attrs, id, label, native = FALSE)
```

## Arguments

- attrs:

  The Element tag's attributes.

- id:

  The component's id.

- label:

  The label; nothing is added when it is `NULL`.

- native:

  Whether the tag passes `id` to a native input.

## Value

The attributes, with the tie added.
