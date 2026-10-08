# Element Plus Menu

A navigation menu, vertical or horizontal, with submenus nested to any
depth.

## Usage

``` r
el_menu(
  id = NULL,
  items = list(),
  active = NULL,
  mode = "vertical",
  collapse = FALSE,
  unique_opened = FALSE,
  background_color = NULL,
  text_color = NULL,
  active_text_color = NULL,
  default_openeds = NULL,
  menu_trigger = NULL,
  collapse_transition = NULL,
  router = NULL,
  close_on_click_outside = NULL,
  ellipsis = NULL,
  ellipsis_icon = NULL,
  hide_timeout = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_effect = NULL,
  popper_offset = NULL,
  popper_style = NULL,
  show_timeout = NULL,
  class = NULL,
  style = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_menu(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  collapse = NULL,
  mode = NULL,
  unique_opened = NULL,
  background_color = NULL,
  text_color = NULL,
  active_text_color = NULL,
  menu_trigger = NULL,
  collapse_transition = NULL,
  router = NULL,
  close_on_click_outside = NULL,
  ellipsis = NULL,
  ellipsis_icon = NULL,
  hide_timeout = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_effect = NULL,
  popper_offset = NULL,
  popper_style = NULL,
  show_timeout = NULL
)
```

## Arguments

- id:

  Menu ID (auto-generated if NULL).

