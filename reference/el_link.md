# Element UI Link

A styled hyperlink that follows Element UI's design language.

## Usage

``` r
el_link(
  label = "Link",
  href = NULL,
  type = "default",
  underline = TRUE,
  disabled = FALSE,
  icon = NULL,
  ...
)
```

## Arguments

- label:

  Link text. Accepts a string or HTML tag.

- href:

  URL target. `NULL` for a non-navigating link.

- type:

  Link colour type: `"default"` (default), `"primary"`, `"success"`,
  `"warning"`, `"danger"`, `"info"`.

- underline:

  Whether to underline on hover. Default `TRUE`.

- disabled:

  Whether the link is disabled. Default `FALSE`.

- icon:

  Icon class string (e.g. `"el-icon-edit"`). Placed before the label.
  `NULL` for none.

- ...:

  Additional HTML attributes passed to the `<a>` tag.

## Value

An `htmltools` `<a>` tag.

## Examples

``` r
el_link("Visit GitHub", href = "https://github.com", type = "primary")
#> <a class="el-link el-link--primary is-underline" href="https://github.com">
#>   <span class="el-link--inner">Visit GitHub</span>
#> </a>
el_link("Disabled", disabled = TRUE)
#> <a class="el-link el-link--default is-disabled">
#>   <span class="el-link--inner">Disabled</span>
#> </a>
el_link("With icon", icon = "el-icon-edit", type = "success")
#> <a class="el-link el-link--success is-underline">
#>   <i class="el-icon-edit"></i>
#>   <span class="el-link--inner">With icon</span>
#> </a>
```
