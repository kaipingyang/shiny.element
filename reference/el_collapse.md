# Element UI Collapse / Accordion

A collapsible accordion panel. Multiple panels can be open
simultaneously unless `accordion = TRUE` is set.

## Usage

``` r
el_collapse(
  id = NULL,
  items = list(),
  value = character(0),
  accordion = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Collapse ID. Auto-generated UUID if `NULL`.

- items:

  A list of panels. Each element is a named list with:

  name

  :   Unique panel identifier (string). Required.

  title

  :   Panel header text. Required.

  content

  :   Panel body content (tag or tagList). Required.

  disabled

  :   Whether the panel header is disabled. Default `FALSE`.

- value:

  Character vector of initially active panel names. Ignored (use a
  single-element vector) when `accordion = TRUE`.

- accordion:

  Single-open accordion mode. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed collapse component.

## Shiny input

`input$<id>` — character vector of currently open panel names (empty
character vector when all are closed). In accordion mode a single
string.

## Examples

``` r
el_collapse("col1",
  items = list(
    list(name = "p1", title = "Panel 1", content = shiny::tags$p("Content 1")),
    list(name = "p2", title = "Panel 2", content = shiny::tags$p("Content 2"))
  ),
  value = "p1"
)
#> <div id="col1_container">
#>   <el-collapse :value="activeNames" :accordion="accordion" @change="handleChange">
#>     <el-collapse-item name="p1" title="Panel 1">
#>       <p>Content 1</p>
#>     </el-collapse-item>
#>     <el-collapse-item name="p2" title="Panel 2">
#>       <p>Content 2</p>
#>     </el-collapse-item>
#>   </el-collapse>
#> </div>
#> <div class="vue html-widget html-fill-item" id="col1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="col1">{"x":{"el":"#col1_container","data":{"activeNames":["p1"],"accordion":false},"methods":{"handleChange":"function(val) { Shiny.setInputValue('col1', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
```
