# Where a locale's file is

The locales used most are files in `dist/locale`; the rest are packed in
`dist/locale/more.tar.gz`, which keeps the installed package small – 56
files of 4KB each take far more room on disk than their bytes – and one
is taken out into the session's temporary directory the first time it is
asked for.

## Usage

``` r
.el_locale_dir(code)
```

## Arguments

- code:

  A locale code, lower case: `"zh-cn"`.

## Value

The directory holding `<code>.min.js`, or `NULL` for a locale Element
Plus does not ship.
