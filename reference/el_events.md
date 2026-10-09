# The Shiny inputs a component reports

Every input a component can report, from one list: the ones it always
reports – its value, and the requests the server answers – and the
Element Plus events it forwards, some of them unasked (`default`) and
the rest when asked for with the component's `events` argument. Each is
`input$<id>_<event>`, the event in snake_case, namespaced in a module as
the component's id is.

## Usage

``` r
el_events(component)
```

## Arguments

- component:

  A component function, or its name: `el_tree`, `"el_tree"` or `"tree"`.

## Value

A data frame, one row per input, of class `el_events`:

- input:

  The input, `input$<id>` or `input$<id>_<name>`.

- event:

  What to give `events` to have it reported: Element's event in
  snake_case; `NA` for an input always reported.

- default:

  `TRUE` when it is reported without being asked for.

- about:

  When it is sent: Element's description of the event.

- value:

  What it holds. Empty for an event whose arguments are sent as they are
  (see Details).

- args:

  The event's arguments in Element.

## Details

A component's help page lists the same in its "Shiny inputs" section,
and an unknown name given to `events` is an error that lists them.

For an event not in the list – a key with a modifier, a DOM event on the
element Element draws – or to send something else than what an event
carries, give the component a handler of your own with `on`: see
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

An event's arguments are sent as they are when nothing is said in
`value`: one as itself, several as `list(arg1, arg2, ...)`, none as
`TRUE`. Arguments that cannot travel – DOM nodes, a component's internal
objects – are dropped; a keyboard event is sent as
`list(key, code, ctrl, shift, alt, meta)`. Every event input is sent
with `priority = "event"`: an observer runs even when the value is the
same as before.

## Examples

``` r
el_events("el_tree")
#> el_tree() reports, as input$<id>...:
#> 
#> Unasked
#>   input$<id>          the key of the node last clicked
#>   input$<id>_checked  the keys of the checked nodes
#>   input$<id>_load     with `lazy = TRUE`, a node asking for its children; answer with `el_load_children()`
#> 
#> When asked for, with `events =`
#>   input$<id>_check_change      `list(data, checked, indeterminate)`
#>   input$<id>_current_change    `list(data, key, level)` of the current node
#>   input$<id>_node_expand       `list(data, key, level)`
#>   input$<id>_node_collapse     `list(data, key, level)`
#>   input$<id>_node_contextmenu  `list(data, key, level)`
#>   input$<id>_node_drag_start   `list(data)` of the dragged node
#>   input$<id>_node_drag_enter   `list(dragging, drop)`, the nodes' data
#>   input$<id>_node_drag_leave   `list(dragging, drop)`, the nodes' data
#>   input$<id>_node_drag_over    `list(dragging, drop)`, the nodes' data, at most every 200 ms
#>   input$<id>_node_drag_end     `list(dragging, drop, type)`
#>   input$<id>_node_drop         `list(dragging, drop, type)`: `type` `"before"`, `"after"` or `"inner"`
#> 
#>   el_tree(..., events = c("check_change", "current_change"))
el_events(el_input)
#> el_input() reports, as input$<id>...:
#> 
#> Unasked
#>   input$<id>  the text, as it is typed (debounced by 250 ms)
#> 
#> When asked for, with `events =`
#>   input$<id>_input              triggers when the Input value change
#>   input$<id>_blur               triggers when Input blurs
#>   input$<id>_focus              triggers when Input focuses
#>   input$<id>_clear              triggers when the Input is cleared by clicking the clear button
#>   input$<id>_compositionend     triggers when the composition ends
#>   input$<id>_compositionstart   triggers when the composition starts
#>   input$<id>_compositionupdate  triggers when the composition is updated
#>   input$<id>_keydown            the key: `list(key, code, ctrl, shift, alt, meta)`
#>   input$<id>_mouseenter         triggers when the mouse enters the Input element
#>   input$<id>_mouseleave         triggers when the mouse leaves the Input element
#> 
#>   el_input(..., events = c("input", "blur"))

# asking for an event
el_input("q", events = "keydown") # input$q_keydown
#> <div id="q" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="q_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @keydown="svEmitKeydown" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"svEmitKeydown":"function() { window.shinyVue.emit('q', 'keydown', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitKeydown","options.methods.handleChange"]}</script>
#> </div>
```
