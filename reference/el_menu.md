# Element UI Menu

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
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Menu ID (auto-generated if NULL).

- items:

  A list of items. Each is a list with `index` (the value reported when
  selected), `label`, and optionally `icon` (an Element icon class such
  as `"el-icon-house"`), `disabled`, or `children` for a submenu. An
  item with `group = TRUE` becomes a titled group of its `children`
  rather than a submenu.

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

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Server inputs

`input$<id>` holds the selected item's `index`, reported on load and on
every selection. `input$<id>_path` holds the full path of indexes down
to it, so a nested item can be told apart from a top-level one with the
same index.

## Examples

``` r
el_menu(
  id = "nav",
  active = "home",
  items = list(
    list(index = "home", label = "Home", icon = "el-icon-house"),
    list(index = "products", label = "Products", icon = "el-icon-goods",
         children = list(
           list(index = "products-all", label = "All"),
           list(index = "products-new", label = "New")
         )),
    list(index = "help", label = "Help", disabled = TRUE)
  )
)
#> <div id="nav_container" style="display: contents">
#>   <el-menu :default-active="active" :mode="mode" :collapse="collapse" :unique-opened="uniqueOpened" :background-color="backgroundColor === null ? undefined : backgroundColor" :text-color="textColor === null ? undefined : textColor" :active-text-color="activeTextColor === null ? undefined : activeTextColor" @select="handleSelect" :default-openeds="defaultOpeneds === null ? undefined : defaultOpeneds" :menu-trigger="menuTrigger === null ? undefined : menuTrigger" :collapse-transition="collapseTransition === null ? undefined : collapseTransition" :router="router === null ? undefined : router">
#>     <el-menu-item index="home">
#>       <i class="el-icon-house"></i>
#>       <span>Home</span>
#>     </el-menu-item>
#>     <el-submenu index="products">
#>       <template slot="title">
#>         <i class="el-icon-goods"></i>
#>         <span>Products</span>
#>       </template>
#>       <el-menu-item index="products-all">
#>         <span>All</span>
#>       </el-menu-item>
#>       <el-menu-item index="products-new">
#>         <span>New</span>
#>       </el-menu-item>
#>     </el-submenu>
#>     <el-menu-item index="help" disabled>
#>       <span>Help</span>
#>     </el-menu-item>
#>   </el-menu>
#> </div>
#> <div id="nav" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="nav">{"x":{"el":"#nav_container","data":{"active":"home","mode":"vertical","collapse":false,"uniqueOpened":false,"backgroundColor":null,"textColor":null,"activeTextColor":null,"path":[],"defaultOpeneds":null,"menuTrigger":null,"collapseTransition":null,"router":null},"methods":{"handleSelect":"function(index, indexPath) { var self = this; self.active = index; self.path = indexPath; Shiny.setInputValue('nav', index); Shiny.setInputValue('nav_path', indexPath); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"nav\", self.active); Shiny.setInputValue(\"nav_path\", self.path); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelect","mounted"],"jsHooks":[]}</script>

# Horizontal, as a top bar
el_menu(id = "topnav", mode = "horizontal", active = "a",
        items = list(list(index = "a", label = "One"),
                     list(index = "b", label = "Two")))
#> <div id="topnav_container" style="display: contents">
#>   <el-menu :default-active="active" :mode="mode" :collapse="collapse" :unique-opened="uniqueOpened" :background-color="backgroundColor === null ? undefined : backgroundColor" :text-color="textColor === null ? undefined : textColor" :active-text-color="activeTextColor === null ? undefined : activeTextColor" @select="handleSelect" :default-openeds="defaultOpeneds === null ? undefined : defaultOpeneds" :menu-trigger="menuTrigger === null ? undefined : menuTrigger" :collapse-transition="collapseTransition === null ? undefined : collapseTransition" :router="router === null ? undefined : router">
#>     <el-menu-item index="a">
#>       <span>One</span>
#>     </el-menu-item>
#>     <el-menu-item index="b">
#>       <span>Two</span>
#>     </el-menu-item>
#>   </el-menu>
#> </div>
#> <div id="topnav" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="topnav">{"x":{"el":"#topnav_container","data":{"active":"a","mode":"horizontal","collapse":false,"uniqueOpened":false,"backgroundColor":null,"textColor":null,"activeTextColor":null,"path":[],"defaultOpeneds":null,"menuTrigger":null,"collapseTransition":null,"router":null},"methods":{"handleSelect":"function(index, indexPath) { var self = this; self.active = index; self.path = indexPath; Shiny.setInputValue('topnav', index); Shiny.setInputValue('topnav_path', indexPath); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"topnav\", self.active); Shiny.setInputValue(\"topnav_path\", self.path); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSelect","mounted"],"jsHooks":[]}</script>
```
