# Element Plus Check Tag

A tag that toggles on and off when clicked, as a checkbox does.

## Usage

``` r
el_check_tag(
  id,
  label,
  value = FALSE,
  disabled = NULL,
  type = NULL,
  width = NULL
)
```

## Arguments

- id:

  Tag ID; the state is reported as `input$<id>`.

- label:

  The tag's text.

- value:

  Whether it starts checked: Element Plus's `checked`.

- disabled:

  Whether it can be toggled.

- type:

  `"primary"` (the default), `"success"`, `"info"`, `"warning"` or
  `"danger"`.

- width:

  Component width, as a CSS unit.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – `TRUE` or `FALSE`, on load and on every change.

## Examples

``` r
el_check_tag("pinned", "Pinned", value = TRUE)
#> <div id="pinned" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="pinned_container" style="display: contents">
#>   <el-check-tag :checked="value" @change="handleChange" :disabled="disabled === null ? undefined : disabled" :type="type === null ? undefined : type">{{ text }}</el-check-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":true,"text":"Pinned","disabled":null,"type":null},"methods":{"handleChange":"function(v) { this.value = v; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
el_check_tag("urgent", "Urgent", type = "danger")
#> <div id="urgent" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="urgent_container" style="display: contents">
#>   <el-check-tag :checked="value" @change="handleChange" :disabled="disabled === null ? undefined : disabled" :type="type === null ? undefined : type">{{ text }}</el-check-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"text":"Urgent","disabled":null,"type":"danger"},"methods":{"handleChange":"function(v) { this.value = v; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
```
