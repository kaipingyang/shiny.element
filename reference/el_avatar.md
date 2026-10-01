# Element UI Avatar

A user avatar, from an image, an icon, or text.

## Usage

``` r
el_avatar(
  id = NULL,
  content = NULL,
  src = NULL,
  icon = NULL,
  size = NULL,
  shape = NULL,
  fit = NULL,
  src_set = NULL,
  alt = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Avatar ID. Auto-generated if `NULL`.

- content:

  Text shown when there is no `src` or `icon`, such as initials.

- src:

  Image URL.

- icon:

  Element icon class, such as `"el-icon-user-solid"`.

- size:

  `"large"` (default), `"medium"`, `"small"`, or a number of pixels.

- shape:

  `"circle"` (default) or `"square"`.

- fit:

  How an image fills the avatar: `"cover"` (default), `"fill"`,
  `"contain"`, `"none"` or `"scale-down"`.

- src_set:

  Candidate image sources, as a `srcset` string.

- alt:

  Alternative text for the image.

- width:

  Component width, as a CSS unit.

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

A Shiny UI element.

## Shiny inputs

- `input$<id>_error` – fires when the image fails to load.

## Examples

``` r
el_avatar("me", src = "https://example.org/face.png")
#> <div id="me" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="me_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"content":null,"src":"https://example.org/face.png","icon":null,"size":null,"shape":null,"fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyElement.emit('me', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitError"]}</script>
#> </div>
el_avatar("initials", content = "KY", shape = "square", size = 40)
#> <div id="initials" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="initials_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"content":"KY","src":null,"icon":null,"size":40,"shape":"square","fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyElement.emit('initials', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitError"]}</script>
#> </div>
el_avatar("anon", icon = "el-icon-user-solid")
#> <div id="anon" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="anon_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"content":null,"src":null,"icon":"el-icon-user-solid","size":null,"shape":null,"fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyElement.emit('anon', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitError"]}</script>
#> </div>
```
