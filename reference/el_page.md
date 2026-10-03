# Element Plus Page Wrapper with Theme Support

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
  dev = getOption("shiny.element.dev", FALSE),
  size = NULL,
  z_index = NULL
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

  Element's layout CSS,
  [`el_layout_css_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_layout_css_dependency.md);
  `NULL` leaves it out.

- offline:

  Serve Element Plus from the copy bundled with this package rather than
  the unpkg CDN. See
  [`element_plus_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_plus_dependency.md).

- locale:

  Language for Element Plus's built-in text – pagination summaries,
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
  whole session without touching the UI code.

- size, z_index:

  Element Plus's global config, as `app.use()` gives it: the size of
  every component not given one of its own (`"large"`, `"default"` or
  `"small"`), and the z-index its popups start from (2000 by default).
  `NULL` leaves Element's default.

## Value

A Shiny UI element.

## Details

Use this as the root UI function for your Shiny app. You can combine
bslib layouts (such as `page_sidebar`, `layout_columns`) and Element
components (such as `el_button`).

Element's layout
([`el_container()`](https://kaipingyang.github.io/shiny.element/reference/el_container.md),
[`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md),
[`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md))
and bslib's (`page_sidebar()`, `layout_columns()`) each work here; nest
one inside a cell of the other rather than interleaving them.

## Examples

``` r
el_page(
  title = "My app",
  el_input("name", value = "Ada"),
  el_button("go", "Submit", type = "primary")
)
#> <div class="container-fluid">
#>   <h2>My app</h2>
#>   <div id="name" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="name_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @compositionend="elEmitCompositionend" @compositionstart="elEmitCompositionstart" @compositionupdate="elEmitCompositionupdate" @keydown="elEmitKeydown" @mouseenter="elEmitMouseenter" @mouseleave="elEmitMouseleave" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"Ada","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('name', 'clear', arguments); }","elEmitCompositionend":"function() { window.shinyVue.emit('name', 'compositionend', arguments); }","elEmitCompositionstart":"function() { window.shinyVue.emit('name', 'compositionstart', arguments); }","elEmitCompositionupdate":"function() { window.shinyVue.emit('name', 'compositionupdate', arguments); }","elEmitKeydown":"function() { window.shinyVue.emit('name', 'keydown', arguments); }","elEmitMouseenter":"function() { window.shinyVue.emit('name', 'mouseenter', arguments); }","elEmitMouseleave":"function() { window.shinyVue.emit('name', 'mouseleave', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitCompositionend","options.methods.elEmitCompositionstart","options.methods.elEmitCompositionupdate","options.methods.elEmitKeydown","options.methods.elEmitMouseenter","options.methods.elEmitMouseleave","options.methods.handleChange"]}</script>
#>   </div>
#>   <div id="go" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="go_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Submit","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","evals":["options.methods.handleClick"]}</script>
#>   </div>
#> </div>

# English component text, and Vue's development build for debugging
el_page(locale = "en", dev = TRUE, el_input("name"))
#> <div class="container-fluid">
#>   <div id="name" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="name_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @compositionend="elEmitCompositionend" @compositionstart="elEmitCompositionstart" @compositionupdate="elEmitCompositionupdate" @keydown="elEmitKeydown" @mouseenter="elEmitMouseenter" @mouseleave="elEmitMouseleave" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('name', 'input', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('name', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('name', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('name', 'clear', arguments); }","elEmitCompositionend":"function() { window.shinyVue.emit('name', 'compositionend', arguments); }","elEmitCompositionstart":"function() { window.shinyVue.emit('name', 'compositionstart', arguments); }","elEmitCompositionupdate":"function() { window.shinyVue.emit('name', 'compositionupdate', arguments); }","elEmitKeydown":"function() { window.shinyVue.emit('name', 'keydown', arguments); }","elEmitMouseenter":"function() { window.shinyVue.emit('name', 'mouseenter', arguments); }","elEmitMouseleave":"function() { window.shinyVue.emit('name', 'mouseleave', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitCompositionend","options.methods.elEmitCompositionstart","options.methods.elEmitCompositionupdate","options.methods.elEmitKeydown","options.methods.elEmitMouseenter","options.methods.elEmitMouseleave","options.methods.handleChange"]}</script>
#>   </div>
#> </div>
```
