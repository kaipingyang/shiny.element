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
  dev = .vue_dev(),
  size = NULL,
  z_index = NULL,
  loading = TRUE
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
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_theme.md),
  carries Element's own colours, font and sizes, so Shiny's inputs and
  outputs match the Element components beside them. `NULL` gives Shiny's
  plain Bootstrap 3.

- theme_css:

  Element's layout CSS,
  [`el_layout_css_dependency()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_layout_css_dependency.md);
  `NULL` leaves it out.

- offline:

  Serve Element Plus from the copy bundled with this package rather than
  the unpkg CDN. See
  [`element_plus_dependency()`](https://kaipingyang.github.io/shiny.element/dev/reference/element_plus_dependency.md).

- locale:

  Language for Element Plus's built-in text – pagination summaries,
  date-picker buttons, select placeholders. English by default, or
  `getOption("shiny.element.locale")` when set; `"zh-CN"` gives
  Element's own Simplified Chinese. See
  [`el_locales()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_locales.md)
  for the rest.

- dev:

  Load Vue's development build (`vue.global.js`) instead of the
  production one. The production build strips every warning, which is
  why a template that fails to compile renders nothing and says nothing.
  Defaults to `getOption("shiny.vue.dev")` (or `shiny.element.dev`),
  `FALSE` unless set, so it can be turned on for a whole session without
  touching the UI code. A package installed from CRAN does not carry the
  development build and loads it from the unpkg CDN; one installed from
  its sources has it.

- size, z_index:

  Element Plus's global config, as `app.use()` gives it: the size of
  every component not given one of its own (`"large"`, `"default"` or
  `"small"`), and the z-index its popups start from (2000 by default).
  `NULL` leaves Element's default.

- loading:

  Cover the page with Element's loading mask until its components are
  drawn and Shiny is connected. Every component is an application of its
  own, compiled and mounted in the browser, so a page of many shows
  nothing usable for a moment – seconds, with a few hundred on a slow
  machine; the mask says it is coming. `TRUE` by default; it goes after
  10 seconds whatever happens. See the Performance article for what
  makes a page slow to start.

## Value

A Shiny UI element.

## Details

Use this as the root UI function for your Shiny app. You can combine
bslib layouts (such as `page_sidebar`, `layout_columns`) and Element
components (such as `el_button`).

Element's layout
([`el_container()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_container.md),
[`el_row()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_row.md),
[`el_col()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_col.md))
and bslib's (`page_sidebar()`, `layout_columns()`) each work here; nest
one inside a cell of the other rather than interleaving them.

A page returned by
[`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) works
there too. Like Shiny's and bslib's page functions it is a whole page,
not one tag, so shinyjs's `hidden()` cannot wrap it: hide its output
instead – `shinyjs::hidden(uiOutput("id"))`, or `shinyjs::hide("id")`
later. Inside
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) the
components alone are enough: each brings what it needs.

## Examples

