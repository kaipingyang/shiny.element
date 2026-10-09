# An entry of [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown.md)'s menu

Element Plus's `el-dropdown-item`, for `el_dropdown(items =)`.

## Usage

``` r
el_dropdown_item(
  command,
  label = command,
  icon = NULL,
  disabled = NULL,
  divided = NULL
)
```

## Arguments

- command:

  The value `input$<id>` takes when the entry is clicked.

- label:

  The entry's text. Defaults to `command`.

- icon:

  The entry's icon, by name.

- disabled:

  Whether the entry is disabled.

- divided:

  Whether a divider is drawn above the entry.

## Value

An entry, for `el_dropdown(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

## Examples

``` r
el_dropdown(
  "dd",
  "Dropdown List",
  items = list(
    el_dropdown_item("apple", "Apple"),
    el_dropdown_item("pear", "Pear", disabled = TRUE),
    el_dropdown_item("plum", "Plum", divided = TRUE)
  )
)
#> <div id="dd" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dd_container" style="display: contents">
#>   <el-dropdown :trigger="trigger" :hide-on-click="hideOnClick" :placement="placement" :disabled="disabled" :split-button="splitButton" @command="handleCommand" :type="type === null ? undefined : type" :size="size === null ? undefined : size" :show-timeout="showTimeout === null ? undefined : showTimeout" :hide-timeout="hideTimeout === null ? undefined : hideTimeout" :tabindex="tabindex === null ? undefined : tabindex" @click="svEmitClick" :append-to="appendTo === null ? undefined : appendTo" :button-props="buttonProps === null ? undefined : buttonProps" :effect="effect === null ? undefined : effect" :max-height="maxHeight === null ? undefined : maxHeight" :persistent="persistent === null ? undefined : persistent" :popper-class="popperClass === null ? undefined : popperClass" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :role="role === null ? undefined : role" :show-arrow="showArrow === null ? undefined : showArrow" :teleported="teleported === null ? undefined : teleported" :trigger-keys="triggerKeys === null ? undefined : triggerKeys" :virtual-ref="$elRef(virtualRef)" :virtual-triggering="virtualTriggering === null ? undefined : virtualTriggering">
#>     <span class="el-dropdown-link">
#>       Dropdown List
#>       <el-icon class="el-icon--right"><arrow-down /></el-icon>
#>     </span>
#>     <template v-slot:dropdown>
#>       <el-dropdown-menu>
#>         <el-dropdown-item :command="&quot;apple&quot;">Apple</el-dropdown-item>
#>         <el-dropdown-item :command="&quot;pear&quot;" :disabled="true">Pear</el-dropdown-item>
#>         <el-dropdown-item :command="&quot;plum&quot;" :divided="true">Plum</el-dropdown-item>
#>       </el-dropdown-menu>
#>     </template>
#>   </el-dropdown>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"trigger":"hover","hideOnClick":true,"placement":"bottom-end","disabled":false,"splitButton":false,"count":0,"type":null,"size":null,"showTimeout":null,"hideTimeout":null,"tabindex":null,"appendTo":null,"buttonProps":null,"effect":null,"maxHeight":null,"persistent":null,"popperClass":null,"popperOptions":null,"popperStyle":null,"role":null,"showArrow":null,"teleported":null,"triggerKeys":null,"virtualRef":null,"virtualTriggering":null},"methods":{"svEmitClick":"function() { window.shinyVue.emit('dd', 'click', arguments); }","handleCommand":"function(cmd) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('dd', cmd, {priority: 'event'}); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('dd_count', this.count); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitClick","options.methods.handleCommand"]}</script>
#> </div>
```
