# Element Plus Collapse / Accordion

Collapsible panels. Several can be open at once unless
`accordion = TRUE`.

## Usage

``` r
el_collapse(
  id = NULL,
  items = list(),
  value = character(0),
  accordion = FALSE,
  expand_icon_position = "right",
  before_collapse = NULL,
  session = NULL
)

update_el_collapse(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  accordion = NULL,
  expand_icon_position = NULL,
  before_collapse = NULL
)
```

## Arguments

- id:

  Collapse ID. Auto-generated UUID if `NULL`.

- items:

  A list of panels, each an
  [`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md)
  – or a named list with the same fields:

  name

  :   Unique panel identifier (string). Required.

  title

  :   Panel header text. Required.

  content

  :   Panel body. Any tag or tagList, including this package's own
      components.

  disabled

  :   Whether the header is disabled. Default `FALSE`.

  icon

  :   The expand icon, by name (default `"ArrowRight"`), or a tag.

- value:

  Character vector of initially open panel names. In accordion mode only
  the first is used.

- accordion:

  Single-open accordion mode. Default `FALSE`.

- expand_icon_position:

  Where each header's icon sits: `"right"` (the default) or `"left"`.

- before_collapse:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(name)`, run before a panel opens or closes: return
  `false`, or a promise that resolves to `false`, to keep it as it is.

- session:

  In `el_collapse()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_collapse()`, the Shiny session,
  the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance. That is what lets a
panel hold other components from this package: a Vue instance mounted
here would rebuild the DOM underneath them, detaching them from the
server. See `.claude/docs/lessons.md`.

## Shiny inputs

`input$<id>` – character vector of open panel names, reported on load
and on every change. Empty when all are closed, which Shiny reports as
`NULL`.

## Updating from the server

Server-side update for `el_collapse()`: the open panels, `accordion`,
`expand_icon_position` and `before_collapse` (`NA` for none).

`update_el_collapse()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_collapse(
  "col1",
  items = list(
    list(name = "p1", title = "Panel 1", content = shiny::tags$p("Content 1")),
    list(name = "p2", title = "Panel 2", content = shiny::tags$p("Content 2"))
  ),
  value = "p1"
)
#> <div id="col1" class="el-collapse el-collapse-icon-position-right" data-el-collapse="true" data-accordion="false">
#>   <div class="el-collapse-item is-active" data-el-name="p1">
#>     <div id="col1-head-p1" role="button" tabindex="0" aria-expanded="true" aria-controls="col1-content-p1" aria-describedby="col1-content-p1" class="el-collapse-item__header is-active">
#>       <span class="el-collapse-item__title">Panel 1</span>
#>       <i class="el-icon el-collapse-item__arrow is-active" data-el-icon="ArrowRight"></i>
#>     </div>
#>     <div id="col1-content-p1" role="region" aria-hidden="false" aria-labelledby="col1-head-p1" class="el-collapse-item__wrap">
#>       <div class="el-collapse-item__content">
#>         <p>Content 1</p>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-collapse-item" data-el-name="p2">
#>     <div id="col1-head-p2" role="button" tabindex="0" aria-expanded="false" aria-controls="col1-content-p2" aria-describedby="col1-content-p2" class="el-collapse-item__header">
#>       <span class="el-collapse-item__title">Panel 2</span>
#>       <i class="el-icon el-collapse-item__arrow" data-el-icon="ArrowRight"></i>
#>     </div>
#>     <div id="col1-content-p2" role="region" aria-hidden="true" aria-labelledby="col1-head-p2" class="el-collapse-item__wrap" style="display:none">
#>       <div class="el-collapse-item__content">
#>         <p>Content 2</p>
#>       </div>
#>     </div>
#>   </div>
#> </div>

# A panel can hold other components
el_collapse(
  "col2",
  items = list(
    list(
      name = "f",
      title = "Filters",
      content = shiny::tagList(el_input("q"), el_switch("live"))
    )
  )
)
#> <div id="col2" class="el-collapse el-collapse-icon-position-right" data-el-collapse="true" data-accordion="false">
#>   <div class="el-collapse-item" data-el-name="f">
#>     <div id="col2-head-f" role="button" tabindex="0" aria-expanded="false" aria-controls="col2-content-f" aria-describedby="col2-content-f" class="el-collapse-item__header">
#>       <span class="el-collapse-item__title">Filters</span>
#>       <i class="el-icon el-collapse-item__arrow" data-el-icon="ArrowRight"></i>
#>     </div>
#>     <div id="col2-content-f" role="region" aria-hidden="true" aria-labelledby="col2-head-f" class="el-collapse-item__wrap" style="display:none">
#>       <div class="el-collapse-item__content">
#>         <div id="q" data-shiny-vue style="display: contents">
#>           <script type="text/x-template" data-shiny-vue-template><div id="q_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @compositionend="elEmitCompositionend" @compositionstart="elEmitCompositionstart" @compositionupdate="elEmitCompositionupdate" @keydown="elEmitKeydown" @mouseenter="elEmitMouseenter" @mouseleave="elEmitMouseleave" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>           <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('q', 'input', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('q', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('q', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('q', 'clear', arguments); }","elEmitCompositionend":"function() { window.shinyVue.emit('q', 'compositionend', arguments); }","elEmitCompositionstart":"function() { window.shinyVue.emit('q', 'compositionstart', arguments); }","elEmitCompositionupdate":"function() { window.shinyVue.emit('q', 'compositionupdate', arguments); }","elEmitKeydown":"function() { window.shinyVue.emit('q', 'keydown', arguments); }","elEmitMouseenter":"function() { window.shinyVue.emit('q', 'mouseenter', arguments); }","elEmitMouseleave":"function() { window.shinyVue.emit('q', 'mouseleave', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitCompositionend","options.methods.elEmitCompositionstart","options.methods.elEmitCompositionupdate","options.methods.elEmitKeydown","options.methods.elEmitMouseenter","options.methods.elEmitMouseleave","options.methods.handleChange"]}</script>
#>         </div>
#>         <div id="live" data-shiny-vue style="display: contents">
#>           <script type="text/x-template" data-shiny-vue-template><div id="live_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :style="{ &#39;--el-switch-on-color&#39;: activeColor || undefined, &#39;--el-switch-off-color&#39;: inactiveColor || undefined, &#39;--el-switch-border-color&#39;: borderColor || undefined }" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent" :active-action-icon="activeActionIcon === null ? undefined : activeActionIcon" :active-icon="activeIcon === null ? undefined : activeIcon" :aria-label="ariaLabel === null ? undefined : ariaLabel" :before-change="beforeChange === null ? undefined : beforeChange" :border-color="borderColor === null ? undefined : borderColor" :inactive-action-icon="inactiveActionIcon === null ? undefined : inactiveActionIcon" :inactive-icon="inactiveIcon === null ? undefined : inactiveIcon" :inline-prompt="inlinePrompt === null ? undefined : inlinePrompt" :loading="loading === null ? undefined : loading" :size="size === null ? undefined : size" :tabindex="tabindex === null ? undefined : tabindex"></el-switch>
#> </div></script>
#>           <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"name":null,"validateEvent":null,"activeActionIcon":null,"activeIcon":null,"ariaLabel":null,"beforeChange":null,"borderColor":null,"inactiveActionIcon":null,"inactiveIcon":null,"inlinePrompt":null,"loading":null,"size":null,"tabindex":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_collapse(session, "panels", value = "filters")
  })
}
```
