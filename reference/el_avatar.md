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
  session = shiny::getDefaultReactiveDomain()
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

  Shiny session for module support.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_error` – fires when the image fails to load.

## Examples

``` r
el_avatar("me", src = "https://example.org/face.png")
#> <div id="me_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div>
#> <div id="me" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="me">{"x":{"el":"#me_container","data":{"content":null,"src":"https://example.org/face.png","icon":null,"size":null,"shape":null,"fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyElement.emit('me', 'error', arguments); }"}},"evals":["methods.elEmitError"],"jsHooks":[]}</script>
el_avatar("initials", content = "KY", shape = "square", size = 40)
#> <div id="initials_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div>
#> <div id="initials" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="initials">{"x":{"el":"#initials_container","data":{"content":"KY","src":null,"icon":null,"size":40,"shape":"square","fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyElement.emit('initials', 'error', arguments); }"}},"evals":["methods.elEmitError"],"jsHooks":[]}</script>
el_avatar("anon", icon = "el-icon-user-solid")
#> <div id="anon_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div>
#> <div id="anon" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="anon">{"x":{"el":"#anon_container","data":{"content":null,"src":null,"icon":"el-icon-user-solid","size":null,"shape":null,"fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyElement.emit('anon', 'error', arguments); }"}},"evals":["methods.elEmitError"],"jsHooks":[]}</script>
```
