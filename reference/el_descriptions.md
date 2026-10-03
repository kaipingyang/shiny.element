# Element Plus Descriptions

A read-only grid of labelled values – the detail view of a record.

## Usage

``` r
el_descriptions(
  id = NULL,
  items = list(),
  title = NULL,
  extra = NULL,
  column = NULL,
  direction = NULL,
  border = NULL,
  size = NULL,
  label_width = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- items:

  The fields, as a list of `list(label =, content =)`, or a named list
  or vector whose names are the labels. `content` may be any Shiny UI, a
  shiny.element component included, which is absorbed rather than
  nested. An item may also carry Element Plus's item props: `span`,
  `rowspan`, `width`, `min_width`, `label_width`, `align`,
  `label_align`, `class_name` and `label_class_name`. A `label` that is
  markup rather than text fills the item's label slot.

- title:

  Heading above the grid.

- extra:

  Text at the heading's right end. For something interactive, use
  `slots = list(extra = ...)`.

- column:

  Items per row. Default `3`.

- direction:

  `"horizontal"` (default) puts each label beside its value;
  `"vertical"` puts it above.

- border:

  Whether to draw cell borders.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- label_width:

  Label width of every column. Element Plus's `label-width` (string /
  number).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `title`, `extra`.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Examples

``` r
el_descriptions("user", title = "Account", border = TRUE, items = list(
  list(label = "Name", content = "Ada Lovelace"),
  list(label = "Plan", content = el_tag("plan", "Pro", type = "success")),
  list(label = "Address", content = "12 St James's Square, London", span = 2)
))
#> <div id="user" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="user_container" style="display: contents">
#>   <el-descriptions :title="dTitle === null ? undefined : dTitle" :extra="dExtra === null ? undefined : dExtra" :column="dColumn === null ? undefined : dColumn" :direction="dDirection === null ? undefined : dDirection" :border="dBorder === null ? undefined : dBorder" :size="dSize === null ? undefined : dSize" :label-width="dLabelWidth === null ? undefined : dLabelWidth">
#>     <el-descriptions-item label="Name">Ada Lovelace</el-descriptions-item>
#>     <el-descriptions-item label="Plan">
#>       <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose" :size="size === null ? undefined : size" :color="color === null ? undefined : color" :round="round === null ? undefined : round">{{label}}</el-tag>
#>     </el-descriptions-item>
#>     <el-descriptions-item label="Address" :span="2">12 St James's Square, London</el-descriptions-item>
#>   </el-descriptions>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"dTitle":"Account","dExtra":null,"dColumn":null,"dDirection":null,"dBorder":true,"dSize":null,"label":"Pro","type":"success","closable":false,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0,"round":null,"dLabelWidth":null},"methods":{"handleClick":"function() { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('plan:shiny.action', this.count); }","handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('plan_closed', 1, {priority: 'event'}); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"plan:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick","options.methods.handleClose","options.mounted"]}</script>
#> </div>

# The quick form: names are labels
el_descriptions("car", items = as.list(mtcars[1, 1:6]))
#> <div id="car" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="car_container" style="display: contents">
#>   <el-descriptions :title="dTitle === null ? undefined : dTitle" :extra="dExtra === null ? undefined : dExtra" :column="dColumn === null ? undefined : dColumn" :direction="dDirection === null ? undefined : dDirection" :border="dBorder === null ? undefined : dBorder" :size="dSize === null ? undefined : dSize" :label-width="dLabelWidth === null ? undefined : dLabelWidth">
#>     <el-descriptions-item label="mpg">21</el-descriptions-item>
#>     <el-descriptions-item label="cyl">6</el-descriptions-item>
#>     <el-descriptions-item label="disp">160</el-descriptions-item>
#>     <el-descriptions-item label="hp">110</el-descriptions-item>
#>     <el-descriptions-item label="drat">3.9</el-descriptions-item>
#>     <el-descriptions-item label="wt">2.62</el-descriptions-item>
#>   </el-descriptions>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"dTitle":null,"dExtra":null,"dColumn":null,"dDirection":null,"dBorder":null,"dSize":null,"dLabelWidth":null}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>
```
