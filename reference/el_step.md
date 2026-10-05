# A step of [`el_steps()`](https://kaipingyang.github.io/shiny.element/reference/el_steps.md)

Element Plus's `el-step`, for `el_steps(steps =)`.

## Usage

``` r
el_step(title = NULL, description = NULL, icon = NULL, status = NULL)
```

## Arguments

- title:

  Step title: text, or markup for the step's title slot.

- description:

  Step description: text, or markup.

- icon:

  The step's icon, by name, or markup.

- status:

  The step's status, set by the steps when not given: `""`, `"wait"`,
  `"process"`, `"finish"`, `"error"` or `"success"`.

## Value

A step, for `el_steps(steps =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton_item.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

## Examples

``` r
el_steps(
  "s",
  steps = list(
    el_step("Step 1", "Some description"),
    el_step("Step 2", icon = "Upload"),
    el_step("Step 3", status = "error")
  ),
  active = 1
)
#> <div id="s" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="s_container" style="display: contents">
#>   <el-steps :active="active" :direction="direction" :process-status="processStatus" :finish-status="finishStatus" :align-center="alignCenter" :simple="simple" :space="space === null ? undefined : space" @change="elEmitChange">
#>     <el-step title="Step 1" description="Some description"></el-step>
#>     <el-step title="Step 2" icon="Upload"></el-step>
#>     <el-step title="Step 3" status="error"></el-step>
#>   </el-steps>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"active":1,"direction":"horizontal","processStatus":"process","finishStatus":"finish","alignCenter":false,"simple":false,"space":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('s', 'change', arguments); }"},"watch":{"active":"function(newVal) { }"}},"input":"active","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitChange","options.watch.active"]}</script>
#> </div>
```
