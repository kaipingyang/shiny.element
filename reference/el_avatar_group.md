# Element Plus Avatar Group

Avatars overlapping in a row, the overflow collapsed into a count.

## Usage

``` r
el_avatar_group(
  ...,
  id = NULL,
  size = NULL,
  shape = NULL,
  collapse_avatars = NULL,
  collapse_avatars_tooltip = NULL,
  max_collapse_avatars = NULL,
  effect = NULL,
  placement = NULL,
  popper_class = NULL,
  popper_style = NULL,
  collapse_class = NULL,
  collapse_style = NULL,
  width = NULL,
  slots = NULL,
  on = NULL
)

update_el_avatar_group(
  session = shiny::getDefaultReactiveDomain(),
  id,
  size = NULL,
  shape = NULL,
  collapse_avatars = NULL,
  collapse_avatars_tooltip = NULL,
  max_collapse_avatars = NULL,
  effect = NULL,
  placement = NULL,
  popper_class = NULL,
  popper_style = NULL,
  collapse_class = NULL,
  collapse_style = NULL
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

  Control the size of avatars in this avatar-group. Element Plus's
  `size` (number / 'large' \| 'default' \| 'small').

- shape:

  Control the shape of avatars in this avatar-group. Element Plus's
  `shape` ('circle' \| 'square').

- collapse_avatars:

  Whether to collapse avatars. Element Plus's `collapse-avatars`
  (boolean).

- collapse_avatars_tooltip:

  Whether show all collapsed avatars when mouse hover text of the
  collapse-avatar. To use this, `collapse-avatars` must be true. Element
  Plus's `collapse-avatars-tooltip` (boolean).

- max_collapse_avatars:

  The max avatars number to be shown. To use this, `collapse-avatars`
  must be true. Element Plus's `max-collapse-avatars` (number).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- placement:

  Placement of tooltip. Element Plus's `placement` (enum).

- popper_class:

  Custom class name for tooltip. Element Plus's `popper-class` (string).

- popper_style:

  Custom style for tooltip. Element Plus's `popper-style` (string /
  object).

- collapse_class:

  Custom class name for the collapse-avatar. Element Plus's
  `collapse-class` (string).

- collapse_style:

  Custom style for the collapse-avatar. Element Plus's `collapse-style`
  (string / object).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.

## Updating from the server

`update_el_avatar_group()` changes the component from the server: every
argument of `el_avatar_group()` that can change once it is drawn, under
the same name. One left `NULL` stays as it is; `NA` returns it to
Element's default.

`update_el_avatar_group()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_avatar_group(
  el_avatar(src = "https://example.com/a.png"),
  el_avatar("B"),
  collapse_avatars = TRUE
)
#> <div id="el_avatar_group_771c4735-ed8c-458b-97c0-57f43372525c" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_avatar_group_771c4735-ed8c-458b-97c0-57f43372525c_container" style="display: contents">
#>   <el-avatar-group :size="size === null ? undefined : size" :shape="shape === null ? undefined : shape" :collapse-avatars="collapseAvatars === null ? undefined : collapseAvatars" :collapse-avatars-tooltip="collapseAvatarsTooltip === null ? undefined : collapseAvatarsTooltip" :max-collapse-avatars="maxCollapseAvatars === null ? undefined : maxCollapseAvatars" :effect="effect === null ? undefined : effect" :placement="placement === null ? undefined : placement" :popper-class="popperClass === null ? undefined : popperClass" :popper-style="popperStyle === null ? undefined : popperStyle" :collapse-class="collapseClass === null ? undefined : collapseClass" :collapse-style="collapseStyle === null ? undefined : collapseStyle">
#>     <el-avatar :src="el2_src === null ? undefined : el2_src" :icon="el2_icon === null ? undefined : el2_icon" :size="el2_size === null ? undefined : el2_size" :shape="el2_shape === null ? undefined : el2_shape" :fit="el2_fit === null ? undefined : el2_fit" :src-set="el2_srcSet === null ? undefined : el2_srcSet" :alt="el2_alt === null ? undefined : el2_alt" @error="el2_svEmitError" ref="sv_el_avatar_201178fa_438a_4851_93f3_60aab7c063cb" id="el_avatar_201178fa-438a-4851-93f3-60aab7c063cb">{{el2_content}}</el-avatar>
#>     <el-avatar :src="el3_src === null ? undefined : el3_src" :icon="el3_icon === null ? undefined : el3_icon" :size="el3_size === null ? undefined : el3_size" :shape="el3_shape === null ? undefined : el3_shape" :fit="el3_fit === null ? undefined : el3_fit" :src-set="el3_srcSet === null ? undefined : el3_srcSet" :alt="el3_alt === null ? undefined : el3_alt" @error="el3_svEmitError" ref="sv_B" id="B">{{el3_content}}</el-avatar>
#>   </el-avatar-group>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"size":null,"shape":null,"collapseAvatars":true,"collapseAvatarsTooltip":null,"maxCollapseAvatars":null,"effect":null,"placement":null,"popperClass":null,"popperStyle":null,"collapseClass":null,"collapseStyle":null,"el2_content":null,"el2_src":"https://example.com/a.png","el2_icon":null,"el2_size":null,"el2_shape":null,"el2_fit":null,"el2_srcSet":null,"el2_alt":null,"el3_content":null,"el3_src":null,"el3_icon":null,"el3_size":null,"el3_shape":null,"el3_fit":null,"el3_srcSet":null,"el3_alt":null},"methods":{"el2_svEmitError":"function() { window.shinyVue.emit('el_avatar_201178fa-438a-4851-93f3-60aab7c063cb', 'error', arguments); }","el3_svEmitError":"function() { window.shinyVue.emit('B', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"el_avatar_201178fa-438a-4851-93f3-60aab7c063cb":{"fields":{"content":"el2_content","src":"el2_src","icon":"el2_icon","size":"el2_size","shape":"el2_shape","fit":"el2_fit","srcSet":"el2_srcSet","alt":"el2_alt","svEmitError":"el2_svEmitError"},"ref":"sv_el_avatar_201178fa_438a_4851_93f3_60aab7c063cb"},"B":{"fields":{"content":"el3_content","src":"el3_src","icon":"el3_icon","size":"el3_size","shape":"el3_shape","fit":"el3_fit","srcSet":"el3_srcSet","alt":"el3_alt","svEmitError":"el3_svEmitError"},"ref":"sv_B"}},"generated":true,"evals":["options.methods.el2_svEmitError","options.methods.el3_svEmitError"]}</script>
#> </div>
```
