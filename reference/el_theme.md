# Element UI's look, as a Bootstrap theme

A
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
carrying Element's own design tokens – its blue, its success, warning
and danger colours, its greys, borders, 4px corners, 14px type and font
stack – so that the Bootstrap side of a page, Shiny's own inputs and
outputs among it, matches the Element components next to it. It is
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)'s
default.

## Usage

``` r
el_theme(..., element = NULL, version = 5)
```

## Arguments

- ...:

  Overrides, passed on to
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html):
  its own arguments (`primary = "#7c3aed"`, `base_font =`), or any
  Bootstrap Sass variable by name (`"font-size-base" = "1rem"`). An
  override replaces the Element value of the same name.

- element:

  Element's own theme variables, as a named list –
  `list("border-radius-base" = "8px", "font-size-base" = "13px")` – by
  their names in theme-chalk's `common/var.scss`, without the `$--`.
  Element's stylesheet is built with them, as Element's theme tool
  builds a custom theme.

- version:

  Bootstrap major version. Default `5`.

## Value

A `bs_theme` object, for
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)'s
`theme` or any page that takes a bslib theme.

## Details

Element styles its components but not the page they sit on, and most of
its components set no font of their own: they inherit one. Under a
Bootswatch theme they inherit that theme's font instead of Element's,
while Element's sizes and colours stay – a mix of the two looks.

The values follow Element 2.15's `theme-chalk` variables:

|  |  |  |
|----|----|----|
| Bootstrap | Element | value |
| `primary` | `$--color-primary` | `#409EFF` |
| `success` | `$--color-success` | `#67C23A` |
| `warning` | `$--color-warning` | `#E6A23C` |
| `danger` | `$--color-danger` | `#F56C6C` |
| `info`, `secondary` | `$--color-info` | `#909399` |
| `fg` | `$--color-text-primary` | `#303133` |
| `border-color` | `$--border-color-base` | `#DCDFE6` |
| `border-radius` | `$--border-radius-base` | `4px` |
| `font-size-base` | `$--font-size-base` | `14px` |
| input and button padding | `$--input-height`, `$--button-padding-*` | `40px` tall |

`primary`, `success`, `warning`, `danger` and `info` reach Element's
components too, with the tints and shades Element derives from each, and
so does anything given to `element`:
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
builds Element's stylesheet for the theme. Brand colours alone are
recoloured in place, as Element's own theme picker does; anything more
compiles Element's Sass sources, bundled with the package, as its theme
tool does – about a second, once per theme and R session.

Element puts white text on all five of its colours, some of which fall
short of Bootstrap's default minimum contrast; left alone, Bootstrap
would switch those buttons to black text. `min-contrast-ratio` is
lowered so the text stays white, as Element has it. Pass
`"min-contrast-ratio" = 4.5` to put contrast first.

## Examples

