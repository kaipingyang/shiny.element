# Element Plus Config Provider

Settings for the components inside it: their size, the button and link
defaults, the dialog's and message's, the empty values. The page's own –
locale, size, z-index – are el_page()'s.

## Usage

``` r
el_config_provider(
  ...,
  id = NULL,
  size = NULL,
  button = NULL,
  link = NULL,
  dialog = NULL,
  message = NULL,
  experimental_features = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  table = NULL,
  width = NULL,
  slots = NULL
)
```

## Arguments

- ...:

  Its content: any Shiny UI. Components of this package are folded into
  this one's Vue instance, as
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md)
  folds its buttons.

- id:

  Component ID. Auto-generated if `NULL`.

- size:

  Global component size. Element Plus's `size` ('large' \| 'default' \|
  'small').

- button:

  Button related configuration, see the following table. Element Plus's
  `button` (object).

- link:

  Link related configuration, see the following table. Element Plus's
  `link` (`{type?: string, underline?: boolean | string}`).

- dialog:

  Dialog related configuration, see the following table. Element Plus's
  `dialog` (object).

- message:

  Message related configuration, see the following table. Element Plus's
  `message` (`{max?: number}`).

- experimental_features:

  Features at experimental stage to be added, all features are default
  to be set to false. Element Plus's `experimental-features` (object).

- empty_values:

  Global empty values of components. Element Plus's `empty-values`
  (array).

- value_on_clear:

  Global clear return value. Element Plus's `value-on-clear` (string /
  number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- table:

  Table related configuration, see the following table. Element Plus's
  `table` (object). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.

## Examples

