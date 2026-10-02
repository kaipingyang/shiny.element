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
  id = NULL,
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

- id:

  Give the link an id and it reports its clicks, as
  [`shiny::actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  does: `input$<id>` counts them, 0 on load, and
  [`update_el_link()`](https://kaipingyang.github.io/shiny.element/reference/update_el_link.md)
  changes it. Without one it is a plain link.

- ...:

  Additional HTML attributes passed to the `<a>` tag (a plain link
  only).

## Value

An `htmltools` `<a>` tag, or with an `id` a Shiny UI element.

## Shiny inputs

With an `id`, `input$<id>` – the number of clicks, as
[`shiny::actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
reports it.

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

# An action link: input$more counts its clicks
el_link("Show more", id = "more", type = "primary")
#> <div id="more" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="more_container" style="display: contents">
#>   <el-link :href="href === null ? undefined : href" :type="type" :underline="underline" :disabled="disabled" :icon="icon === null ? undefined : icon" @click="handleClick">{{ text }}</el-link>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"text":"Show more","href":null,"type":"primary","underline":true,"disabled":false,"icon":null,"count":0},"methods":{"handleClick":"function() { if (this.disabled) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","evals":["options.methods.handleClick"]}</script>
#> </div>
```
