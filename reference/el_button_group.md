# Element Plus Button Group

Buttons joined into one bar, as Element's `el-button-group` draws them:
shared borders, rounded only at the ends. Each
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)
inside keeps reporting its own clicks as `input$<its id>`.

## Usage

``` r
el_button_group(
  ...,
  id = NULL,
  size = NULL,
  type = NULL,
  direction = NULL,
  width = NULL
)
```

## Arguments

- ...:

  Buttons:
  [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)s,
  or raw `el$button()` tags.

- id:

  Group ID. Auto-generated if `NULL`.

- size, type:

  The size and type of every button in the group, as Element Plus's
  group hands them down: `size` `"large"`, `"default"` or `"small"`;
  `type` `"primary"`, `"success"`, `"warning"`, `"danger"` or `"info"`.

- direction:

  `"horizontal"` (default) or `"vertical"`.

- width:

  Component width, as a CSS unit.

## Value

A Shiny UI element.

## Details

The buttons are folded into the group's Vue instance rather than nested
(see
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md)):
Element styles the group through its direct children, which a button
with a host of its own would not be. So
[`update_el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)
cannot reach them; set their fields with
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
on the group's id.

## Examples

``` r
el_button_group(
  el_button("prev", "Previous", icon = "ArrowLeft", type = "primary"),
  el_button("next", "Next", type = "primary")
)
#> <div id="el_button_group_35e8115d-156c-4927-bb5e-5ca7bc1d87ec" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_button_group_35e8115d-156c-4927-bb5e-5ca7bc1d87ec_container" style="display: contents">
#>   <el-button-group :size="bgSize === null ? undefined : bgSize" :type="bgType === null ? undefined : bgType" :direction="bgDirection === null ? undefined : bgDirection">
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#>     <el-button :type="el3_type" :plain="el3_plain" :round="el3_round" :circle="el3_circle" :loading="el3_loading" :disabled="el3_disabled" :native-type="el3_native_type" @click="el3_handleClick" :size="el3_size === null ? undefined : el3_size" :icon="el3_icon === null ? undefined : el3_icon" :autofocus="el3_autofocus === null ? undefined : el3_autofocus" :auto-insert-space="el3_autoInsertSpace === null ? undefined : el3_autoInsertSpace" :bg="el3_bg === null ? undefined : el3_bg" :color="el3_color === null ? undefined : el3_color" :dark="el3_dark === null ? undefined : el3_dark" :dashed="el3_dashed === null ? undefined : el3_dashed" :link="el3_link === null ? undefined : el3_link" :loading-icon="el3_loadingIcon === null ? undefined : el3_loadingIcon" :tag="el3_tag === null ? undefined : el3_tag" :text="el3_text === null ? undefined : el3_text">{{el3_label}}</el-button>
#>   </el-button-group>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Previous","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":"ArrowLeft","count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null,"el3_label":"Next","el3_type":"primary","el3_size":null,"el3_plain":false,"el3_round":false,"el3_circle":false,"el3_loading":false,"el3_disabled":false,"el3_native_type":"button","el3_icon":null,"el3_count":0,"el3_autofocus":false,"el3_autoInsertSpace":null,"el3_bg":null,"el3_color":null,"el3_dark":null,"el3_dashed":null,"el3_link":null,"el3_loadingIcon":null,"el3_tag":null,"el3_text":null,"bgSize":null,"bgType":null,"bgDirection":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('prev:shiny.action', this.count); }","el3_handleClick":"function() { if (this.el3_disabled || this.el3_loading) return; this.el3_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('next:shiny.action', this.el3_count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"prev:shiny.action\", self.count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"next:shiny.action\", self.el3_count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.handleClick","options.methods.el3_handleClick","options.mounted"]}</script>
#> </div>
```
