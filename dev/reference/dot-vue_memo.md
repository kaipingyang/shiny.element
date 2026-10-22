# A value made once per R session

Every component carries its dependencies, and making them looks up the
package's files on disk –
[`system.file()`](https://rdrr.io/r/base/system.file.html),
[`find.package()`](https://rdrr.io/r/base/find.package.html) – each
time: some 40% of building a component. They are values that do not
change while R runs, so each is made once and kept here.

## Usage

``` r
.vue_memo(key, make)
```

## Arguments

- key:

  What it is, with whatever it depends on (`dev`, `offline`).

- make:

  A function making it.

## Value

The value.
