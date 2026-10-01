# Element UI Empty

A placeholder for a view with nothing in it yet.

## Usage

``` r
el_empty(
  id = NULL,
  ...,
  description = NULL,
  image = NULL,
  image_size = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- ...:

  Content under the description – usually a button that fixes the
  emptiness. A shiny.element component here is absorbed, not nested.

- description:

  Text under the picture. `NULL` for Element's own ("No Data", in the
  page's locale).

- image:

  URL of a picture to use instead of Element's.

- image_size:

  Width of the picture, in pixels.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `image`, `description`.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Examples

``` r
el_empty("none", description = "No reports yet")
#> <div id="none_container" style="display: contents">
#>   <el-empty :description="emptyDescription === null ? undefined : emptyDescription" :image="emptyImage === null ? undefined : emptyImage" :image-size="emptyImageSize === null ? undefined : emptyImageSize"></el-empty>
#> </div>
#> <div id="none" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="none">{"x":{"el":"#none_container","data":{"emptyDescription":"No reports yet","emptyImage":null,"emptyImageSize":null}},"evals":[],"jsHooks":[]}</script>

el_empty("none", description = "No reports yet",
         el_button("create", "Create one", type = "primary"))
#> <div id="none_container" style="display: contents">
#>   <el-empty :description="emptyDescription === null ? undefined : emptyDescription" :image="emptyImage === null ? undefined : emptyImage" :image-size="emptyImageSize === null ? undefined : emptyImageSize">
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#>   </el-empty>
#> </div>
#> <div id="none" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="none">{"x":{"el":"#none_container","data":{"emptyDescription":"No reports yet","emptyImage":null,"emptyImageSize":null,"label":"Create one","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; window.Shiny && Shiny.setInputValue('create', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
```
