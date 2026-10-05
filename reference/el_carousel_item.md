# A slide of [`el_carousel()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel.md)

Element Plus's `el-carousel-item`, for `el_carousel(items =)`.

## Usage

``` r
el_carousel_item(..., name = NULL, label = NULL)
```

## Arguments

- ...:

  The slide's content.

- name:

  The slide's value, `input$<id>` while it is showing.

- label:

  Text of the slide's indicator.

## Value

A slide, for `el_carousel(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
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
el_carousel(
  "car",
  items = list(
    el_carousel_item(htmltools::tags$h3("1"), name = "first"),
    el_carousel_item(htmltools::tags$h3("2"), name = "second")
  )
)
#> <div id="car" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="car_container" style="display: contents">
#>   <el-carousel ref="carousel" :height="height" :initial-index="initialIndex" :autoplay="autoplay" :interval="interval" :trigger="trigger" :arrow="arrow" :loop="loop" :direction="direction" :indicator-position="indicatorPosition === null ? undefined : indicatorPosition" :type="carouselType === null ? undefined : carouselType" @change="handleChange" :card-scale="carouselCardScale === null ? undefined : carouselCardScale" :motion-blur="carouselMotionBlur === null ? undefined : carouselMotionBlur" :pause-on-hover="carouselPauseOnHover === null ? undefined : carouselPauseOnHover">
#>     <el-carousel-item name="first">
#>       <h3>1</h3>
#>     </el-carousel-item>
#>     <el-carousel-item name="second">
#>       <h3>2</h3>
#>     </el-carousel-item>
#>   </el-carousel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"height":"300px","initialIndex":0,"autoplay":true,"interval":3000,"trigger":"hover","arrow":"hover","loop":true,"direction":"horizontal","indicatorPosition":null,"carouselType":null,"itemNames":["first","second"],"active":0,"activeName":"first","carouselCardScale":null,"carouselMotionBlur":null,"carouselPauseOnHover":null},"methods":{"handleChange":"function(index) { var self = this; self.active = index; self.activeName = self.itemNames[index] || ''; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('car_name', self.activeName); }","shinyVueReceive":"function(d) { if ('active' in d) { if (this.$refs.carousel) this.$refs.carousel.setActiveItem(d.active); delete d.active; } return d; }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"car_name\", self.activeName); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"active","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange","options.methods.shinyVueReceive","options.mounted"]}</script>
#> </div>
```
