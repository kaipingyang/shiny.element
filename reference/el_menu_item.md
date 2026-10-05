# Items of [`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md): an entry, a submenu, a group

Element Plus's `el-menu-item`, `el-sub-menu` and `el-menu-item-group`,
for `el_menu(items =)`. A submenu and a group hold items of their own in
`...`, nested to any depth.

## Usage

``` r
el_menu_item(label, index, icon = NULL, route = NULL, disabled = NULL)

el_sub_menu(
  label,
  index,
  ...,
  icon = NULL,
  disabled = NULL,
  popper_class = NULL,
  popper_style = NULL,
  show_timeout = NULL,
  hide_timeout = NULL,
  teleported = NULL,
  popper_offset = NULL,
  expand_close_icon = NULL,
  expand_open_icon = NULL,
  collapse_close_icon = NULL,
  collapse_open_icon = NULL
)

el_menu_item_group(title, ...)
```

## Arguments

- label:

  The text shown.

- index:

  The item's value, `input$<id>` when it is selected.

- icon:

  An icon, by name: `"House"`.

- route:

  Where the item goes, with `el_menu(router = TRUE)`.

- disabled:

  Whether the item or submenu is disabled.

- ...:

  The submenu's or the group's items.

- popper_class, popper_style:

  Class and style of the submenu's popup.

- show_timeout, hide_timeout:

  Delay before the submenu opens and closes, in milliseconds; the menu's
  by default.

- teleported:

  Whether the popup is appended to `<body>`: by default for a top-level
  submenu, not for others.

- popper_offset:

  Offset of the popup, over the menu's.

- expand_close_icon, expand_open_icon:

  Icons of the submenu when the menu is expanded, closed and open; give
  both.

- collapse_close_icon, collapse_open_icon:

  The same when the menu is collapsed.

- title:

  The group's title.

## Value

An item, for `el_menu(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
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
el_menu(
  "m",
  items = list(
    el_menu_item("Processing Center", "1"),
    el_sub_menu(
      "Workspace",
      "2",
      el_menu_item("item one", "2-1"),
      el_menu_item_group("Group", el_menu_item("item two", "2-2"))
    ),
    el_menu_item("Info", "3", disabled = TRUE)
  ),
  mode = "horizontal"
)
#> <div id="m" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="m_container" style="display: contents">
#>   <el-menu :default-active="active" :mode="mode" :collapse="collapse" :unique-opened="uniqueOpened" :background-color="backgroundColor === null ? undefined : backgroundColor" :text-color="textColor === null ? undefined : textColor" :active-text-color="activeTextColor === null ? undefined : activeTextColor" @select="handleSelect" :default-openeds="defaultOpeneds === null ? undefined : defaultOpeneds" :menu-trigger="menuTrigger === null ? undefined : menuTrigger" :collapse-transition="collapseTransition === null ? undefined : collapseTransition" :router="router === null ? undefined : router" @open="elEmitOpen" @close="elEmitClose" :close-on-click-outside="closeOnClickOutside === null ? undefined : closeOnClickOutside" :ellipsis="ellipsis === null ? undefined : ellipsis" :ellipsis-icon="ellipsisIcon === null ? undefined : ellipsisIcon" :hide-timeout="hideTimeout === null ? undefined : hideTimeout" :persistent="persistent === null ? undefined : persistent" :popper-class="popperClass === null ? undefined : popperClass" :popper-effect="popperEffect === null ? undefined : popperEffect" :popper-offset="popperOffset === null ? undefined : popperOffset" :popper-style="popperStyle === null ? undefined : popperStyle" :show-timeout="showTimeout === null ? undefined : showTimeout">
#>     <el-menu-item index="1" @click="elMenuItemClick(&quot;1&quot;)">
#>       <span>Processing Center</span>
#>     </el-menu-item>
#>     <el-sub-menu index="2">
#>       <template v-slot:title>
#>         <span>Workspace</span>
#>       </template>
#>       <el-menu-item index="2-1" @click="elMenuItemClick(&quot;2-1&quot;)">
#>         <span>item one</span>
#>       </el-menu-item>
#>       <el-menu-item-group title="Group">
#>         <el-menu-item index="2-2" @click="elMenuItemClick(&quot;2-2&quot;)">
#>           <span>item two</span>
#>         </el-menu-item>
#>       </el-menu-item-group>
#>     </el-sub-menu>
#>     <el-menu-item index="3" :disabled="true" @click="elMenuItemClick(&quot;3&quot;)">
#>       <span>Info</span>
#>     </el-menu-item>
#>   </el-menu>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"active":"","mode":"horizontal","collapse":false,"uniqueOpened":false,"backgroundColor":null,"textColor":null,"activeTextColor":null,"path":[],"defaultOpeneds":null,"menuTrigger":null,"collapseTransition":null,"router":null,"closeOnClickOutside":null,"ellipsis":null,"ellipsisIcon":null,"hideTimeout":null,"persistent":null,"popperClass":null,"popperEffect":null,"popperOffset":null,"popperStyle":null,"showTimeout":null},"methods":{"elEmitOpen":"function() { var shape = function(index, path) { return {index: index, path: path}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('m', 'open', [v]); }","elEmitClose":"function() { var shape = function(index, path) { return {index: index, path: path}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('m', 'close', [v]); }","elMenuItemClick":"function(index) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('m_item_click', index, {priority: 'event'}); }","handleSelect":"function(index, indexPath) { var self = this; self.active = index; self.path = indexPath; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('m_path', indexPath); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"m_path\", self.path); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"active || null","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitOpen","options.methods.elEmitClose","options.methods.elMenuItemClick","options.methods.handleSelect","options.mounted"]}</script>
#> </div>
```
