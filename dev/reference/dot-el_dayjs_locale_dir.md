# Where a Day.js locale file is

As
[`.el_locale_dir()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-el_locale_dir.md)
for Element Plus's: the locales used most are files, the rest are in one
archive, taken out into
[`tempdir()`](https://rdrr.io/r/base/tempfile.html) the first time one
is used.

## Usage

``` r
.el_dayjs_locale_dir(dj)
```

## Arguments

- dj:

  Day.js's locale name.

## Value

The directory holding `<dj>.js`, or `NULL`.
