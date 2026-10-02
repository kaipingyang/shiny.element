# Element UI Tag

Creates a styled tag/chip component. Tracks click and close events as
Shiny inputs.

## Usage

``` r
el_tag(
  id = NULL,
  label = "Tag",
  type = NULL,
  closable = FALSE,
  size = NULL,
  effect = "light",
  color = NULL,
  hit = FALSE,
  disable_transitions = FALSE,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Tag ID. Auto-generated UUID if `NULL`.

- label:

  Tag text.

- type:

  Tag colour: `NULL` (default blue), `"success"`, `"info"`, `"warning"`,
  `"danger"`.

- closable:

  Whether to show a close button. Default `FALSE`. When `TRUE`,
  `input$<id>_closed` fires once when the user closes the tag.

- size:

  Tag size: `NULL`, `"medium"`, `"small"`, `"mini"`.

- effect:

  Visual effect: `"light"` (default), `"dark"`, `"plain"`.

- color:

  Custom background colour (CSS string). `NULL` for themed colour.

- hit:

  Whether to show a solid border. Default `FALSE`.

- disable_transitions:

  Disable the zoom-in-center animation. Default `FALSE`.

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

An `htmltools` tagList with a Vue-managed tag component.

## Shiny inputs

- `input$<id>` – the number of clicks on the tag's body, as
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  reports it: 0 on load, treated by
  [`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)
  and [`req()`](https://rdrr.io/pkg/shiny/man/req.html) as not yet
  clicked.

- `input$<id>_closed` — set to `1` when the user clicks the close button
  (only meaningful when `closable = TRUE`).

## Examples

``` r
el_tag("tag1", "Success", type = "success")
#> <div id="tag1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tag1_container" style="display: contents">
#>   <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose" :size="size === null ? undefined : size" :color="color === null ? undefined : color">{{label}}</el-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Success","type":"success","closable":false,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0},"methods":{"handleClick":"function() { this.count++; }","handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tag1_closed', 1, {priority: 'event'}); }"}},"input":"count","rate":null,"type":"shiny.action","evals":["options.methods.handleClick","options.methods.handleClose"]}</script>
#> </div>
el_tag("tag2", "Closable", closable = TRUE)
#> <div id="tag2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tag2_container" style="display: contents">
#>   <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose" :size="size === null ? undefined : size" :color="color === null ? undefined : color">{{label}}</el-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Closable","type":null,"closable":true,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0},"methods":{"handleClick":"function() { this.count++; }","handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tag2_closed', 1, {priority: 'event'}); }"}},"input":"count","rate":null,"type":"shiny.action","evals":["options.methods.handleClick","options.methods.handleClose"]}</script>
#> </div>
```
