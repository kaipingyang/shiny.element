# Element Plus Avatar

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
  class = NULL,
  style = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_avatar(
  session = shiny::getDefaultReactiveDomain(),
  id,
  content = NULL,
  src = NULL,
  icon = NULL,
  size = NULL,
  shape = NULL,
  fit = NULL,
  src_set = NULL,
  alt = NULL
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

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

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

- class, style:

  Extra classes and inline style on the avatar, as Element passes them
  to its root.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_avatar()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_avatar()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|                    |          |                                |
|--------------------|----------|--------------------------------|
| Input              | Reported | Value                          |
| `input$<id>_error` | unasked  | trigger when image load error. |

The same list as `el_events("el_avatar")`, which says how an event's
arguments travel.

## Updating from the server

Server-side update for `el_avatar()`.

Every other argument of `el_avatar()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_avatar()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_avatar("me", src = "https://example.org/face.png")
#> <div id="me" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="me_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"content":null,"src":"https://example.org/face.png","icon":null,"size":null,"shape":null,"fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyVue.emit('me', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitError"]}</script>
#> </div>
el_avatar("initials", content = "KY", shape = "square", size = 40)
#> <div id="initials" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="initials_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"content":"KY","src":null,"icon":null,"size":40,"shape":"square","fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyVue.emit('initials', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitError"]}</script>
#> </div>
el_avatar("anon", icon = "el-icon-user-solid")
#> <div id="anon" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="anon_container" style="display: contents">
#>   <el-avatar :src="src === null ? undefined : src" :icon="icon === null ? undefined : icon" :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :fit="fit === null ? undefined : fit" :src-set="srcSet === null ? undefined : srcSet" :alt="alt === null ? undefined : alt" @error="elEmitError">{{content}}</el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"content":null,"src":null,"icon":"el-icon-user-solid","size":null,"shape":null,"fit":null,"srcSet":null,"alt":null},"methods":{"elEmitError":"function() { window.shinyVue.emit('anon', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitError"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$sign_in, {
    update_el_avatar(session, "me", src = user_photo())
  })
}
```
