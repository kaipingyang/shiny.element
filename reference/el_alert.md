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
  width = NULL,
  slots = NULL,
  session = NULL
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

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed alert component.

## Shiny input

`input$<id>_closed` — set to `1` (with `priority = "event"`) when the
user closes the alert.

## Examples

``` r
el_alert("al1", "Operation successful", type = "success", show_icon = TRUE)
#> <div id="al1" data-el-vue-host style="display: contents">
#>   <div id="al1_container" data-el-mount style="display: contents">
#>     <el-alert :title="title" :type="type" :closable="closable" :close-text="closeText" :show-icon="showIcon" :center="center" :effect="effect" @close="handleClose" :description="description === null ? undefined : description"></el-alert>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"title":"Operation successful","type":"success","closable":true,"closeText":"","showIcon":true,"center":false,"effect":"light","description":null},"methods":{"handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('al1_closed', 1, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClose"]}</script>
#> </div>
el_alert("al2", "Warning!", description = "Please review.", type = "warning")
#> <div id="al2" data-el-vue-host style="display: contents">
#>   <div id="al2_container" data-el-mount style="display: contents">
#>     <el-alert :title="title" :type="type" :closable="closable" :close-text="closeText" :show-icon="showIcon" :center="center" :effect="effect" @close="handleClose" :description="description === null ? undefined : description"></el-alert>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"title":"Warning!","type":"warning","closable":true,"closeText":"","showIcon":false,"center":false,"effect":"light","description":"Please review."},"methods":{"handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('al2_closed', 1, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClose"]}</script>
#> </div>
```
