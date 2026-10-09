# A tab of [`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md)

Element Plus's `el-tab-pane`, for `el_tabs(tabs =)` and
[`update_el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md):
`el_tabs("t", tabs = list(el_tab_pane("One", ...), el_tab_pane("Two", ...)))`.

## Usage

``` r
el_tab_pane(
  label,
  ...,
  name = label,
  disabled = NULL,
  closable = NULL,
  lazy = NULL
)
```

## Arguments

- label:

  Title of the tab.

- ...:

  The tab's content: tags, text, this package's components.

- name:

  The tab's value, `input$<id>` while it is selected. Defaults to
  `label`.

- disabled:

  Whether the tab is disabled.

- closable:

  Whether this tab can be closed, when the tabs' own `closable` is off.

- lazy:

  Render the content only when the tab is first selected. Its components
  do not exist, and report nothing, until then.

## Value

A tab, for `el_tabs(tabs =)`.

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
[`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

## Examples

``` r
el_tabs(
  "t",
  tabs = list(
    el_tab_pane("User", "User settings"),
    el_tab_pane("Config", el_switch("dark"), lazy = TRUE)
  )
)
#> <div id="t" class="el-tabs el-tabs--top" data-el-tabs="true" data-el-events="tab_remove tab_add" data-position="top" data-carded="false" data-closable="false">
#>   <div class="el-tabs__header is-top">
#>     <div class="el-tabs__nav-wrap is-top">
#>       <div class="el-tabs__nav-scroll">
#>         <div role="tablist" class="el-tabs__nav is-top">
#>           <div class="el-tabs__active-bar is-top"></div>
#>           <div id="t-tab-User" role="tab" aria-controls="t-pane-User" aria-selected="true" tabindex="0" class="el-tabs__item is-top is-active" data-el-name="User">User</div>
#>           <div id="t-tab-Config" role="tab" aria-controls="t-pane-Config" tabindex="-1" class="el-tabs__item is-top" data-el-name="Config">Config</div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="el-tabs__content">
#>     <div role="tabpanel" id="t-pane-User" aria-labelledby="t-tab-User" class="el-tab-pane" data-el-name="User">User settings</div>
#>     <div role="tabpanel" id="t-pane-Config" aria-labelledby="t-tab-Config" aria-hidden="true" class="el-tab-pane" style="display:none" data-el-name="Config">
#>       <template data-el-lazy="true">
#>         <div id="dark" data-shiny-vue style="display: contents">
#>           <script type="text/x-template" data-shiny-vue-template><div id="dark_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :style="{ &#39;--el-switch-on-color&#39;: activeColor || undefined, &#39;--el-switch-off-color&#39;: inactiveColor || undefined, &#39;--el-switch-border-color&#39;: borderColor || undefined }" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent" :active-action-icon="activeActionIcon === null ? undefined : activeActionIcon" :active-icon="activeIcon === null ? undefined : activeIcon" :aria-label="ariaLabel === null ? undefined : ariaLabel" :before-change="beforeChange === null ? undefined : beforeChange" :border-color="borderColor === null ? undefined : borderColor" :inactive-action-icon="inactiveActionIcon === null ? undefined : inactiveActionIcon" :inactive-icon="inactiveIcon === null ? undefined : inactiveIcon" :inline-prompt="inlinePrompt === null ? undefined : inlinePrompt" :loading="loading === null ? undefined : loading" :size="size === null ? undefined : size" :tabindex="tabindex === null ? undefined : tabindex"></el-switch>
#> </div></script>
#>           <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"name":null,"validateEvent":null,"activeActionIcon":null,"activeIcon":null,"ariaLabel":null,"beforeChange":null,"borderColor":null,"inactiveActionIcon":null,"inactiveIcon":null,"inlinePrompt":null,"loading":null,"size":null,"tabindex":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#>         </div>
#>       </template>
#>     </div>
#>   </div>
#> </div>
```
