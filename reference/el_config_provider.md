# Element Plus Config Provider

Settings for the components inside it: their size, the button and link
defaults, the card's, the dialog's and message's, the empty values, and
their language. The page's own – its locale, size, z-index – are
el_page()'s.

## Usage

``` r
el_config_provider(
  ...,
  id = NULL,
  locale = NULL,
  size = NULL,
  button = NULL,
  link = NULL,
  dialog = NULL,
  message = NULL,
  experimental_features = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  table = NULL,
  card = NULL,
  width = NULL,
  slots = NULL
)

update_el_config_provider(
  session = shiny::getDefaultReactiveDomain(),
  id,
  locale = NULL,
  card = NULL,
  size = NULL,
  button = NULL,
  link = NULL,
  dialog = NULL,
  message = NULL,
  experimental_features = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  table = NULL
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

- locale:

  The language of the components inside it, as
  [`el_locale_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_locale_dependency.md)
  names one (`"zh-cn"`), where `el_page(locale =)` sets the page's.
  Element Plus's `locale`.

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

- card:

  Card related configuration: `list(shadow = "hover")`, for the cards
  inside it that set no shadow of their own. Element Plus's `card`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.

## Updating from the server

`update_el_config_provider()` changes the component from the server:
every argument of `el_config_provider()` that can change once it is
drawn, under the same name. One left `NULL` stays as it is; `NA` returns
it to Element's default.