- items:

  A list of items, each an
  [`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
  [`el_sub_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md)
  or
  [`el_menu_item_group()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md)
  – or a list with `index` (the value reported when selected), `label`
  (or `title`, Element's name for it), and optionally `icon` (an icon's
  name, such as `"House"`), `disabled`, `route` (for `router = TRUE`),
  or `children` for a submenu. A submenu may also carry Element Plus's
  sub-menu props: `popper_class`, `popper_style`, `show_timeout`,
  `hide_timeout`, `teleported`, `popper_offset`, and its expand and
  collapse icons (`expand_close_icon`, `expand_open_icon`,
  `collapse_close_icon`, `collapse_open_icon`). An item with
  `group = TRUE` becomes a titled group of its `children` rather than a
  submenu.

  Clicking an item reports `input$<id>` (the index selected) and
  `input$<id>_item_click` (the index clicked).

- active:

  Index of the initially selected item.

- mode:

  `"vertical"` (default) or `"horizontal"`.

- collapse:

  Collapse to icons only. Vertical menus only.

- unique_opened:

  Keep only one submenu open at a time.

- background_color, text_color, active_text_color:

  Menu colours.

- default_openeds:

  Character vector of sub-menu indexes open at start.

- menu_trigger:

  How a horizontal sub-menu opens: `"hover"` (default) or `"click"`.

- collapse_transition:

  Whether to animate collapsing. Default `TRUE`.

- router:

  Whether to use vue-router mode, taking each index as a path.

- close_on_click_outside:

  Optional, whether menu is collapsed when clicking outside. Element
  Plus's `close-on-click-outside` (boolean).

- ellipsis:

  Whether the menu is ellipsis (available only in horizontal mode).
  Element Plus's `ellipsis` (boolean).

- ellipsis_icon:

  Custom ellipsis icon (available only in horizontal mode and ellipsis
  is true). Element Plus's `ellipsis-icon` (string / Component). An
  icon's name, such as `"Search"`.

- hide_timeout:

  Control timeout for all menus before hiding. Element Plus's
  `hide-timeout` (number).

- persistent:

  When menu inactive and `persistent` is `false` , dropdown menu will be
  destroyed. Element Plus's `persistent` (boolean).

- popper_class:

  Custom class name for all popup menus and titles' tooltips. Element
  Plus's `popper-class` (string).

- popper_effect:

  Tooltip theme, built-in theme: `dark` / `light` when menu is
  collapsed. Element Plus's `popper-effect` ('dark' \| 'light' /
  string).

- popper_offset:

  Offset of the popper (effective for all submenus). Element Plus's
  `popper-offset` (number).

- popper_style:

  Custom style for all popup menus and titles' tooltips. Element Plus's
  `popper-style` (string / object).

- show_timeout:

  Control timeout for all menus before showing. Element Plus's
  `show-timeout` (number).

- class, style:

  Extra classes and inline style on the menu, as Element passes them to
  its root: Element's examples style theirs by a class of their own.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  In `el_menu()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_menu()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

`input$<id>` holds the selected item's `index`, reported on load and on
every selection – `NULL` while no item is active. `input$<id>_path`
holds the full path of indexes down to it, so a nested item can be told
apart from a top-level one with the same index.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- [`close()`](https://rdrr.io/r/base/connections.html) – Close a
  specific sub-menu

- [`open()`](https://rdrr.io/r/base/connections.html) – Open a specific
  sub-menu

## Updating from the server

`update_el_menu()` changes the component from the server.

Every other argument of `el_menu()` that can change once it is drawn is
an argument here too, under the same name. One left `NULL` stays as it
is; `NA` returns it to Element's default.

`update_el_menu()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_menu(
  id = "nav",
  active = "home",
  items = list(
    list(index = "home", label = "Home", icon = "House"),
    list(
      index = "products",
      label = "Products",
      icon = "Goods",
      children = list(
        list(index = "products-all", label = "All"),
        list(index = "products-new", label = "New")
      )
    ),
    list(index = "help", label = "Help", disabled = TRUE)
  )
)
#> <div id="nav" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="nav_container" style="display: contents">
#>   <el-menu :default-active="active" :mode="mode" :collapse="collapse" :unique-opened="uniqueOpened" :background-color="backgroundColor === null ? undefined : backgroundColor" :text-color="textColor === null ? undefined : textColor" :active-text-color="activeTextColor === null ? undefined : activeTextColor" @select="handleSelect" :default-openeds="defaultOpeneds === null ? undefined : defaultOpeneds" :menu-trigger="menuTrigger === null ? undefined : menuTrigger" :collapse-transition="collapseTransition === null ? undefined : collapseTransition" :router="router === null ? undefined : router" @open="elEmitOpen" @close="elEmitClose" :close-on-click-outside="closeOnClickOutside === null ? undefined : closeOnClickOutside" :ellipsis="ellipsis === null ? undefined : ellipsis" :ellipsis-icon="ellipsisIcon === null ? undefined : ellipsisIcon" :hide-timeout="hideTimeout === null ? undefined : hideTimeout" :persistent="persistent === null ? undefined : persistent" :popper-class="popperClass === null ? undefined : popperClass" :popper-effect="popperEffect === null ? undefined : popperEffect" :popper-offset="popperOffset === null ? undefined : popperOffset" :popper-style="popperStyle === null ? undefined : popperStyle" :show-timeout="showTimeout === null ? undefined : showTimeout">
#>     <el-menu-item index="home" @click="elMenuItemClick(&quot;home&quot;)">
#>       <el-icon><House /></el-icon>
#>       <span>Home</span>
#>     </el-menu-item>
#>     <el-sub-menu index="products">
#>       <template v-slot:title>
#>         <el-icon><Goods /></el-icon>
#>         <span>Products</span>
#>       </template>
#>       <el-menu-item index="products-all" @click="elMenuItemClick(&quot;products-all&quot;)">
#>         <span>All</span>
#>       </el-menu-item>
#>       <el-menu-item index="products-new" @click="elMenuItemClick(&quot;products-new&quot;)">
#>         <span>New</span>
#>       </el-menu-item>
#>     </el-sub-menu>
#>     <el-menu-item index="help" :disabled="true" @click="elMenuItemClick(&quot;help&quot;)">
#>       <span>Help</span>
#>     </el-menu-item>
#>   </el-menu>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"active":"home","mode":"vertical","collapse":false,"uniqueOpened":false,"backgroundColor":null,"textColor":null,"activeTextColor":null,"path":[],"defaultOpeneds":null,"menuTrigger":null,"collapseTransition":null,"router":null,"closeOnClickOutside":null,"ellipsis":null,"ellipsisIcon":null,"hideTimeout":null,"persistent":null,"popperClass":null,"popperEffect":null,"popperOffset":null,"popperStyle":null,"showTimeout":null},"methods":{"elEmitOpen":"function() { var shape = function(index, path) { return {index: index, path: path}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('nav', 'open', [v]); }","elEmitClose":"function() { var shape = function(index, path) { return {index: index, path: path}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('nav', 'close', [v]); }","elMenuItemClick":"function(index) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('nav_item_click', index, {priority: 'event'}); }","handleSelect":"function(index, indexPath) { var self = this; self.active = index; self.path = indexPath; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('nav_path', indexPath); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"nav_path\", self.path); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"active || null","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitOpen","options.methods.elEmitClose","options.methods.elMenuItemClick","options.methods.handleSelect","options.mounted"]}</script>
#> </div>

# Horizontal, as a top bar
el_menu(
  id = "topnav",
  mode = "horizontal",
  active = "a",
  items = list(
    list(index = "a", label = "One"),
    list(index = "b", label = "Two")
  )
)
#> <div id="topnav" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="topnav_container" style="display: contents">
#>   <el-menu :default-active="active" :mode="mode" :collapse="collapse" :unique-opened="uniqueOpened" :background-color="backgroundColor === null ? undefined : backgroundColor" :text-color="textColor === null ? undefined : textColor" :active-text-color="activeTextColor === null ? undefined : activeTextColor" @select="handleSelect" :default-openeds="defaultOpeneds === null ? undefined : defaultOpeneds" :menu-trigger="menuTrigger === null ? undefined : menuTrigger" :collapse-transition="collapseTransition === null ? undefined : collapseTransition" :router="router === null ? undefined : router" @open="elEmitOpen" @close="elEmitClose" :close-on-click-outside="closeOnClickOutside === null ? undefined : closeOnClickOutside" :ellipsis="ellipsis === null ? undefined : ellipsis" :ellipsis-icon="ellipsisIcon === null ? undefined : ellipsisIcon" :hide-timeout="hideTimeout === null ? undefined : hideTimeout" :persistent="persistent === null ? undefined : persistent" :popper-class="popperClass === null ? undefined : popperClass" :popper-effect="popperEffect === null ? undefined : popperEffect" :popper-offset="popperOffset === null ? undefined : popperOffset" :popper-style="popperStyle === null ? undefined : popperStyle" :show-timeout="showTimeout === null ? undefined : showTimeout">
#>     <el-menu-item index="a" @click="elMenuItemClick(&quot;a&quot;)">
#>       <span>One</span>
#>     </el-menu-item>
#>     <el-menu-item index="b" @click="elMenuItemClick(&quot;b&quot;)">
#>       <span>Two</span>
#>     </el-menu-item>
#>   </el-menu>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"active":"a","mode":"horizontal","collapse":false,"uniqueOpened":false,"backgroundColor":null,"textColor":null,"activeTextColor":null,"path":[],"defaultOpeneds":null,"menuTrigger":null,"collapseTransition":null,"router":null,"closeOnClickOutside":null,"ellipsis":null,"ellipsisIcon":null,"hideTimeout":null,"persistent":null,"popperClass":null,"popperEffect":null,"popperOffset":null,"popperStyle":null,"showTimeout":null},"methods":{"elEmitOpen":"function() { var shape = function(index, path) { return {index: index, path: path}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('topnav', 'open', [v]); }","elEmitClose":"function() { var shape = function(index, path) { return {index: index, path: path}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('topnav', 'close', [v]); }","elMenuItemClick":"function(index) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('topnav_item_click', index, {priority: 'event'}); }","handleSelect":"function(index, indexPath) { var self = this; self.active = index; self.path = indexPath; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('topnav_path', indexPath); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"topnav_path\", self.path); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"active || null","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitOpen","options.methods.elEmitClose","options.methods.elMenuItemClick","options.methods.handleSelect","options.mounted"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_menu(session, "nav", active = "data")
  })
}
```