``` r
el_config_provider(
  size = "small",
  button = list(autoInsertSpace = TRUE),
  el_button("a", "OK"),
  el_input("b")
)
#> <div id="el_config_provider_eb0cd60a-9584-441c-aee7-8cb9ba80674a" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_config_provider_eb0cd60a-9584-441c-aee7-8cb9ba80674a_container" style="display: contents">
#>   <el-config-provider :size="size === null ? undefined : size" :button="button === null ? undefined : button" :link="link === null ? undefined : link" :dialog="dialog === null ? undefined : dialog" :message="message === null ? undefined : message" :experimental-features="experimentalFeatures === null ? undefined : experimentalFeatures" :empty-values="emptyValues === null ? undefined : emptyValues" :value-on-clear="valueOnClear === null ? undefined : valueOnClear" :table="table === null ? undefined : table">
#>     <el-button :type="el2_type" :plain="el2_plain" :round="el2_round" :circle="el2_circle" :loading="el2_loading" :disabled="el2_disabled" :native-type="el2_native_type" @click="el2_handleClick" :size="el2_size === null ? undefined : el2_size" :icon="el2_icon === null ? undefined : el2_icon" :autofocus="el2_autofocus === null ? undefined : el2_autofocus" :auto-insert-space="el2_autoInsertSpace === null ? undefined : el2_autoInsertSpace" :bg="el2_bg === null ? undefined : el2_bg" :color="el2_color === null ? undefined : el2_color" :dark="el2_dark === null ? undefined : el2_dark" :dashed="el2_dashed === null ? undefined : el2_dashed" :link="el2_link === null ? undefined : el2_link" :loading-icon="el2_loadingIcon === null ? undefined : el2_loadingIcon" :tag="el2_tag === null ? undefined : el2_tag" :text="el2_text === null ? undefined : el2_text">{{el2_label}}</el-button>
#>     <el-input v-model="el3_value" :type="el3_type" :disabled="el3_disabled" :readonly="el3_readonly" :clearable="el3_clearable" :show-password="el3_showPassword" :show-word-limit="el3_showWordLimit" :autosize="el3_autosize" :prefix-icon="el3_prefixIcon" :suffix-icon="el3_suffixIcon" @change="el3_handleChange" :size="el3_size === null ? undefined : el3_size" :maxlength="el3_maxlength === null ? undefined : el3_maxlength" :rows="el3_rows === null ? undefined : el3_rows" :placeholder="el3_placeholder === null ? undefined : el3_placeholder" :label="el3_label === null ? undefined : el3_label" :autocomplete="el3_autocomplete === null ? undefined : el3_autocomplete" :autofocus="el3_autofocus === null ? undefined : el3_autofocus" :name="el3_name === null ? undefined : el3_name" :form="el3_form === null ? undefined : el3_form" :minlength="el3_minlength === null ? undefined : el3_minlength" :max="el3_max === null ? undefined : el3_max" :min="el3_min === null ? undefined : el3_min" :step="el3_step === null ? undefined : el3_step" :resize="el3_resize === null ? undefined : el3_resize" :tabindex="el3_tabindex === null ? undefined : el3_tabindex" :validate-event="el3_validateEvent === null ? undefined : el3_validateEvent" @input="el3_elEmitInput" @blur="el3_elEmitBlur" @focus="el3_elEmitFocus" @clear="el3_elEmitClear" @compositionend="el3_elEmitCompositionend" @compositionstart="el3_elEmitCompositionstart" @compositionupdate="el3_elEmitCompositionupdate" @keydown="el3_elEmitKeydown" @mouseenter="el3_elEmitMouseenter" @mouseleave="el3_elEmitMouseleave" :aria-label="el3_ariaLabel === null ? undefined : el3_ariaLabel" :clear-icon="el3_clearIcon === null ? undefined : el3_clearIcon" :count-graphemes="el3_countGraphemes === null ? undefined : el3_countGraphemes" :formatter="el3_formatter === null ? undefined : el3_formatter" :input-style="el3_inputStyle === null ? undefined : el3_inputStyle" :inputmode="el3_inputmode === null ? undefined : el3_inputmode" :parser="el3_parser === null ? undefined : el3_parser" :word-limit-position="el3_wordLimitPosition === null ? undefined : el3_wordLimitPosition"></el-input>
#>   </el-config-provider>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"size":"small","button":{"autoInsertSpace":true},"link":null,"dialog":null,"message":null,"experimentalFeatures":null,"emptyValues":null,"valueOnClear":null,"table":null,"el2_label":"OK","el2_type":"default","el2_size":null,"el2_plain":false,"el2_round":false,"el2_circle":false,"el2_loading":false,"el2_disabled":false,"el2_native_type":"button","el2_icon":null,"el2_count":0,"el2_autofocus":false,"el2_autoInsertSpace":null,"el2_bg":null,"el2_color":null,"el2_dark":null,"el2_dashed":null,"el2_link":null,"el2_loadingIcon":null,"el2_tag":null,"el2_text":null,"el3_value":"","el3_type":"text","el3_disabled":false,"el3_readonly":false,"el3_clearable":false,"el3_showPassword":false,"el3_showWordLimit":false,"el3_autosize":false,"el3_prefixIcon":null,"el3_suffixIcon":null,"el3_size":null,"el3_maxlength":null,"el3_rows":null,"el3_placeholder":null,"el3_label":null,"el3_autocomplete":null,"el3_autofocus":null,"el3_name":null,"el3_form":null,"el3_minlength":null,"el3_max":null,"el3_min":null,"el3_step":null,"el3_resize":null,"el3_tabindex":null,"el3_validateEvent":null,"el3_ariaLabel":null,"el3_clearIcon":null,"el3_countGraphemes":null,"el3_formatter":null,"el3_inputStyle":null,"el3_inputmode":null,"el3_parser":null,"el3_wordLimitPosition":null},"methods":{"el2_handleClick":"function() { if (this.el2_disabled || this.el2_loading) return; this.el2_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('a:shiny.action', this.el2_count); }","el3_elEmitInput":"function() { window.shinyVue.emit('b', 'input', arguments); }","el3_elEmitBlur":"function() { window.shinyVue.emit('b', 'blur', arguments); }","el3_elEmitFocus":"function() { window.shinyVue.emit('b', 'focus', arguments); }","el3_elEmitClear":"function() { window.shinyVue.emit('b', 'clear', arguments); }","el3_elEmitCompositionend":"function() { window.shinyVue.emit('b', 'compositionend', arguments); }","el3_elEmitCompositionstart":"function() { window.shinyVue.emit('b', 'compositionstart', arguments); }","el3_elEmitCompositionupdate":"function() { window.shinyVue.emit('b', 'compositionupdate', arguments); }","el3_elEmitKeydown":"function() { window.shinyVue.emit('b', 'keydown', arguments); }","el3_elEmitMouseenter":"function() { window.shinyVue.emit('b', 'mouseenter', arguments); }","el3_elEmitMouseleave":"function() { window.shinyVue.emit('b', 'mouseleave', arguments); }","el3_handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('b', value); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"a:shiny.action\", self.el2_count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"b\", self.el3_value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.el2_handleClick","options.methods.el3_elEmitInput","options.methods.el3_elEmitBlur","options.methods.el3_elEmitFocus","options.methods.el3_elEmitClear","options.methods.el3_elEmitCompositionend","options.methods.el3_elEmitCompositionstart","options.methods.el3_elEmitCompositionupdate","options.methods.el3_elEmitKeydown","options.methods.el3_elEmitMouseenter","options.methods.el3_elEmitMouseleave","options.methods.el3_handleChange","options.mounted"]}</script>
#> </div>
```
