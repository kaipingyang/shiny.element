# Element UI Page Wrapper with Theme Support

Top-level page constructor that loads Element-UI, Vue, and layout CSS
dependencies, and supports both bslib/shiny themes and Element-UI layout
CSS.

## Usage

``` r
el_page(
  ...,
  title = NULL,
  theme = bslib::bs_theme(version = 5, bootswatch = "minty"),
  theme_css = el_layout_css_dependency(),
  offline = TRUE,
  locale = NULL,
  dev = getOption("shiny.element.dev", FALSE)
)
```

## Arguments

- ...:

  UI elements to include in the page body.

- title:

  Optional page title.

- theme:

  Optional bslib or shiny theme object (e.g., `bs_theme()`) for
  Bootstrap styling. If provided, Bootstrap dependencies will be
  included.

- theme_css:

  Optional Element-UI layout CSS dependency (default:
  [`el_layout_css_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_layout_css_dependency.md)).

- offline:

  Serve Element UI from the copy bundled with this package rather than
  the unpkg CDN. See
  [`element_ui_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_ui_dependency.md).

- locale:

  Language for Element UI's built-in text – pagination summaries,
  date-picker buttons and so on. `NULL` keeps its bundled Simplified
  Chinese; `"en"` is also bundled. See
  [`el_locale_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_locale_dependency.md).

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
#>   <div id="name_container" style="display: contents">
#>     <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label"></el-input>
#>   </div>
#>   <div id="name" style="width:0px;height:0px;" class="vue html-widget"></div>
#>   <script type="application/json" data-for="name">{"x":{"el":"#name_container","data":{"value":"Ada","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('name', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"name\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>   <div id="go_container" style="display: contents">
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size">{{label}}</el-button>
#>   </div>
#>   <div id="go" style="width:0px;height:0px;" class="vue html-widget"></div>
#>   <script type="application/json" data-for="go">{"x":{"el":"#go_container","data":{"label":"Submit","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","count":0},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('go', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
#> </div>

# English component text, and Vue's development build for debugging
el_page(locale = "en", dev = TRUE, el_input("name"))
#> <div class="container-fluid">
#>   <div id="name_container" style="display: contents">
#>     <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label"></el-input>
#>   </div>
#>   <div id="name" style="width:0px;height:0px;" class="vue html-widget"></div>
#>   <script type="application/json" data-for="name">{"x":{"el":"#name_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('name', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"name\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#> </div>
```
