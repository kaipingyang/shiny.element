# Element UI Page Wrapper with Theme Support

Top-level page constructor that loads Element-UI, Vue, and layout CSS
dependencies, and supports both bslib/shiny themes and Element-UI layout
CSS.

## Usage

``` r
el_page(
  ...,
  title = NULL,
  theme = el_theme(),
  theme_css = el_layout_css_dependency(),
  offline = TRUE,
  locale = getOption("shiny.element.locale", "en"),
  dev = getOption("shiny.element.dev", FALSE)
)
```

## Arguments

- ...:

  UI elements to include in the page body.

- title:

  Optional page title.

- theme:

  Bootstrap theme for the rest of the page: a
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html).
  The default,
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md),
  carries Element's own colours, font and sizes, so Shiny's inputs and
  outputs match the Element components beside them. `NULL` gives Shiny's
  plain Bootstrap 3.

- theme_css:

  Optional Element-UI layout CSS dependency (default:
  [`el_layout_css_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_layout_css_dependency.md)).

- offline:

  Serve Element UI from the copy bundled with this package rather than
  the unpkg CDN. See
  [`element_ui_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_ui_dependency.md).

- locale:

  Language for Element UI's built-in text – pagination summaries,
  date-picker buttons, select placeholders. English by default, or
  `getOption("shiny.element.locale")` when set; `"zh-CN"` gives
  Element's own Simplified Chinese. See
  [`el_locales()`](https://kaipingyang.github.io/shiny.element/reference/el_locales.md)
  for the rest.

- dev:

  Load the development build of Vue instead of `vue.min.js`. The
  production build strips every warning, which is why a template that
  fails to compile renders nothing and says nothing. Defaults to
  `getOption("shiny.element.dev", FALSE)`, so it can be turned on for a
  whole session without touching the UI code. Set to `NULL` to disable
  Element-UI layout CSS.

## Value

A Shiny UI element.

## Details

Use this as the root UI function for your Shiny app. You can combine
bslib layouts (such as `page_sidebar`, `layout_columns`) and Element-UI
widgets (such as `el_button`).

The `el_page` function is designed to work with both bslib layouts and
Element-UI widgets. Do not mix Element-UI layout functions
(`el_container`, `el_row`, `el_col`) with bslib layouts, as they are not
compatible. The Element-UI layout functions are experimental and may be
deprecated in the future.

## Examples

``` r
el_page(
  title = "My app",
  el_input("name", value = "Ada"),
  el_button("go", "Submit", type = "primary")
)
#> <div class="container-fluid">
#>   <h2>My app</h2>
#>   <div id="name" data-el-vue-host style="display: contents">
#>     <div id="name_container" data-el-mount style="display: contents">
#>       <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#>     </div>
#>     <script type="application/json" data-el-vue>{"options":{"data":{"value":"Ada","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('name', 'clear', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('name', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#>   </div>
#>   <div id="go" data-el-vue-host style="display: contents">
#>     <div id="go_container" data-el-mount style="display: contents">
#>       <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#>     </div>
#>     <script type="application/json" data-el-vue>{"options":{"data":{"label":"Submit","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('go', this.count); } }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#>   </div>
#> </div>

# English component text, and Vue's development build for debugging
el_page(locale = "en", dev = TRUE, el_input("name"))
#> <div class="container-fluid">
#>   <div id="name" data-el-vue-host style="display: contents">
#>     <div id="name_container" data-el-mount style="display: contents">
#>       <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#>     </div>
#>     <script type="application/json" data-el-vue>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('name', 'clear', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('name', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#>   </div>
#> </div>
```
