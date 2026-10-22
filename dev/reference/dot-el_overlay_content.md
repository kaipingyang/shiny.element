# An overlay's content, kept for re-creation when it is destroyed on close

With `destroy_on_close`, the content lives in an inert `<template>` and
is instantiated each time the overlay opens – so its inputs start from
their initial values – then unbound and removed when it closes. Shown
from the start, a live copy is rendered as well.

## Usage

``` r
.el_overlay_content(content, destroy, visible)
```

## Arguments

- content:

  The overlay's content.

- destroy:

  Whether it is destroyed on close.

- visible:

  Whether the overlay starts open.

## Value

Markup.
