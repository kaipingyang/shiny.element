# Rename a component's ref in its own functions

Rename a component's ref in its own functions

## Usage

``` r
.el_rename_ref(options, old, new)
```

## Arguments

- options:

  A component's Vue options.

- old, new:

  The ref's name, and its new one.

## Value

The options, `$refs.<old>` read as `$refs.<new>` throughout.
