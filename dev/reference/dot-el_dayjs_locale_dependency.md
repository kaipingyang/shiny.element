# Day.js's locale file, and Day.js where the file looks for it

Day.js comes inside Element Plus's build, as `ElementPlus.dayjs`; a
locale file of Day.js's registers itself with a global `dayjs`, given
here first.

## Usage

``` r
.el_dayjs_locale_dependency(code)
```

## Arguments

- code:

  An Element Plus locale code, lower case.

## Value

A list of htmlDependency objects; empty when Day.js has none.
