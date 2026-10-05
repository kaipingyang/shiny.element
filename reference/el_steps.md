# Element Plus Steps Component

Element Plus Steps Component

## Usage

``` r
el_steps(
  id = NULL,
  steps = list(),
  active = 0,
  space = NULL,
  direction = "horizontal",
  process_status = "process",
  finish_status = "finish",
  align_center = FALSE,
  simple = FALSE,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Steps ID (auto-generated if NULL)

- steps:

  A list of steps, each an
  [`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md)
  – or a list with `title`, `description`, `icon` and `status`. `title`,
  `description` and `icon` may be markup rather than text, which fills
  the step's slot of that name.

- active:

  Current active step index (0-based)

- space:

  Step spacing (number or percentage string)

- direction:

  Display direction ("horizontal" or "vertical")

- process_status:

  Status of current step

- finish_status:

  Status of finished steps

- align_center:

  Center align title and description

- simple:

  Apply simple style

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

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Examples

``` r
# Basic usage
el_steps(
  id = "my_steps",
  steps = list(
    list(title = "Step 1"),
    list(title = "Step 2"),
    list(title = "Step 3")
  )
)
#> <div id="my_steps" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="my_steps_container" style="display: contents">
#>   <el-steps :active="active" :direction="direction" :process-status="processStatus" :finish-status="finishStatus" :align-center="alignCenter" :simple="simple" :space="space === null ? undefined : space" @change="elEmitChange">
#>     <el-step title="Step 1"></el-step>
#>     <el-step title="Step 2"></el-step>
#>     <el-step title="Step 3"></el-step>
#>   </el-steps>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"active":0,"direction":"horizontal","processStatus":"process","finishStatus":"finish","alignCenter":false,"simple":false,"space":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('my_steps', 'change', arguments); }"},"watch":{"active":"function(newVal) { }"}},"input":"active","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitChange","options.watch.active"]}</script>
#> </div>

# With descriptions and icons
el_steps(
  id = "my_steps",
  active = 1,
  finish_status = "success",
  steps = list(
    list(
      title = "Step 1",
      description = "Complete registration",
      icon = "el-icon-edit"
    ),
    list(
      title = "Step 2",
      description = "Upload documents",
      icon = "el-icon-upload"
    ),
    list(title = "Step 3", description = "Finish", icon = "el-icon-picture")
  )
)
#> <div id="my_steps" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="my_steps_container" style="display: contents">
#>   <el-steps :active="active" :direction="direction" :process-status="processStatus" :finish-status="finishStatus" :align-center="alignCenter" :simple="simple" :space="space === null ? undefined : space" @change="elEmitChange">
#>     <el-step title="Step 1" description="Complete registration" icon="el-icon-edit"></el-step>
#>     <el-step title="Step 2" description="Upload documents" icon="el-icon-upload"></el-step>
#>     <el-step title="Step 3" description="Finish" icon="el-icon-picture"></el-step>
#>   </el-steps>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"active":1,"direction":"horizontal","processStatus":"process","finishStatus":"success","alignCenter":false,"simple":false,"space":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('my_steps', 'change', arguments); }"},"watch":{"active":"function(newVal) { }"}},"input":"active","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitChange","options.watch.active"]}</script>
#> </div>
```
