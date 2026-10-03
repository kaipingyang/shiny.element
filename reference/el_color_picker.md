# Element Plus Color Picker

A colour picker input that returns a CSS colour string.

## Usage

``` r
el_color_picker(
  id = NULL,
  value = NULL,
  disabled = FALSE,
  size = NULL,
  show_alpha = FALSE,
  color_format = NULL,
  predefine = NULL,
  popper_class = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  append_to = NULL,
  aria_label = NULL,
  clearable = NULL,
  empty_values = NULL,
  persistent = NULL,
  popper_style = NULL,
  tabindex = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Color picker ID. Auto-generated UUID if `NULL`.

- value:

  Initial colour value (CSS hex/rgb string). `NULL` for empty.

- disabled:

  Whether the picker is disabled. Default `FALSE`.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- show_alpha:

  Whether to show an alpha channel slider. Default `FALSE`. When `TRUE`,
  the returned value is an `rgba(...)` string.

- color_format:

  Output format: `NULL` (auto), `"hex"`, `"rgb"`, `"hsv"`, `"hsl"`.

- predefine:

  Character vector of preset colour swatches. `NULL` for none.

- popper_class:

  Extra class name for the dropdown panel.

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- append_to:

  Which element the color-picker panel appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- aria_label:

  ColorPicker aria-label. Element Plus's `aria-label` (string).

- clearable:

  Whether to show clear button. Element Plus's `clearable` (boolean).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- persistent:

  When color-picker inactive and persistent is false, the color panel
  will be destroyed. Element Plus's `persistent` (boolean).

- popper_style:

  Custom style for ColorPicker's dropdown. Element Plus's `popper-style`
  (string / object).

- tabindex:

  ColorPicker tabindex. Element Plus's `tabindex` (string / number).

- teleported:

  Whether color-picker popper is teleported to the body. Element Plus's
  `teleported` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

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

An `htmltools` tagList with a Vue-managed color-picker component.

## Shiny inputs

`input$<id>` — colour string (e.g. `"#409EFF"` or
`"rgba(64,158,255,0.5)"`). `NULL` / `NA` when the user clears the
picker.

## Examples

``` r
el_color_picker("cp1", value = "#409EFF")
#> <div id="cp1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cp1_container" style="display: contents">
#>   <el-color-picker v-model="value" :disabled="disabled" :show-alpha="showAlpha" @change="handleChange" :size="size === null ? undefined : size" :color-format="colorFormat === null ? undefined : colorFormat" :predefine="predefine === null ? undefined : predefine" :popper-class="popperClass === null ? undefined : popperClass" @active-change="elEmitActiveChange" @blur="elEmitBlur" @clear="elEmitClear" @focus="elEmitFocus" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clearable="clearable === null ? undefined : clearable" :empty-values="emptyValues === null ? undefined : emptyValues" :persistent="persistent === null ? undefined : persistent" :popper-style="popperStyle === null ? undefined : popperStyle" :tabindex="tabindex === null ? undefined : tabindex" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-color-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"#409EFF","disabled":false,"showAlpha":false,"size":null,"colorFormat":null,"predefine":null,"popperClass":null,"appendTo":null,"ariaLabel":null,"clearable":null,"emptyValues":null,"persistent":null,"popperStyle":null,"tabindex":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitActiveChange":"function() { window.shinyVue.emit('cp1', 'active_change', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('cp1', 'blur', arguments); }","elEmitClear":"function() { window.shinyVue.emit('cp1', 'clear', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('cp1', 'focus', arguments); }","handleChange":"function(val) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitActiveChange","options.methods.elEmitBlur","options.methods.elEmitClear","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
el_color_picker("cp2", show_alpha = TRUE, predefine = c("#ff4500", "#ff8c00"))
#> <div id="cp2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cp2_container" style="display: contents">
#>   <el-color-picker v-model="value" :disabled="disabled" :show-alpha="showAlpha" @change="handleChange" :size="size === null ? undefined : size" :color-format="colorFormat === null ? undefined : colorFormat" :predefine="predefine === null ? undefined : predefine" :popper-class="popperClass === null ? undefined : popperClass" @active-change="elEmitActiveChange" @blur="elEmitBlur" @clear="elEmitClear" @focus="elEmitFocus" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clearable="clearable === null ? undefined : clearable" :empty-values="emptyValues === null ? undefined : emptyValues" :persistent="persistent === null ? undefined : persistent" :popper-style="popperStyle === null ? undefined : popperStyle" :tabindex="tabindex === null ? undefined : tabindex" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-color-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":null,"disabled":false,"showAlpha":true,"size":null,"colorFormat":null,"predefine":["#ff4500","#ff8c00"],"popperClass":null,"appendTo":null,"ariaLabel":null,"clearable":null,"emptyValues":null,"persistent":null,"popperStyle":null,"tabindex":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitActiveChange":"function() { window.shinyVue.emit('cp2', 'active_change', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('cp2', 'blur', arguments); }","elEmitClear":"function() { window.shinyVue.emit('cp2', 'clear', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('cp2', 'focus', arguments); }","handleChange":"function(val) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitActiveChange","options.methods.elEmitBlur","options.methods.elEmitClear","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>
```
