# Element Plus Card

A card container with optional header and body. Supports `always`,
`hover`, and `never` shadow modes.

## Usage

``` r
el_card(
  ...,
  header = NULL,
  body_style = NULL,
  shadow = NULL,
  footer = NULL,
  header_class = NULL,
  body_class = NULL,
  footer_class = NULL,
  class = NULL,
  style = NULL
)
```

## Arguments

- ...:

  Content placed inside the card body.

- header:

  Header content (string or tag). `NULL` for no header.

- body_style:

  CSS for the card body, a string or a named list. `NULL` for default.

- shadow:

  Shadow display trigger: `"always"`, `"hover"` or `"never"`. `NULL`,
  the default, is Element's `"always"`, or a config provider's
  [el_config_provider(card
  =)](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md).

- footer:

  Footer content (string or tag). `NULL` for no footer.

- header_class, body_class, footer_class:

  Extra class names for the header, the body and the footer.

- class, style:

  Extra classes and inline style on the card itself, as Element passes
  them to its root.

## Value

An `htmltools` tag.

## Examples

``` r
el_card(shiny::tags$p("Card body text."), header = "My Card")
#> <div class="el-card is-always-shadow" data-el-shadow-default="true">
#>   <div class="el-card__header">My Card</div>
#>   <div class="el-card__body">
#>     <p>Card body text.</p>
#>   </div>
#> </div>
el_card(shiny::tags$p("No shadow."), shadow = "never")
#> <div class="el-card is-never-shadow">
#>   <div class="el-card__body">
#>     <p>No shadow.</p>
#>   </div>
#> </div>
```
