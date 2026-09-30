# Element UI Collapse / Accordion

Collapsible panels. Several can be open at once unless
`accordion = TRUE`.

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

  A list of panels. Each is a named list with:

  name

  :   Unique panel identifier (string). Required.

  title

  :   Panel header text. Required.

  content

  :   Panel body. Any tag or tagList, including this package's own
      components.

  disabled

  :   Whether the header is disabled. Default `FALSE`.

- value:

  Character vector of initially open panel names. In accordion mode only
  the first is used.

- accordion:

  Single-open accordion mode. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance. That is what lets a
panel hold other components from this package: a Vue instance mounted
here would rebuild the DOM underneath them, detaching them from the
server. See `.claude/docs/lessons.md`.

## Shiny input

`input$<id>` — character vector of open panel names, reported on load
and on every change. Empty when all are closed, which Shiny reports as
`NULL`.

## Examples

``` r
el_collapse("col1",
  items = list(
    list(name = "p1", title = "Panel 1", content = shiny::tags$p("Content 1")),
    list(name = "p2", title = "Panel 2", content = shiny::tags$p("Content 2"))
  ),
  value = "p1"
)
#> <div id="col1" class="el-collapse" role="tablist" data-el-collapse="true" data-accordion="false">
#>   <div class="el-collapse-item is-active" data-el-name="p1">
#>     <div role="tab" class="el-collapse-item__header is-active">
#>       Panel 1
#>       <i class="el-collapse-item__arrow el-icon-arrow-right is-active"></i>
#>     </div>
#>     <div class="el-collapse-item__wrap">
#>       <div class="el-collapse-item__content">
#>         <p>Content 1</p>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-collapse-item" data-el-name="p2">
#>     <div role="tab" class="el-collapse-item__header">
#>       Panel 2
#>       <i class="el-collapse-item__arrow el-icon-arrow-right"></i>
#>     </div>
#>     <div class="el-collapse-item__wrap" style="display:none">
#>       <div class="el-collapse-item__content">
#>         <p>Content 2</p>
#>       </div>
#>     </div>
#>   </div>
#> </div>

# A panel can hold other components
el_collapse("col2",
  items = list(
    list(name = "f", title = "Filters",
         content = shiny::tagList(el_input("q"), el_switch("live")))
  )
)
#> <div id="col2" class="el-collapse" role="tablist" data-el-collapse="true" data-accordion="false">
#>   <div class="el-collapse-item" data-el-name="f">
#>     <div role="tab" class="el-collapse-item__header">
#>       Filters
#>       <i class="el-collapse-item__arrow el-icon-arrow-right"></i>
#>     </div>
#>     <div class="el-collapse-item__wrap" style="display:none">
#>       <div class="el-collapse-item__content">
#>         <div id="q_container" style="display: contents">
#>           <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label"></el-input>
#>         </div>
#>         <div id="q" style="width:0px;height:0px;" class="vue html-widget"></div>
#>         <script type="application/json" data-for="q">{"x":{"el":"#q_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('q', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"q\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>         <div id="live_container" style="display: contents">
#>           <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width"></el-switch>
#>         </div>
#>         <div id="live" style="width:0px;height:0px;" class="vue html-widget"></div>
#>         <script type="application/json" data-for="live">{"x":{"el":"#live_container","data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('live', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"live\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