``` r
el_page(
  title = "My app",
  el_input("name", value = "Ada"),
  el_button("go", "Submit", type = "primary")
)
#> <div class="container-fluid">
#>   <style>.shiny-html-output .el-page-loading { display: none !important; }</style>
#>   <div class="el-loading-mask is-fullscreen el-page-loading" style="z-index: 3000;" aria-busy="true">
#>     <div class="el-loading-spinner"><svg class="circular" viewBox="0 0 50 50"><circle class="path" cx="25" cy="25" r="20" fill="none"></circle></svg></div>
#>   </div>
#>   <script>(function() {
#>   var mask = document.currentScript && document.currentScript.previousElementSibling;
#>   if (document.readyState !== 'loading' || !mask || !mask.classList.contains('el-page-loading')) {
#>     // drawn later, by renderUI(): its components are drawn as it arrives
#>     document.querySelectorAll('.shiny-html-output .el-page-loading').forEach(function(m) { m.remove(); });
#>     if (mask && mask.classList.contains('el-page-loading')) mask.remove();
#>     return;
#>   }
#>   var done = false;
#>   function hide() {
#>     if (done) return;
#>     done = true;
#>     mask.style.opacity = '0';
#>     setTimeout(function() { mask.remove(); }, 300);
#>   }
#>   function ready() {
#>     var hosts = document.querySelectorAll('[data-shiny-vue]').length;
#>     var roots = document.querySelectorAll('[data-shiny-vue-root]').length;
#>     var shiny = !window.Shiny ||
#>       (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected());
#>     return roots >= hosts && shiny;
#>   }
#>   function poll() { if (done) return; if (ready()) hide(); else setTimeout(poll, 50); }
#>   setTimeout(hide, 10000);
#>   document.addEventListener('DOMContentLoaded', poll);
#> })();</script>
#>   <h2>My app</h2>
#>   <div id="name" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="name_container" style="display: contents">
#>   <el-input v-bind="$optional(&#39;input&#39;)" v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange"></el-input>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"Ada","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"placeholder":null,"maxlength":null,"rows":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"optional":{"input":{"size":"size","placeholder":"placeholder","maxlength":"maxlength","rows":"rows","label":"label","autocomplete":"autocomplete","autofocus":"autofocus","name":"name","form":"form","minlength":"minlength","max":"max","min":"min","step":"step","resize":"resize","tabindex":"tabindex","validate-event":"validateEvent","aria-label":"ariaLabel","clear-icon":"clearIcon","count-graphemes":"countGraphemes","formatter":"formatter","input-style":"inputStyle","inputmode":"inputmode","parser":"parser","word-limit-position":"wordLimitPosition"}},"evals":["options.methods.handleChange"]}</script>
#>   </div>
#>   <div id="go" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="go_container" style="display: contents">
#>   <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Submit","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":"primary","plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"optional":{"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"evals":["options.methods.handleClick"]}</script>
#>   </div>
#> </div>

# English component text, and Vue's development build for debugging
el_page(locale = "en", dev = TRUE, el_input("name"))
#> <div class="container-fluid">
#>   <style>.shiny-html-output .el-page-loading { display: none !important; }</style>
#>   <div class="el-loading-mask is-fullscreen el-page-loading" style="z-index: 3000;" aria-busy="true">
#>     <div class="el-loading-spinner"><svg class="circular" viewBox="0 0 50 50"><circle class="path" cx="25" cy="25" r="20" fill="none"></circle></svg></div>
#>   </div>
#>   <script>(function() {
#>   var mask = document.currentScript && document.currentScript.previousElementSibling;
#>   if (document.readyState !== 'loading' || !mask || !mask.classList.contains('el-page-loading')) {
#>     // drawn later, by renderUI(): its components are drawn as it arrives
#>     document.querySelectorAll('.shiny-html-output .el-page-loading').forEach(function(m) { m.remove(); });
#>     if (mask && mask.classList.contains('el-page-loading')) mask.remove();
#>     return;
#>   }
#>   var done = false;
#>   function hide() {
#>     if (done) return;
#>     done = true;
#>     mask.style.opacity = '0';
#>     setTimeout(function() { mask.remove(); }, 300);
#>   }
#>   function ready() {
#>     var hosts = document.querySelectorAll('[data-shiny-vue]').length;
#>     var roots = document.querySelectorAll('[data-shiny-vue-root]').length;
#>     var shiny = !window.Shiny ||
#>       (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected());
#>     return roots >= hosts && shiny;
#>   }
#>   function poll() { if (done) return; if (ready()) hide(); else setTimeout(poll, 50); }
#>   setTimeout(hide, 10000);
#>   document.addEventListener('DOMContentLoaded', poll);
#> })();</script>
#>   <div id="name" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="name_container" style="display: contents">
#>   <el-input v-bind="$optional(&#39;input&#39;)" v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange"></el-input>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"placeholder":null,"maxlength":null,"rows":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"optional":{"input":{"size":"size","placeholder":"placeholder","maxlength":"maxlength","rows":"rows","label":"label","autocomplete":"autocomplete","autofocus":"autofocus","name":"name","form":"form","minlength":"minlength","max":"max","min":"min","step":"step","resize":"resize","tabindex":"tabindex","validate-event":"validateEvent","aria-label":"ariaLabel","clear-icon":"clearIcon","count-graphemes":"countGraphemes","formatter":"formatter","input-style":"inputStyle","inputmode":"inputmode","parser":"parser","word-limit-position":"wordLimitPosition"}},"evals":["options.methods.handleChange"]}</script>
#>   </div>
#> </div>
```
