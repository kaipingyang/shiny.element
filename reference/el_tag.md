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
  session = shiny::getDefaultReactiveDomain()
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

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed tag component.

## Shiny inputs

- `input$<id>` — click count (integer), incremented each time the tag
  body is clicked.

- `input$<id>_closed` — set to `1` when the user clicks the close button
  (only meaningful when `closable = TRUE`).

## Examples

``` r
el_tag("tag1", "Success", type = "success")
#> <div id="tag1_container">
#>   <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose">{{label}}</el-tag>
#> </div>
#> <div class="vue html-widget html-fill-item" id="tag1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="tag1">{"x":{"el":"#tag1_container","data":{"label":"Success","type":"success","closable":false,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0},"methods":{"handleClick":"function() { this.count++; Shiny.setInputValue('tag1', this.count); }","handleClose":"function() { Shiny.setInputValue('tag1_closed', 1, {priority: 'event'}); }"}},"evals":["methods.handleClick","methods.handleClose"],"jsHooks":[]}</script>
el_tag("tag2", "Closable", closable = TRUE)
#> <div id="tag2_container">
#>   <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose">{{label}}</el-tag>
#> </div>
#> <div class="vue html-widget html-fill-item" id="tag2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="tag2">{"x":{"el":"#tag2_container","data":{"label":"Closable","type":null,"closable":true,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0},"methods":{"handleClick":"function() { this.count++; Shiny.setInputValue('tag2', this.count); }","handleClose":"function() { Shiny.setInputValue('tag2_closed', 1, {priority: 'event'}); }"}},"evals":["methods.handleClick","methods.handleClose"],"jsHooks":[]}</script>
```
