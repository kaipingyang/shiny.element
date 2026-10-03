# Turn named slot contents into markup, absorbing any components

Turn named slot contents into markup, absorbing any components

## Usage

``` r
.el_slot_markup(slots, taken = character(0))
```

## Arguments

- slots:

  Named list of slot contents.

- taken:

  Field and method names the component itself already uses; an absorbed
  component declaring one of them is renamed.

## Value

A list of `markup` plus the Vue options its components contribute.
