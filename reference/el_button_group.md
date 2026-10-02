# Element UI Button Group

Buttons joined into one bar, as Element's `el-button-group` draws them:
shared borders, rounded only at the ends. Each
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)
inside keeps reporting its own clicks as `input$<its id>`.

## Usage

``` r
el_button_group(..., id = NULL, width = NULL)
```

## Arguments

- ...:

  Buttons:
  [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md)s,
  or raw `el$button()` tags.

- id:

  Group ID. Auto-generated if `NULL`.

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
[`update_el_button()`](https://kaipingyang.github.io/shiny.element/reference/update_el_button.md)
cannot reach them; set their fields with
[`update_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/update_vue_data.md)
on the group's id.

## Examples

``` r
el_button_group(
  el_button("prev", "Previous", icon = "el-icon-arrow-left", type = "primary"),
  el_button("next", "Next", type = "primary")
)
#> <div id="el_button_group_6f1ec47b-bdae-41c8-b5cf-f0d220267165" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_button_group_6f1ec47b-bdae-41c8-b5cf-f0d220267165_container" style="display: contents">
#>   <el-button-group>
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#>     <el-button :type="el3_type" :plain="el3_plain" :round="el3_round" :circle="el3_circle" :loading="el3_loading" :disabled="el3_disabled" :native-type="el3_native_type" @click="el3_handleClick" :size="el3_size === null ? undefined : el3_size" :icon="el3_icon === null ? undefined : el3_icon" :autofocus="el3_autofocus === null ? undefined : el3_autofocus">{{el3_label}}</el-button>
#>   </el-button-group>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Previous","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":"el-icon-arrow-left","count":0,"autofocus":false,"el3_label":"Next","el3_type":"primary","el3_size":null,"el3_plain":false,"el3_round":false,"el3_circle":false,"el3_loading":false,"el3_disabled":false,"el3_native_type":"button","el3_icon":null,"el3_count":0,"el3_autofocus":false},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('prev:shiny.action', this.count); }","el3_handleClick":"function() { if (this.el3_disabled || this.el3_loading) return; this.el3_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('next:shiny.action', this.el3_count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"prev:shiny.action\", self.count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"next:shiny.action\", self.el3_count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick","options.methods.el3_handleClick","options.mounted"]}</script>
#> </div>
```
