# Element UI Tree

A tree view, optionally with checkboxes.

## Usage

``` r
el_tree(
  id = NULL,
  data = list(),
  node_key = "id",
  label_field = "label",
  children_field = "children",
  show_checkbox = FALSE,
  check_strictly = FALSE,
  default_expand_all = FALSE,
  expand_on_click_node = TRUE,
  accordion = FALSE,
  highlight_current = FALSE,
  expanded = NULL,
  checked = NULL,
  empty_text = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Tree ID (auto-generated if NULL).

- data:

  A list of nodes. Each is a list with the key and label fields named by
  `node_key` and `label_field`, and optionally `children`, `disabled`
  for an uncheckable node, or `isLeaf`.

- node_key:

  Field holding each node's unique key. The keys are what the server
  sees and what `expanded` and `checked` refer to.

- label_field, children_field:

  Fields holding a node's label and its children.

- show_checkbox:

  Show a checkbox beside every node.

- check_strictly:

  Treat a parent's checkbox as independent of its children, rather than
  checking them together.

- default_expand_all:

  Expand every node initially.

- expand_on_click_node:

  Expand a node when its label is clicked, as well as its arrow. Set
  `FALSE` to make clicking select rather than expand.

- accordion:

  Keep only one node expanded per level.

- highlight_current:

  Highlight the clicked node.

- expanded, checked:

  Keys to expand and to check initially.

- empty_text:

  Text shown when `data` is empty.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Details

Unlike the menu, a tree takes its whole structure through a `data` prop
rather than nested tags, so the nesting is plain R data all the way
down.

## Server inputs

`input$<id>` holds the key of the most recently clicked node, and
`input$<id>_checked` the keys of all checked nodes, as a character
vector. Both are reported on load, where they start empty and therefore
arrive as `NULL`, as Shiny reports any empty selection.

## Examples

``` r
nodes <- list(
  list(id = "fruit", label = "Fruit", children = list(
    list(id = "apple",  label = "Apple"),
    list(id = "cherry", label = "Cherry")
  )),
  list(id = "veg", label = "Vegetables", children = list(
    list(id = "leek", label = "Leek", disabled = TRUE)
  ))
)

el_tree(id = "picker", data = nodes)
#> <div id="picker_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck"></el-tree>
#> </div>
#> <div id="picker" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="picker">{"x":{"el":"#picker_container","data":{"treeData":[{"id":"fruit","label":"Fruit","children":[{"id":"apple","label":"Apple"},{"id":"cherry","label":"Cherry"}]},{"id":"veg","label":"Vegetables","children":[{"id":"leek","label":"Leek","disabled":true}]}],"treeProps":{"label":"label","children":"children","disabled":"disabled"},"nodeKey":"id","showCheckbox":false,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":[],"checkedKeys":[],"emptyText":null,"current":"","checked":[]},"methods":{"handleNodeClick":"function(data) { this.current = data[this.nodeKey]; Shiny.setInputValue('picker', this.current); }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; Shiny.setInputValue('picker_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"picker\", self.current); Shiny.setInputValue(\"picker_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleNodeClick","methods.handleCheck","mounted"],"jsHooks":[]}</script>

# With checkboxes, two nodes checked and the first branch open
el_tree(id = "picker", data = nodes, show_checkbox = TRUE,
        checked = c("apple", "cherry"), expanded = "fruit")
#> <div id="picker_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck"></el-tree>
#> </div>
#> <div id="picker" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="picker">{"x":{"el":"#picker_container","data":{"treeData":[{"id":"fruit","label":"Fruit","children":[{"id":"apple","label":"Apple"},{"id":"cherry","label":"Cherry"}]},{"id":"veg","label":"Vegetables","children":[{"id":"leek","label":"Leek","disabled":true}]}],"treeProps":{"label":"label","children":"children","disabled":"disabled"},"nodeKey":"id","showCheckbox":true,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":["fruit"],"checkedKeys":["apple","cherry"],"emptyText":null,"current":"","checked":["apple","cherry"]},"methods":{"handleNodeClick":"function(data) { this.current = data[this.nodeKey]; Shiny.setInputValue('picker', this.current); }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; Shiny.setInputValue('picker_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"picker\", self.current); Shiny.setInputValue(\"picker_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleNodeClick","methods.handleCheck","mounted"],"jsHooks":[]}</script>
```
