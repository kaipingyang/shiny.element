# Element UI Result

The outcome of an operation: an icon, a title, a line of detail, and
what to do next.

## Usage

``` r
el_result(
  id = NULL,
  ...,
  icon = NULL,
  title = NULL,
  sub_title = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- ...:

  What to do next, shown under the text – usually buttons. A
  shiny.element component here is absorbed, not nested, and keeps
  reporting its inputs.

- icon:

  `"success"`, `"warning"`, `"info"` or `"error"`.

- title:

  Headline.

- sub_title:

  Detail under the headline.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `icon`, `title`, `subTitle`,
  `extra`.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Examples

``` r
el_result("done", icon = "success", title = "Report submitted",
          sub_title = "It will be reviewed within a day",
          el_button("back", "Back to the list", type = "primary"))
#> <div id="done_container" style="display: contents">
#>   <el-result :icon="resultIcon === null ? undefined : resultIcon" :title="resultTitle === null ? undefined : resultTitle" :sub-title="resultSubTitle === null ? undefined : resultSubTitle">
#>     <template slot="extra">
#>       <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#>     </template>
#>   </el-result>
#> </div>
#> <div id="done" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="done">{"x":{"el":"#done_container","data":{"resultIcon":"success","resultTitle":"Report submitted","resultSubTitle":"It will be reviewed within a day","label":"Back to the list","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('back', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
```
