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
  width = NULL,
  on = NULL
)

update_el_check_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  disabled = NULL,
  type = NULL
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
  [`shiny::updateCheckboxInput()`](https://rdrr.io/pkg/shiny/man/updateCheckboxInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|              |          |                      |
|--------------|----------|----------------------|
| Input        | Reported | Value                |
| `input$<id>` | unasked  | `TRUE` while checked |

The same list as `el_events("el_check_tag")`, which says how an event's
arguments travel.

## Updating from the server

`update_el_check_tag()` changes the component from the server.

Every other argument of `el_check_tag()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_check_tag()` is called for its side effect and returns `NULL`
invisibly.

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
if (interactive()) {
  # inside a server function
  observeEvent(
    input$clear,
    update_el_check_tag(session, "pinned", value = FALSE)
  )
}
```
