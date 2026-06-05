# Element UI Color Picker

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
  session = shiny::getDefaultReactiveDomain()
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

  Component size: `NULL`, `"medium"`, `"small"`, `"mini"`.

- show_alpha:

  Whether to show an alpha channel slider. Default `FALSE`. When `TRUE`,
  the returned value is an `rgba(...)` string.

- color_format:

  Output format: `NULL` (auto), `"hex"`, `"rgb"`, `"hsv"`, `"hsl"`.

- predefine:

  Character vector of preset colour swatches. `NULL` for none.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed color-picker component.

## Shiny input

`input$<id>` — colour string (e.g. `"#409EFF"` or
`"rgba(64,158,255,0.5)"`). `NULL` / `NA` when the user clears the
picker.

## Examples

``` r
el_color_picker("cp1", value = "#409EFF")
#> <div id="cp1_container">
#>   <el-color-picker v-model="value" :disabled="disabled" :show-alpha="showAlpha" @change="handleChange"></el-color-picker>
#> </div>
#> <div class="vue html-widget html-fill-item" id="cp1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="cp1">{"x":{"el":"#cp1_container","data":{"value":"#409EFF","disabled":false,"showAlpha":false},"methods":{"handleChange":"function(val) { Shiny.setInputValue('cp1', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
el_color_picker("cp2", show_alpha = TRUE, predefine = c("#ff4500", "#ff8c00"))
#> <div id="cp2_container">
#>   <el-color-picker v-model="value" :disabled="disabled" :show-alpha="showAlpha" @change="handleChange" :predefine="predefine"></el-color-picker>
#> </div>
#> <div class="vue html-widget html-fill-item" id="cp2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="cp2">{"x":{"el":"#cp2_container","data":{"value":null,"disabled":false,"showAlpha":true,"predefine":["#ff4500","#ff8c00"]},"methods":{"handleChange":"function(val) { Shiny.setInputValue('cp2', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
```
