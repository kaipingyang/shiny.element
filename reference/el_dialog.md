# Element Plus Dialog

A modal dialog.

## Usage

``` r
el_dialog(
  id = NULL,
  title = "",
  content = NULL,
  footer = NULL,
  visible = FALSE,
  width = "50%",
  top = "15vh",
  fullscreen = FALSE,
  modal = TRUE,
  close_on_click_modal = TRUE,
  close_on_press_escape = TRUE,
  show_close = TRUE,
  center = FALSE,
  lock_scroll = TRUE,
  custom_class = NULL,
  append_to_body = FALSE,
  destroy_on_close = FALSE,
  before_close = NULL,
  modal_penetrable = FALSE,
  close_icon = NULL,
  align_center = NULL,
  draggable = NULL,
  overflow = NULL,
  modal_class = NULL,
  header_class = NULL,
  body_class = NULL,
  footer_class = NULL,
  append_to = NULL,
  open_delay = NULL,
  close_delay = NULL,
  z_index = NULL,
  header_aria_level = "2",
  transition = NULL,
  events = NULL,
  session = NULL
)

update_el_dialog(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visible = NULL,
  title = NULL,
  width = NULL,
  top = NULL,
  fullscreen = NULL,
  modal = NULL,
  close_on_click_modal = NULL,
  close_on_press_escape = NULL,
  show_close = NULL,
  center = NULL,
  lock_scroll = NULL,
  draggable = NULL,
  overflow = NULL,
  align_center = NULL
)
```

## Arguments

- id:

  Dialog ID. Auto-generated UUID if `NULL`.

- title:

  Header text. `""` renders the header bar without a title.

- content:

  Dialog body. Any tag or tagList, including this package's own
  components.

- footer:

  Footer content, usually buttons. `NULL` for none.

- visible:

  Whether it starts open: Element Plus's `model-value`.

- width:

  Dialog width, e.g. `"50%"` or `"600px"`.

- top:

  Distance from the top of the viewport. Ignored when
  `fullscreen = TRUE` or `align_center = TRUE`.

- fullscreen:

  Fill the viewport.

- modal:

  Show the backdrop.

- close_on_click_modal:

  Close when the backdrop is clicked.

- close_on_press_escape:

  Close on Escape.

- show_close:

  Show the close button in the header.

- center:

  Centre the header and footer.

- lock_scroll:

  Whether the page stops scrolling while it is open.

- custom_class:

  Extra class name for the panel.

- append_to_body:

  `append_to = "body"`.

- destroy_on_close:

  Re-create the content each time it opens, and remove it when it
  closes: inputs inside start from their initial values again.

- before_close:

  `htmltools::JS()` function `function(done)`, run when the user closes
  it – by the cross, the backdrop or Escape; call `done()` to let it
  close.

- modal_penetrable:

  Let clicks through the backdrop to the page beneath, when
  `modal = FALSE`.

- close_icon:

  The close button's icon, by name. Default `"Close"`.

- align_center:

  Centre the dialog in the viewport, vertically too.

- draggable:

  Let the dialog be dragged by its header.

- overflow:

  With `draggable`, let it be dragged past the viewport. `align_center`,
  `draggable` and `overflow` left `NULL` are off, or a config provider's
  [el_config_provider(dialog
  =)](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md).

- modal_class, header_class, body_class, footer_class:

  Extra class names for the backdrop, the header, the body and the
  footer.

- append_to:

  A CSS selector for where the overlay goes when it opens, so a
  container's `overflow` or `transform` cannot clip it. Its components
  keep working; they are moved, not re-created.

- open_delay, close_delay:

  Milliseconds to wait before opening and closing.

- z_index:

  The overlay's z-index, instead of the next one Element Plus hands out.

- header_aria_level:

  The title's `aria-level`. Default `"2"`.

- transition:

  The name of the transition it plays, instead of Element's
  `"dialog-fade"`.

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- session:

  In `el_dialog()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_dialog()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element Plus's own classes, driven by
a Shiny input binding rather than a Vue instance, so the body can hold
other components from this package.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | `TRUE` while it is open |
| `input$<id>_open` | `events = "open"` | triggers when the Dialog opens |
| `input$<id>_opened` | `events = "opened"` | triggers when the Dialog opening animation ends |
| `input$<id>_close` | `events = "close"` | triggers when the Dialog closes |
| `input$<id>_closed` | unasked | triggers when the Dialog closing animation ends |
| `input$<id>_open_auto_focus` | `events = "open_auto_focus"` | triggers after Dialog opens and content focused |
| `input$<id>_close_auto_focus` | `events = "close_auto_focus"` | triggers after Dialog closed and content focused |

The same list as `el_events("el_dialog")`, which says how an event's
arguments travel.

Shiny routes an input binding's messages by element id, so the value is
`input$<id>` itself, as for
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md)
and
[`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md).

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`resetPosition()` puts a dragged dialog back.

