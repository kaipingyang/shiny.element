# The default theme's CSS as the package ships it

Compiled by `tools/el-theme-css.R` with the bslib and sass in
`inst/el-theme/versions.json`; another version of either compiles other
CSS (another Bootstrap), and sass options other than bslib's default
(compressed) another output.

## Usage

``` r
.el_theme_shipped()
```

## Value

The CSS, one string; `NULL` where it does not apply.