``` r
el_theme()
#> /* Sass Bundle: _utilities, _root, _reboot, _type, _images, _containers, _grid, _tables, _forms, _buttons, _transitions, _dropdown, _button-group, _nav, _navbar, _card, _accordion, _breadcrumb, _pagination, _badge, _alert, _progress, _list-group, _close, _toasts, _modal, _tooltip, _popover, _carousel, _spinners, _offcanvas, _placeholders, _helpers, _api, bs3compat, builtin */
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_functions.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bslib-scss/functions.scss";
#> $font-size-base: 0.875rem !default;
#> $input-font-size: 0.875rem !default;
#> $input-color: #606266 !default;
#> $input-line-height: 1.5 !default;
#> $input-padding-y: 8.5px !default;
#> $input-padding-x: 15px !default;
#> $btn-font-size: 0.875rem !default;
#> $btn-line-height: 1 !default;
#> $btn-padding-y: 12px !default;
#> $btn-padding-x: 20px !default;
#> $border-color: #DCDFE6 !default;
#> $input-border-color: #DCDFE6 !default;
#> $input-focus-border-color: #409EFF !default;
#> $input-placeholder-color: #C0C4CC !default;
#> $text-muted: #909399 !default;
#> $border-radius: 4px !default;
#> $border-radius-sm: 3px !default;
#> $border-radius-lg: 4px !default;
#> $headings-font-weight: 500 !default;
#> $min-contrast-ratio: 2 !default;
#> $font-family-base: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif !default;
#> $primary: #409EFF !default;
#> $secondary: #909399 !default;
#> $success: #67C23A !default;
#> $info: #909399 !default;
#> $warning: #E6A23C !default;
#> $danger: #F56C6C !default;
#> $white: #FFFFFF !default;
#> $gray-100: #EAEAEB !default;
#> $gray-200: #D6D6D6 !default;
#> $gray-300: #C1C1C2 !default;
#> $gray-400: #ACADAD !default;
#> $gray-500: #989899 !default;
#> $gray-600: #838385 !default;
#> $gray-700: #6E6F70 !default;
#> $gray-800: #595A5C !default;
#> $gray-900: #454647 !default;
#> $black: #303133 !default;
#> $bslib-preset-type: builtin;
#> $bslib-preset-name: shiny;
#> $web-font-path: "font.css" !default;
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_variables.scss";
#> $enable-cssgrid: true !default;
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_defaults.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_variables.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_variables-dark.scss";
#> $bootstrap-version: 5;
#> $bslib-preset-name: null !default;
#> $bslib-preset-type: null !default;
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_maps.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_mixins.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_declarations.scss";
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_mixins.scss";
#> :root {
#> --bslib-bootstrap-version: #{$bootstrap-version};
#> --bslib-preset-name: #{$bslib-preset-name};
#> --bslib-preset-type: #{$bslib-preset-type};
#> }
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/mixins/_banner.scss";
#> @include bsBanner('')
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_utilities.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_root.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_reboot.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_type.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_images.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_containers.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_grid.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_tables.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_forms.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_buttons.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_transitions.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_dropdown.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_button-group.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_nav.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_navbar.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_card.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_accordion.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_breadcrumb.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_pagination.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_badge.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_alert.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_progress.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_list-group.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_close.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_toasts.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_modal.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_tooltip.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_popover.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_carousel.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_spinners.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_offcanvas.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_placeholders.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_helpers.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/utilities/_api.scss";
#> .table th[align=left] { text-align: left; }
#> .table th[align=right] { text-align: right; }
#> .table th[align=center] { text-align: center; }
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_rules.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bslib-scss/bslib.scss";
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_rules.scss";
#> /* *** */
#> 
#> Other Sass Bundle information:
#> List of 2
#>  $ html_deps       :List of 1
#>   ..$ :List of 10
#>   .. ..$ name      : chr "bs3compat"
#>   .. ..$ version   : chr "0.12.0"
#>   .. ..$ src       :List of 1
#>   .. .. ..$ file: chr "bs3compat/js"
#>   .. ..$ meta      : NULL
#>   .. ..$ script    : chr [1:3] "transition.js" "tabs.js" "bs3compat.js"
#>   .. ..$ stylesheet: NULL
#>   .. ..$ head      : NULL
#>   .. ..$ attachment: NULL
#>   .. ..$ package   : chr "bslib"
#>   .. ..$ all_files : logi TRUE
#>   .. ..- attr(*, "class")= chr "html_dependency"
#>  $ file_attachments: Named chr [1:3] "/home/runner/work/_temp/Library/bslib/lib/bs3/assets/fonts" "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/font.css" "/home/runner/work/_temp/Library/bslib/fonts"
#>   ..- attr(*, "names")= chr [1:3] "fonts" "font.css" "fonts"

# Element's look with another brand colour
el_theme(primary = "#7c3aed")
#> /* Sass Bundle: _utilities, _root, _reboot, _type, _images, _containers, _grid, _tables, _forms, _buttons, _transitions, _dropdown, _button-group, _nav, _navbar, _card, _accordion, _breadcrumb, _pagination, _badge, _alert, _progress, _list-group, _close, _toasts, _modal, _tooltip, _popover, _carousel, _spinners, _offcanvas, _placeholders, _helpers, _api, bs3compat, builtin */
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_functions.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bslib-scss/functions.scss";
#> $font-size-base: 0.875rem !default;
#> $input-font-size: 0.875rem !default;
#> $input-color: #606266 !default;
#> $input-line-height: 1.5 !default;
#> $input-padding-y: 8.5px !default;
#> $input-padding-x: 15px !default;
#> $btn-font-size: 0.875rem !default;
#> $btn-line-height: 1 !default;
#> $btn-padding-y: 12px !default;
#> $btn-padding-x: 20px !default;
#> $border-color: #DCDFE6 !default;
#> $input-border-color: #DCDFE6 !default;
#> $input-focus-border-color: #7c3aed !default;
#> $input-placeholder-color: #C0C4CC !default;
#> $text-muted: #909399 !default;
#> $border-radius: 4px !default;
#> $border-radius-sm: 3px !default;
#> $border-radius-lg: 4px !default;
#> $headings-font-weight: 500 !default;
#> $min-contrast-ratio: 2 !default;
#> $font-family-base: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif !default;
#> $primary: #7C3AED !default;
#> $secondary: #909399 !default;
#> $success: #67C23A !default;
#> $info: #909399 !default;
#> $warning: #E6A23C !default;
#> $danger: #F56C6C !default;
#> $white: #FFFFFF !default;
#> $gray-100: #EAEAEB !default;
#> $gray-200: #D6D6D6 !default;
#> $gray-300: #C1C1C2 !default;
#> $gray-400: #ACADAD !default;
#> $gray-500: #989899 !default;
#> $gray-600: #838385 !default;
#> $gray-700: #6E6F70 !default;
#> $gray-800: #595A5C !default;
#> $gray-900: #454647 !default;
#> $black: #303133 !default;
#> $bslib-preset-type: builtin;
#> $bslib-preset-name: shiny;
#> $web-font-path: "font.css" !default;
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_variables.scss";
#> $enable-cssgrid: true !default;
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_defaults.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_variables.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_variables-dark.scss";
#> $bootstrap-version: 5;
#> $bslib-preset-name: null !default;
#> $bslib-preset-type: null !default;
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_maps.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_mixins.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_declarations.scss";
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_mixins.scss";
#> :root {
#> --bslib-bootstrap-version: #{$bootstrap-version};
#> --bslib-preset-name: #{$bslib-preset-name};
#> --bslib-preset-type: #{$bslib-preset-type};
#> }
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/mixins/_banner.scss";
#> @include bsBanner('')
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_utilities.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_root.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_reboot.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_type.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_images.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_containers.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_grid.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_tables.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_forms.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_buttons.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_transitions.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_dropdown.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_button-group.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_nav.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_navbar.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_card.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_accordion.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_breadcrumb.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_pagination.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_badge.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_alert.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_progress.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_list-group.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_close.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_toasts.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_modal.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_tooltip.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_popover.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_carousel.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_spinners.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_offcanvas.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_placeholders.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_helpers.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/utilities/_api.scss";
#> .table th[align=left] { text-align: left; }
#> .table th[align=right] { text-align: right; }
#> .table th[align=center] { text-align: center; }
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_rules.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bslib-scss/bslib.scss";
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_rules.scss";
#> /* *** */
#> 
#> Other Sass Bundle information:
#> List of 2
#>  $ html_deps       :List of 1
#>   ..$ :List of 10
#>   .. ..$ name      : chr "bs3compat"
#>   .. ..$ version   : chr "0.12.0"
#>   .. ..$ src       :List of 1
#>   .. .. ..$ file: chr "bs3compat/js"
#>   .. ..$ meta      : NULL
#>   .. ..$ script    : chr [1:3] "transition.js" "tabs.js" "bs3compat.js"
#>   .. ..$ stylesheet: NULL
#>   .. ..$ head      : NULL
#>   .. ..$ attachment: NULL
#>   .. ..$ package   : chr "bslib"
#>   .. ..$ all_files : logi TRUE
#>   .. ..- attr(*, "class")= chr "html_dependency"
#>  $ file_attachments: Named chr [1:3] "/home/runner/work/_temp/Library/bslib/lib/bs3/assets/fonts" "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/font.css" "/home/runner/work/_temp/Library/bslib/fonts"
#>   ..- attr(*, "names")= chr [1:3] "fonts" "font.css" "fonts"

# Rounder and smaller, all through Element
el_theme(element = list("border-radius-base" = "10px", "font-size-base" = "13px"))
#> /* Sass Bundle: _utilities, _root, _reboot, _type, _images, _containers, _grid, _tables, _forms, _buttons, _transitions, _dropdown, _button-group, _nav, _navbar, _card, _accordion, _breadcrumb, _pagination, _badge, _alert, _progress, _list-group, _close, _toasts, _modal, _tooltip, _popover, _carousel, _spinners, _offcanvas, _placeholders, _helpers, _api, bs3compat, builtin */
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_functions.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bslib-scss/functions.scss";
#> $font-size-base: 0.875rem !default;
#> $input-font-size: 0.875rem !default;
#> $input-color: #606266 !default;
#> $input-line-height: 1.5 !default;
#> $input-padding-y: 8.5px !default;
#> $input-padding-x: 15px !default;
#> $btn-font-size: 0.875rem !default;
#> $btn-line-height: 1 !default;
#> $btn-padding-y: 12px !default;
#> $btn-padding-x: 20px !default;
#> $border-color: #DCDFE6 !default;
#> $input-border-color: #DCDFE6 !default;
#> $input-focus-border-color: #409EFF !default;
#> $input-placeholder-color: #C0C4CC !default;
#> $text-muted: #909399 !default;
#> $border-radius: 4px !default;
#> $border-radius-sm: 3px !default;
#> $border-radius-lg: 4px !default;
#> $headings-font-weight: 500 !default;
#> $min-contrast-ratio: 2 !default;
#> $font-family-base: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif !default;
#> $primary: #409EFF !default;
#> $secondary: #909399 !default;
#> $success: #67C23A !default;
#> $info: #909399 !default;
#> $warning: #E6A23C !default;
#> $danger: #F56C6C !default;
#> $white: #FFFFFF !default;
#> $gray-100: #EAEAEB !default;
#> $gray-200: #D6D6D6 !default;
#> $gray-300: #C1C1C2 !default;
#> $gray-400: #ACADAD !default;
#> $gray-500: #989899 !default;
#> $gray-600: #838385 !default;
#> $gray-700: #6E6F70 !default;
#> $gray-800: #595A5C !default;
#> $gray-900: #454647 !default;
#> $black: #303133 !default;
#> $bslib-preset-type: builtin;
#> $bslib-preset-name: shiny;
#> $web-font-path: "font.css" !default;
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_variables.scss";
#> $enable-cssgrid: true !default;
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_defaults.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_variables.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_variables-dark.scss";
#> $bootstrap-version: 5;
#> $bslib-preset-name: null !default;
#> $bslib-preset-type: null !default;
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_maps.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_mixins.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_declarations.scss";
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_mixins.scss";
#> :root {
#> --bslib-bootstrap-version: #{$bootstrap-version};
#> --bslib-preset-name: #{$bslib-preset-name};
#> --bslib-preset-type: #{$bslib-preset-type};
#> }
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/mixins/_banner.scss";
#> @include bsBanner('')
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_utilities.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_root.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_reboot.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_type.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_images.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_containers.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_grid.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_tables.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_forms.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_buttons.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_transitions.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_dropdown.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_button-group.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_nav.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_navbar.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_card.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_accordion.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_breadcrumb.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_pagination.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_badge.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_alert.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_progress.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_list-group.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_close.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_toasts.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_modal.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_tooltip.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_popover.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_carousel.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_spinners.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_offcanvas.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_placeholders.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/_helpers.scss";
#> @import "/home/runner/work/_temp/Library/bslib/lib/bs5/scss/utilities/_api.scss";
#> .table th[align=left] { text-align: left; }
#> .table th[align=right] { text-align: right; }
#> .table th[align=center] { text-align: center; }
#> @import "/home/runner/work/_temp/Library/bslib/bs3compat/_rules.scss";
#> @import "/home/runner/work/_temp/Library/bslib/bslib-scss/bslib.scss";
#> @import "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/_rules.scss";
#> /* *** */
#> 
#> Other Sass Bundle information:
#> List of 2
#>  $ html_deps       :List of 1
#>   ..$ :List of 10
#>   .. ..$ name      : chr "bs3compat"
#>   .. ..$ version   : chr "0.12.0"
#>   .. ..$ src       :List of 1
#>   .. .. ..$ file: chr "bs3compat/js"
#>   .. ..$ meta      : NULL
#>   .. ..$ script    : chr [1:3] "transition.js" "tabs.js" "bs3compat.js"
#>   .. ..$ stylesheet: NULL
#>   .. ..$ head      : NULL
#>   .. ..$ attachment: NULL
#>   .. ..$ package   : chr "bslib"
#>   .. ..$ all_files : logi TRUE
#>   .. ..- attr(*, "class")= chr "html_dependency"
#>  $ file_attachments: Named chr [1:3] "/home/runner/work/_temp/Library/bslib/lib/bs3/assets/fonts" "/home/runner/work/_temp/Library/bslib/builtin/bs5/shiny/font.css" "/home/runner/work/_temp/Library/bslib/fonts"
#>   ..- attr(*, "names")= chr [1:3] "fonts" "font.css" "fonts"

if (interactive()) {
  el_page(theme = el_theme(), shiny::actionButton("go", "Shiny's own button"))
}
```
