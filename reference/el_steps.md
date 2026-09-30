# Element UI Steps Component

Element UI Steps Component

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
  session = getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Steps ID (auto-generated if NULL)

- steps:

  List of step definitions, each with title, description, icon, status

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

- session:

  Shiny session for module support

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
#> <div id="my_steps_container" style="display: contents">
#>   <el-steps :active="active" :direction="direction" :process-status="processStatus" :finish-status="finishStatus" :align-center="alignCenter" :simple="simple" :space="space === null ? undefined : space">
#>     <el-step title="Step 1"></el-step>
#>     <el-step title="Step 2"></el-step>
#>     <el-step title="Step 3"></el-step>
#>   </el-steps>
#> </div>
#> <div id="my_steps" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="my_steps">{"x":{"el":"#my_steps_container","data":{"active":0,"direction":"horizontal","processStatus":"process","finishStatus":"finish","alignCenter":false,"simple":false,"space":null},"watch":{"active":"function(newVal) { Shiny.setInputValue('my_steps', newVal); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"my_steps\", self.active); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["watch.active","mounted"],"jsHooks":[]}</script>
 
# With descriptions and icons  
el_steps(  
  id = "my_steps",  
  active = 1,  
  finish_status = "success",  
  steps = list(  
    list(title = "Step 1", description = "Complete registration", icon = "el-icon-edit"),  
    list(title = "Step 2", description = "Upload documents", icon = "el-icon-upload"),  
    list(title = "Step 3", description = "Finish", icon = "el-icon-picture")  
  )  
)  
#> <div id="my_steps_container" style="display: contents">
#>   <el-steps :active="active" :direction="direction" :process-status="processStatus" :finish-status="finishStatus" :align-center="alignCenter" :simple="simple" :space="space === null ? undefined : space">
#>     <el-step title="Step 1" description="Complete registration" icon="el-icon-edit"></el-step>
#>     <el-step title="Step 2" description="Upload documents" icon="el-icon-upload"></el-step>
#>     <el-step title="Step 3" description="Finish" icon="el-icon-picture"></el-step>
#>   </el-steps>
#> </div>
#> <div id="my_steps" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="my_steps">{"x":{"el":"#my_steps_container","data":{"active":1,"direction":"horizontal","processStatus":"process","finishStatus":"success","alignCenter":false,"simple":false,"space":null},"watch":{"active":"function(newVal) { Shiny.setInputValue('my_steps', newVal); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"my_steps\", self.active); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["watch.active","mounted"],"jsHooks":[]}</script>
```
