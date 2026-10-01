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
  session = NULL
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

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

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
#>         <div id="q" data-el-vue-host style="display: contents">
#>           <div id="q_container" data-el-mount style="display: contents">
#>             <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#>           </div>
#>           <script type="application/json" data-el-vue>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('q', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('q', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('q', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('q', 'clear', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('q', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#>         </div>
#>         <div id="live" data-el-vue-host style="display: contents">
#>           <div id="live_container" data-el-mount style="display: contents">
#>             <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#>           </div>
#>           <script type="application/json" data-el-vue>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('live', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