## Updating from the server

Server-side update for `el_dialog()`: whether it shows, its title and
width, and how it looks and behaves – `top`, `fullscreen`, `modal`,
`close_on_click_modal`, `close_on_press_escape`, `show_close`, `center`,
`lock_scroll`, `draggable`, `overflow`, `align_center` – as Element's
props, reactive there.

`update_el_dialog()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_dialog(
  "d1",
  title = "Confirm",
  content = shiny::tags$p("Are you sure?"),
  footer = el_button("ok", "OK", type = "primary")
)
#> <div id="d1" class="el-overlay" style="display:none;" data-el-overlay="dialog" data-shiny-island data-el-events="closed" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true" data-lock-scroll="true" data-el-dialog-defaults="alignCenter draggable overflow" data-destroy-on-close="false">
#>   <div class="el-overlay-dialog" role="dialog" aria-modal="true" aria-label="Confirm">
#>     <div class="el-dialog" tabindex="-1" style="--el-dialog-width: 50%; --el-dialog-margin-top: 15vh;">
#>       <header class="el-dialog__header show-close">
#>         <span role="heading" aria-level="2" class="el-dialog__title">Confirm</span>
#>         <button type="button" aria-label="Close" class="el-dialog__headerbtn">
#>           <i class="el-icon el-dialog__close"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path fill="currentColor" d="M764.288 214.592 512 466.88 259.712 214.592a31.936 31.936 0 0 0-45.12 45.12L466.752 512 214.528 764.224a31.936 31.936 0 1 0 45.12 45.184L512 557.184l252.288 252.288a31.936 31.936 0 0 0 45.12-45.12L557.12 512.064l252.288-252.352a31.936 31.936 0 1 0-45.12-45.184z"></path></svg></i>
#>         </button>
#>       </header>
#>       <div class="el-dialog__body">
#>         <p>Are you sure?</p>
#>       </div>
#>       <footer class="el-dialog__footer">
#>         <div id="ok" data-shiny-vue style="display: contents">
#>           <script type="text/x-template" data-shiny-vue-template><div id="ok_container" style="display: contents">
#>   <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>           <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"OK","type":"primary","size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"state":"ready","autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#>         </div>
#>       </footer>
#>     </div>
#>   </div>
#> </div>

# The body can hold other components
el_dialog(
  "d2",
  title = "Filters",
  draggable = TRUE,
  content = shiny::tagList(el_input("q"), el_switch("live"))
)
#> <div id="d2" class="el-overlay" style="display:none;" data-el-overlay="dialog" data-shiny-island data-el-events="closed" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true" data-lock-scroll="true" data-draggable="true" data-el-dialog-defaults="alignCenter overflow" data-destroy-on-close="false">
#>   <div class="el-overlay-dialog" role="dialog" aria-modal="true" aria-label="Filters">
#>     <div class="el-dialog is-draggable" tabindex="-1" style="--el-dialog-width: 50%; --el-dialog-margin-top: 15vh;">
#>       <header class="el-dialog__header show-close">
#>         <span role="heading" aria-level="2" class="el-dialog__title">Filters</span>
#>         <button type="button" aria-label="Close" class="el-dialog__headerbtn">
#>           <i class="el-icon el-dialog__close"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path fill="currentColor" d="M764.288 214.592 512 466.88 259.712 214.592a31.936 31.936 0 0 0-45.12 45.12L466.752 512 214.528 764.224a31.936 31.936 0 1 0 45.12 45.184L512 557.184l252.288 252.288a31.936 31.936 0 0 0 45.12-45.12L557.12 512.064l252.288-252.352a31.936 31.936 0 1 0-45.12-45.184z"></path></svg></i>
#>         </button>
#>       </header>
#>       <div class="el-dialog__body">
#>         <div id="q" data-shiny-vue style="display: contents">
#>           <script type="text/x-template" data-shiny-vue-template><div id="q_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>           <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
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
    update_el_dialog(session, "confirm", visible = TRUE)
  })
}
```