`update_el_config_provider()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_config_provider(
  size = "small",
  button = list(autoInsertSpace = TRUE),
  el_button("a", "OK"),
  el_input("b")
)
#> <div id="el_config_provider_966c0514-9a2e-4d79-a5a8-15fd45ff7696" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_config_provider_966c0514-9a2e-4d79-a5a8-15fd45ff7696_container" style="display: contents">
#>   <el-config-provider :locale="$elLocale(locale)" :card="card === null ? undefined : card" :size="size === null ? undefined : size" :button="button === null ? undefined : button" :link="link === null ? undefined : link" :dialog="dialog === null ? undefined : dialog" :message="message === null ? undefined : message" :experimental-features="experimentalFeatures === null ? undefined : experimentalFeatures" :empty-values="emptyValues === null ? undefined : emptyValues" :value-on-clear="valueOnClear === null ? undefined : valueOnClear" :table="table === null ? undefined : table">
#>     <div class="el-provider-scope" style="display: contents" :data-card-shadow="card &amp;&amp; card.shadow ? card.shadow : &#39;&#39;" :data-dialog="dialog ? JSON.stringify(dialog) : &#39;&#39;">
#>       <el-button :type="el2_type === null ? undefined : el2_type" :plain="el2_plain === null ? undefined : el2_plain" :round="el2_round === null ? undefined : el2_round" :circle="el2_circle" :loading="el2_loading" :disabled="el2_disabled" :native-type="el2_native_type" @click="el2_handleClick" :size="el2_size === null ? undefined : el2_size" :icon="el2_icon === null ? undefined : el2_icon" :autofocus="el2_autofocus === null ? undefined : el2_autofocus" :auto-insert-space="el2_autoInsertSpace === null ? undefined : el2_autoInsertSpace" :bg="el2_bg === null ? undefined : el2_bg" :color="el2_color === null ? undefined : el2_color" :dark="el2_dark === null ? undefined : el2_dark" :dashed="el2_dashed === null ? undefined : el2_dashed" :link="el2_link === null ? undefined : el2_link" :loading-icon="el2_loadingIcon === null ? undefined : el2_loadingIcon" :tag="el2_tag === null ? undefined : el2_tag" :text="el2_text === null ? undefined : el2_text" ref="sv_a">{{el2_label}}</el-button>
#>       <el-input v-model="el2_el2_value" :type="el2_el2_type" :disabled="el2_el2_disabled" :readonly="el2_el2_readonly" :clearable="el2_el2_clearable" :show-password="el2_el2_showPassword" :show-word-limit="el2_el2_showWordLimit" :autosize="el2_el2_autosize" :prefix-icon="el2_el2_prefixIcon" :suffix-icon="el2_el2_suffixIcon" @change="el2_el2_handleChange" :size="el2_el2_size === null ? undefined : el2_el2_size" :maxlength="el2_el2_maxlength === null ? undefined : el2_el2_maxlength" :rows="el2_el2_rows === null ? undefined : el2_el2_rows" :placeholder="el2_el2_placeholder === null ? undefined : el2_el2_placeholder" :label="el2_el2_label === null ? undefined : el2_el2_label" :autocomplete="el2_el2_autocomplete === null ? undefined : el2_el2_autocomplete" :autofocus="el2_el2_autofocus === null ? undefined : el2_el2_autofocus" :name="el2_el2_name === null ? undefined : el2_el2_name" :form="el2_el2_form === null ? undefined : el2_el2_form" :minlength="el2_el2_minlength === null ? undefined : el2_el2_minlength" :max="el2_el2_max === null ? undefined : el2_el2_max" :min="el2_el2_min === null ? undefined : el2_el2_min" :step="el2_el2_step === null ? undefined : el2_el2_step" :resize="el2_el2_resize === null ? undefined : el2_el2_resize" :tabindex="el2_el2_tabindex === null ? undefined : el2_el2_tabindex" :validate-event="el2_el2_validateEvent === null ? undefined : el2_el2_validateEvent" @input="el2_el2_elEmitInput" @blur="el2_el2_elEmitBlur" @focus="el2_el2_elEmitFocus" @clear="el2_el2_elEmitClear" @compositionend="el2_el2_elEmitCompositionend" @compositionstart="el2_el2_elEmitCompositionstart" @compositionupdate="el2_el2_elEmitCompositionupdate" @keydown="el2_el2_elEmitKeydown" @mouseenter="el2_el2_elEmitMouseenter" @mouseleave="el2_el2_elEmitMouseleave" :aria-label="el2_el2_ariaLabel === null ? undefined : el2_el2_ariaLabel" :clear-icon="el2_el2_clearIcon === null ? undefined : el2_el2_clearIcon" :count-graphemes="el2_el2_countGraphemes === null ? undefined : el2_el2_countGraphemes" :formatter="el2_el2_formatter === null ? undefined : el2_el2_formatter" :input-style="el2_el2_inputStyle === null ? undefined : el2_el2_inputStyle" :inputmode="el2_el2_inputmode === null ? undefined : el2_el2_inputmode" :parser="el2_el2_parser === null ? undefined : el2_el2_parser" :word-limit-position="el2_el2_wordLimitPosition === null ? undefined : el2_el2_wordLimitPosition" ref="sv_b"></el-input>
#>     </div>
#>   </el-config-provider>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"locale":null,"card":null,"size":"small","button":{"autoInsertSpace":true},"link":null,"dialog":null,"message":null,"experimentalFeatures":null,"emptyValues":null,"valueOnClear":null,"table":null,"el2_label":"OK","el2_type":null,"el2_size":null,"el2_plain":null,"el2_round":null,"el2_circle":false,"el2_loading":false,"el2_disabled":false,"el2_native_type":"button","el2_icon":null,"el2_count":0,"el2_autofocus":false,"el2_autoInsertSpace":null,"el2_bg":null,"el2_color":null,"el2_dark":null,"el2_dashed":null,"el2_link":null,"el2_loadingIcon":null,"el2_tag":null,"el2_text":null,"el2_el2_value":"","el2_el2_type":"text","el2_el2_disabled":false,"el2_el2_readonly":false,"el2_el2_clearable":false,"el2_el2_showPassword":false,"el2_el2_showWordLimit":false,"el2_el2_autosize":false,"el2_el2_prefixIcon":null,"el2_el2_suffixIcon":null,"el2_el2_size":null,"el2_el2_maxlength":null,"el2_el2_rows":null,"el2_el2_placeholder":null,"el2_el2_label":null,"el2_el2_autocomplete":null,"el2_el2_autofocus":null,"el2_el2_name":null,"el2_el2_form":null,"el2_el2_minlength":null,"el2_el2_max":null,"el2_el2_min":null,"el2_el2_step":null,"el2_el2_resize":null,"el2_el2_tabindex":null,"el2_el2_validateEvent":null,"el2_el2_ariaLabel":null,"el2_el2_clearIcon":null,"el2_el2_countGraphemes":null,"el2_el2_formatter":null,"el2_el2_inputStyle":null,"el2_el2_inputmode":null,"el2_el2_parser":null,"el2_el2_wordLimitPosition":null},"methods":{"el2_handleClick":"function() { if (this.el2_disabled || this.el2_loading) return; this.el2_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('a:shiny.action', this.el2_count); }","el2_el2_elEmitInput":"function() { window.shinyVue.emit('b', 'input', arguments); }","el2_el2_elEmitBlur":"function() { window.shinyVue.emit('b', 'blur', arguments); }","el2_el2_elEmitFocus":"function() { window.shinyVue.emit('b', 'focus', arguments); }","el2_el2_elEmitClear":"function() { window.shinyVue.emit('b', 'clear', arguments); }","el2_el2_elEmitCompositionend":"function() { window.shinyVue.emit('b', 'compositionend', arguments); }","el2_el2_elEmitCompositionstart":"function() { window.shinyVue.emit('b', 'compositionstart', arguments); }","el2_el2_elEmitCompositionupdate":"function() { window.shinyVue.emit('b', 'compositionupdate', arguments); }","el2_el2_elEmitKeydown":"function() { window.shinyVue.emit('b', 'keydown', arguments); }","el2_el2_elEmitMouseenter":"function() { window.shinyVue.emit('b', 'mouseenter', arguments); }","el2_el2_elEmitMouseleave":"function() { window.shinyVue.emit('b', 'mouseleave', arguments); }","el2_el2_handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('b', value); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"a:shiny.action\", self.el2_count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"b\", self.el2_el2_value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"a":{"fields":{"label":"el2_label","type":"el2_type","size":"el2_size","plain":"el2_plain","round":"el2_round","circle":"el2_circle","loading":"el2_loading","disabled":"el2_disabled","native_type":"el2_native_type","icon":"el2_icon","count":"el2_count","autofocus":"el2_autofocus","autoInsertSpace":"el2_autoInsertSpace","bg":"el2_bg","color":"el2_color","dark":"el2_dark","dashed":"el2_dashed","link":"el2_link","loadingIcon":"el2_loadingIcon","tag":"el2_tag","text":"el2_text","handleClick":"el2_handleClick"},"ref":"sv_a"},"b":{"fields":{"value":"el2_el2_value","type":"el2_el2_type","disabled":"el2_el2_disabled","readonly":"el2_el2_readonly","clearable":"el2_el2_clearable","showPassword":"el2_el2_showPassword","showWordLimit":"el2_el2_showWordLimit","autosize":"el2_el2_autosize","prefixIcon":"el2_el2_prefixIcon","suffixIcon":"el2_el2_suffixIcon","size":"el2_el2_size","maxlength":"el2_el2_maxlength","rows":"el2_el2_rows","placeholder":"el2_el2_placeholder","label":"el2_el2_label","autocomplete":"el2_el2_autocomplete","autofocus":"el2_el2_autofocus","name":"el2_el2_name","form":"el2_el2_form","minlength":"el2_el2_minlength","max":"el2_el2_max","min":"el2_el2_min","step":"el2_el2_step","resize":"el2_el2_resize","tabindex":"el2_el2_tabindex","validateEvent":"el2_el2_validateEvent","ariaLabel":"el2_el2_ariaLabel","clearIcon":"el2_el2_clearIcon","countGraphemes":"el2_el2_countGraphemes","formatter":"el2_el2_formatter","inputStyle":"el2_el2_inputStyle","inputmode":"el2_el2_inputmode","parser":"el2_el2_parser","wordLimitPosition":"el2_el2_wordLimitPosition","elEmitInput":"el2_el2_elEmitInput","elEmitBlur":"el2_el2_elEmitBlur","elEmitFocus":"el2_el2_elEmitFocus","elEmitClear":"el2_el2_elEmitClear","elEmitCompositionend":"el2_el2_elEmitCompositionend","elEmitCompositionstart":"el2_el2_elEmitCompositionstart","elEmitCompositionupdate":"el2_el2_elEmitCompositionupdate","elEmitKeydown":"el2_el2_elEmitKeydown","elEmitMouseenter":"el2_el2_elEmitMouseenter","elEmitMouseleave":"el2_el2_elEmitMouseleave","handleChange":"el2_el2_handleChange"},"ref":"sv_b","input":"value"}},"generated":true,"evals":["options.methods.el2_handleClick","options.methods.el2_el2_elEmitInput","options.methods.el2_el2_elEmitBlur","options.methods.el2_el2_elEmitFocus","options.methods.el2_el2_elEmitClear","options.methods.el2_el2_elEmitCompositionend","options.methods.el2_el2_elEmitCompositionstart","options.methods.el2_el2_elEmitCompositionupdate","options.methods.el2_el2_elEmitKeydown","options.methods.el2_el2_elEmitMouseenter","options.methods.el2_el2_elEmitMouseleave","options.methods.el2_el2_handleChange","options.mounted"]}</script>
#> </div>
```
