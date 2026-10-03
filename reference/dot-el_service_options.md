# A service's options, as Element Plus names them

The arguments a call to a service – message, notification, message box,
loading – was given, in camelCase, without those left `NULL`. Icons are
turned into Element Plus's names;
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
functions travel as source and are listed in `.functions`, for the
browser to turn back into functions.

## Usage

``` r
.el_service_options(args, skip)
```

## Arguments

- args:

  The calling function's arguments, `as.list(environment())`.

- skip:

  Names that are not options.

## Value

A named list.
