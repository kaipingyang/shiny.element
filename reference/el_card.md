# Element UI Card

A card container with optional header and body. Supports `always`,
`hover`, and `never` shadow modes.

## Usage

``` r
el_card(..., header = NULL, body_style = NULL, shadow = "always")
```

## Arguments

- ...:

  Content placed inside the card body.

- header:

  Header content (string or tag). `NULL` for no header.

- body_style:

  Inline CSS string for the card body. `NULL` for default.

- shadow:

  Shadow display trigger: `"always"` (default), `"hover"`, or `"never"`.

## Value

An `htmltools` tag.

## Examples

``` r
el_card(shiny::tags$p("Card body text."), header = "My Card")
#> <div class="el-card is-always-shadow">
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
