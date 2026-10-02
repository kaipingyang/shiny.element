# Compile Element's Sass with variables set

Element's variables are all `!default`, so setting them before its
sources are read is enough. Two of its mixins are rewritten in the
bundled copy – they built a selector list with a trailing comma, which
crashes the libsass the sass package uses; the selectors they produce
are unchanged.

## Usage

``` r
.el_compile(vars)
```

## Arguments

- vars:

  Element variables, names without `$--`.

## Value

The stylesheet, as text.
