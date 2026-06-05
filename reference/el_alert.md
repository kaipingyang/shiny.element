# Element UI Alert

An inline alert banner with optional close button. Fires a Shiny input
when the user closes it.

## Usage

``` r
el_alert(
  id = NULL,
  title = "",
  description = NULL,
  type = "info",
  closable = TRUE,
  close_text = "",
  show_icon = FALSE,
  center = FALSE,
  effect = "light",
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Alert ID. Auto-generated UUID if `NULL`.

- title:

  Main alert title text.

- description:

  Optional secondary description text. When supplied, the icon is
  rendered at the larger size.

- type:

  Alert type: `"info"` (default), `"success"`, `"warning"`, `"error"`.

- closable:

  Whether to show a close button. Default `TRUE`.

- close_text:

  Custom text for the close button. `""` for the default ×.

- show_icon:

  Whether to display the type icon. Default `FALSE`.

- center:

  Whether to centre the content. Default `FALSE`.

- effect:

  Visual effect: `"light"` (default) or `"dark"`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed alert component.

## Shiny input

`input$<id>_closed` — set to `1` (with `priority = "event"`) when the
user closes the alert.

## Examples

``` r
el_alert("al1", "Operation successful", type = "success", show_icon = TRUE)
#> <div id="al1_container">
#>   <el-alert :title="title" :type="type" :closable="closable" :close-text="closeText" :show-icon="showIcon" :center="center" :effect="effect" @close="handleClose"></el-alert>
#> </div>
#> <div class="vue html-widget html-fill-item" id="al1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="al1">{"x":{"el":"#al1_container","data":{"title":"Operation successful","type":"success","closable":true,"closeText":"","showIcon":true,"center":false,"effect":"light"},"methods":{"handleClose":"function() { Shiny.setInputValue('al1_closed', 1, {priority: 'event'}); }"}},"evals":["methods.handleClose"],"jsHooks":[]}</script>
el_alert("al2", "Warning!", description = "Please review.", type = "warning")
#> <div id="al2_container">
#>   <el-alert :title="title" :type="type" :closable="closable" :close-text="closeText" :show-icon="showIcon" :center="center" :effect="effect" @close="handleClose" :description="description"></el-alert>
#> </div>
#> <div class="vue html-widget html-fill-item" id="al2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="al2">{"x":{"el":"#al2_container","data":{"title":"Warning!","type":"warning","closable":true,"closeText":"","showIcon":false,"center":false,"effect":"light","description":"Please review."},"methods":{"handleClose":"function() { Shiny.setInputValue('al2_closed', 1, {priority: 'event'}); }"}},"evals":["methods.handleClose"],"jsHooks":[]}</script>
```
