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
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_button_group.md)
  folds its buttons.

- id:

  Component ID. Auto-generated if `NULL`.

- locale:

  The language of the components inside it, as
  [`el_locale_dependency()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_locale_dependency.md)
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
  number / boolean / Function, or `null`): a value as it is, a function
  as
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md),
  `null` as `JS("null")`. `NULL` leaves Element's default.

- table:

  Table related configuration, see the following table. Element Plus's
  `table` (object). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md).

- card:

  Card related configuration: `list(shadow = "hover")`, for the cards
  inside it that set no shadow of their own. Element Plus's `card`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/dev/reference/template.md).

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
#> <div id="el_config_provider_34f128db-17b7-4649-af6d-345eccc49a9e" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_config_provider_34f128db-17b7-4649-af6d-345eccc49a9e_container" style="display: contents">
#>   <el-config-provider v-bind="$optional(&#39;config-provider&#39;)" :locale="$elLocale(locale)">
#>     <div class="el-provider-scope" style="display: contents" :data-card-shadow="card &amp;&amp; card.shadow ? card.shadow : &#39;&#39;" :data-dialog="dialog ? JSON.stringify(dialog) : &#39;&#39;" :data-config="JSON.stringify({&#39;locale&#39;: locale, &#39;size&#39;: size, &#39;button&#39;: button, &#39;link&#39;: link, &#39;card&#39;: card, &#39;dialog&#39;: dialog, &#39;message&#39;: message, &#39;table&#39;: table, &#39;emptyValues&#39;: emptyValues, &#39;valueOnClear&#39;: valueOnClear, &#39;experimentalFeatures&#39;: experimentalFeatures})">
#>       <el-button v-bind="$optional(&#39;el2_button&#39;)" :circle="el2_circle" :loading="el2_loading" :disabled="el2_disabled" :native-type="el2_native_type" @click="el2_handleClick" ref="sv_a" id="a">{{el2_label}}</el-button>
#>       <el-input v-bind="$optional(&#39;el3_input&#39;)" v-model="el3_value" :type="el3_type" :disabled="el3_disabled" :readonly="el3_readonly" :clearable="el3_clearable" :show-password="el3_showPassword" :show-word-limit="el3_showWordLimit" :autosize="el3_autosize" :prefix-icon="el3_prefixIcon" :suffix-icon="el3_suffixIcon" @change="el3_handleChange" ref="sv_b" id="b"></el-input>
#>     </div>
#>   </el-config-provider>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"locale":null,"card":null,"size":"small","button":{"autoInsertSpace":true},"link":null,"dialog":null,"message":null,"experimentalFeatures":null,"emptyValues":null,"valueOnClear":null,"table":null,"el2_label":"OK","el2_circle":false,"el2_loading":false,"el2_disabled":false,"el2_native_type":"button","el2_count":0,"el2_state":"ready","el2_size":null,"el2_icon":null,"el2_autofocus":false,"el2_type":null,"el2_plain":null,"el2_round":null,"el2_autoInsertSpace":null,"el2_bg":null,"el2_color":null,"el2_dark":null,"el2_dashed":null,"el2_link":null,"el2_loadingIcon":null,"el2_tag":null,"el2_text":null,"el3_value":"","el3_type":"text","el3_disabled":false,"el3_readonly":false,"el3_clearable":false,"el3_showPassword":false,"el3_showWordLimit":false,"el3_autosize":false,"el3_prefixIcon":null,"el3_suffixIcon":null,"el3_size":null,"el3_placeholder":null,"el3_maxlength":null,"el3_rows":null,"el3_label":null,"el3_autocomplete":null,"el3_autofocus":null,"el3_name":null,"el3_form":null,"el3_minlength":null,"el3_max":null,"el3_min":null,"el3_step":null,"el3_resize":null,"el3_tabindex":null,"el3_validateEvent":null,"el3_ariaLabel":null,"el3_clearIcon":null,"el3_countGraphemes":null,"el3_formatter":null,"el3_inputStyle":null,"el3_inputmode":null,"el3_parser":null,"el3_wordLimitPosition":null},"methods":{"el2_handleClick":"function() { if (this.el2_disabled || this.el2_loading || this.el2_state === 'busy') return; this.el2_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('a:shiny.action', this.el2_count); }","el3_handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('b', value); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"a:shiny.action\", self.el2_count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"b\", self.el3_value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"config-provider":{"card":"card","size":"size","button":"button","link":"link","dialog":"dialog","message":"message","experimental-features":"experimentalFeatures","empty-values":"emptyValues","value-on-clear":"valueOnClear","table":"table"},"el2_button":{"size":"el2_size","icon":"el2_icon","autofocus":"el2_autofocus","type":"el2_type","plain":"el2_plain","round":"el2_round","auto-insert-space":"el2_autoInsertSpace","bg":"el2_bg","color":"el2_color","dark":"el2_dark","dashed":"el2_dashed","link":"el2_link","loading-icon":"el2_loadingIcon","tag":"el2_tag","text":"el2_text"},"el3_input":{"size":"el3_size","placeholder":"el3_placeholder","maxlength":"el3_maxlength","rows":"el3_rows","label":"el3_label","autocomplete":"el3_autocomplete","autofocus":"el3_autofocus","name":"el3_name","form":"el3_form","minlength":"el3_minlength","max":"el3_max","min":"el3_min","step":"el3_step","resize":"el3_resize","tabindex":"el3_tabindex","validate-event":"el3_validateEvent","aria-label":"el3_ariaLabel","clear-icon":"el3_clearIcon","count-graphemes":"el3_countGraphemes","formatter":"el3_formatter","input-style":"el3_inputStyle","inputmode":"el3_inputmode","parser":"el3_parser","word-limit-position":"el3_wordLimitPosition"}},"absorbed":{"a":{"fields":{"label":"el2_label","circle":"el2_circle","loading":"el2_loading","disabled":"el2_disabled","native_type":"el2_native_type","count":"el2_count","state":"el2_state","size":"el2_size","icon":"el2_icon","autofocus":"el2_autofocus","type":"el2_type","plain":"el2_plain","round":"el2_round","autoInsertSpace":"el2_autoInsertSpace","bg":"el2_bg","color":"el2_color","dark":"el2_dark","dashed":"el2_dashed","link":"el2_link","loadingIcon":"el2_loadingIcon","tag":"el2_tag","text":"el2_text","handleClick":"el2_handleClick"},"ref":"sv_a"},"b":{"fields":{"value":"el3_value","type":"el3_type","disabled":"el3_disabled","readonly":"el3_readonly","clearable":"el3_clearable","showPassword":"el3_showPassword","showWordLimit":"el3_showWordLimit","autosize":"el3_autosize","prefixIcon":"el3_prefixIcon","suffixIcon":"el3_suffixIcon","size":"el3_size","placeholder":"el3_placeholder","maxlength":"el3_maxlength","rows":"el3_rows","label":"el3_label","autocomplete":"el3_autocomplete","autofocus":"el3_autofocus","name":"el3_name","form":"el3_form","minlength":"el3_minlength","max":"el3_max","min":"el3_min","step":"el3_step","resize":"el3_resize","tabindex":"el3_tabindex","validateEvent":"el3_validateEvent","ariaLabel":"el3_ariaLabel","clearIcon":"el3_clearIcon","countGraphemes":"el3_countGraphemes","formatter":"el3_formatter","inputStyle":"el3_inputStyle","inputmode":"el3_inputmode","parser":"el3_parser","wordLimitPosition":"el3_wordLimitPosition","handleChange":"el3_handleChange"},"ref":"sv_b","input":"value"}},"generated":true,"evals":["options.methods.el2_handleClick","options.methods.el3_handleChange","options.mounted"]}</script>
#> </div>
```
