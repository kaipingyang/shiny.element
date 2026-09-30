# Turn a snake_case name into camelCase

Arguments are snake_case throughout this package, while Vue reads its
props in camelCase. Where a user writes the name themselves – a key in a
column definition, say – both spellings have to work, or the snake_case
one sits in the object doing nothing.

## Usage

``` r
.el_camel_case(x)
```

## Arguments

- x:

  A name.

## Value

The same name in camelCase.
