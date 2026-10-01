# Take an argument given under either of its two names

The choice components take Shiny's names, `choices` and `selected`, and
Element's, `options` and `value`. Given both, the two must agree:
letting one silently win, as `colour <- color %||% colour` does, hides a
call that says two different things.

## Usage

``` r
.el_alias(main, alias, main_name, alias_name)
```

## Arguments

- main, alias:

  The argument's values under each name.

- main_name, alias_name:

  The names, for the error message.

## Value

Whichever was given; `main` when neither was.
