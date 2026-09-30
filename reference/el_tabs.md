# Element UI Tabs

A tabbed panel.

## Usage

``` r
el_tabs(
  id = NULL,
  tabs = list(),
  selected = NULL,
  type = NULL,
  tab_position = "top",
  closable = FALSE,
  stretch = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Tabs ID. Auto-generated UUID if `NULL`.

- tabs:

  A list of tabs. Each is a named list with:

  name

  :   Unique tab identifier (string). Required.

  label

  :   Tab label. Required.

  content

  :   Tab body. Any tag or tagList, including this package's own
      components.

  disabled

  :   Whether the tab can be selected. Default `FALSE`.

- selected:

  Name of the initially selected tab. Defaults to the first.

- type:

  `NULL` for plain tabs, `"card"` or `"border-card"`.

- tab_position:

  `"top"` (default), `"right"`, `"bottom"` or `"left"`.

- closable:

  Show a close button on each tab. Closing removes the tab from the
  page; the server is told through `input$<id>_closed`.

- stretch:

  Stretch the tabs to fill the available width.

- session:

  Shiny session for module support.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance. That is what lets a tab
hold other components from this package: a Vue instance mounted here
would rebuild the DOM underneath them, leaving them rendered but
disconnected from the server. See `.claude/docs/lessons.md` §1.2.

## Shiny inputs

`input$<id>` — name of the selected tab, reported on load and on every
change. `input$<id>_closed` — name of the most recently closed tab, when
`closable = TRUE`.

## Examples

``` r
el_tabs("t1", selected = "a", tabs = list(
  list(name = "a", label = "First",  content = shiny::tags$p("One")),
  list(name = "b", label = "Second", content = shiny::tags$p("Two"))
))
#> <div id="t1" class="el-tabs el-tabs--top" data-el-tabs="true" data-position="top" data-carded="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t1-tab-a" role="tab" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="a">First</div>
#>           <div id="t1-tab-b" role="tab" tabindex="-1" class="el-tabs__item is-top" data-el-name="b">Second</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t1-pane-a" class="el-tab-pane" data-el-name="a">
#>       <p>One</p>
#>     </div>
#>     <div role="tabpanel" id="t1-pane-b" class="el-tab-pane" style="display:none" data-el-name="b">
#>       <p>Two</p>
#>     </div>
#>   </div>
#> </div>

# A tab can hold other components
el_tabs("t2", tabs = list(
  list(name = "data", label = "Data", content = el_table(data = head(iris, 3))),
  list(name = "opts", label = "Options", content = el_switch("live"))
))
#> <div id="t2" class="el-tabs el-tabs--top" data-el-tabs="true" data-position="top" data-carded="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t2-tab-data" role="tab" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="data">Data</div>
#>           <div id="t2-tab-opts" role="tab" tabindex="-1" class="el-tabs__item is-top" data-el-name="opts">Options</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t2-pane-data" class="el-tab-pane" data-el-name="data">
#>       <div id="el_table_de2d3c82-b4bf-4648-9890-658e014c7a28_container" style="display: contents">
#>         <el-table :data="tableData" :border="border" style="width: 100%" @selection-change="handleSelectionChange">
#>           <el-table-column v-if="selection" type="selection" width="55"></el-table-column>
#>           <el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width"></el-table-column>
#>         </el-table>
#>       </div>
#>       <div id="el_table_de2d3c82-b4bf-4648-9890-658e014c7a28" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="el_table_de2d3c82-b4bf-4648-9890-658e014c7a28">{"x":{"el":"#el_table_de2d3c82-b4bf-4648-9890-658e014c7a28_container","data":{"tableData":[{"Sepal_Length":5.1,"Sepal_Width":3.5,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.9,"Sepal_Width":3,"Petal_Length":1.4,"Petal_Width":0.2,"Species":"setosa"},{"Sepal_Length":4.7,"Sepal_Width":3.2,"Petal_Length":1.3,"Petal_Width":0.2,"Species":"setosa"}],"columns":[{"prop":"Sepal_Length","label":"Sepal.Length"},{"prop":"Sepal_Width","label":"Sepal.Width"},{"prop":"Petal_Length","label":"Petal.Length"},{"prop":"Petal_Width","label":"Petal.Width"},{"prop":"Species","label":"Species"}],"border":true,"selection":false,"selected":[],"selectedRows":[]},"methods":{"handleSelectionChange":"function(selection) { var self = this; self.selected = selection; self.selectedRows = selection.map(function(r) { return self.tableData.indexOf(r) + 1; }); Shiny.setInputValue('el_table_de2d3c82-b4bf-4648-9890-658e014c7a28_selected', self.selected); Shiny.setInputValue('el_table_de2d3c82-b4bf-4648-9890-658e014c7a28_selected_rows', self.selectedRows); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"el_table_de2d3c82-b4bf-4648-9890-658e014c7a28_selected\", self.selected); Shiny.setInputValue(\"el_table_de2d3c82-b4bf-4648-9890-658e014c7a28_selected_rows\", self.selectedRows); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelectionChange","mounted"],"jsHooks":[]}</script>
#>     </div>
#>     <div role="tabpanel" id="t2-pane-opts" class="el-tab-pane" style="display:none" data-el-name="opts">
#>       <div id="live_container" style="display: contents">
#>         <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange"></el-switch>
#>       </div>
#>       <div id="live" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="live">{"x":{"el":"#live_container","data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false},"methods":{"handleChange":"function(value) { Shiny.setInputValue('live', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"live\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>     </div>
#>   </div>
#> </div>
```
