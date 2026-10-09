# Element Plus Link

A styled hyperlink that follows Element Plus's design language.

## Usage

``` r
el_link(
  label = "Link",
  href = NULL,
  type = NULL,
  underline = NULL,
  disabled = FALSE,
  icon = NULL,
  id = NULL,
  ...,
  target = "_self",
  on = NULL
)

update_el_link(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  href = NULL,
  type = NULL,
  underline = NULL,
  disabled = NULL,
  icon = NULL
)
```

## Arguments

- label:

  Link text. Accepts a string or HTML tag.

- href:

  URL target. `NULL` for a non-navigating link.

- type:

  Link colour type: `"default"`, `"primary"`, `"success"`, `"warning"`,
  `"danger"`, `"info"`.

- underline:

  When the link is underlined: `"hover"`, `"always"` or `"never"`.
  `TRUE` and `FALSE`, Element UI's form, are `"hover"` and `"never"`.
  `type` and `underline` left `NULL` are `"default"` and `"hover"`, or
  for a link with an `id` a config provider's [el_config_provider(link
  =)](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md).

- disabled:

  Whether the link is disabled. Default `FALSE`.

- icon:

  Icon class string (e.g. `"el-icon-edit"`). Placed before the label.
  `NULL` for none.

- id:

  Give the link an id and it reports its clicks, as
  [`shiny::actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  does: `input$<id>` counts them, 0 on load, and `update_el_link()`
  changes it. Without one it is a plain link.

- ...:

  Additional HTML attributes passed to the `<a>` tag (a plain link
  only).

- target:

  Where the link opens, as an `<a>`'s `target`. Default `"_self"`.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateActionLink()`](https://rdrr.io/pkg/shiny/man/updateActionButton.html).

## Value

An `htmltools` `<a>` tag, or with an `id` a Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | with an `id`, the number of clicks, as [`actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html) reports it |

The same list as `el_events("el_link")`, which says how an event's
arguments travel.

## Updating from the server

Server-side update for an `el_link()` given an `id`.

`update_el_link()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_link("Visit GitHub", href = "https://github.com", type = "primary")
#> <a class="el-link el-link--primary is-hover-underline" href="https://github.com" target="_self">
#>   <span class="el-link__inner">Visit GitHub</span>
#> </a>
el_link("Disabled", disabled = TRUE)
#> <a class="el-link el-link--default is-disabled">
#>   <span class="el-link__inner">Disabled</span>
#> </a>
el_link("With icon", icon = "el-icon-edit", type = "success")
#> <a class="el-link el-link--success is-hover-underline">
#>   <i class="el-icon" data-el-icon="Edit" aria-hidden="true" role="img"></i>
#>   <span class="el-link__inner">With icon</span>
#> </a>

# An action link: input$more counts its clicks
el_link("Show more", id = "more", type = "primary")
#> <div id="more" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="more_container" style="display: contents">
#>   <el-link :href="href === null ? undefined : href" :type="type === null ? undefined : type" :target="target" :underline="underline === null ? undefined : underline" :disabled="disabled" :icon="icon === null ? undefined : icon" @click="handleClick">{{ text }}</el-link>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"text":"Show more","href":null,"type":"primary","target":"_self","underline":null,"disabled":false,"icon":null,"count":0},"methods":{"handleClick":"function() { if (this.disabled) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$more, update_el_link(session, "more", label = "Show less"))
}
```
