# Element Plus Carousel

A slideshow of items, horizontal or vertical.

## Usage

``` r
el_carousel(
  id = NULL,
  items = list(),
  height = "300px",
  initial_index = 0,
  autoplay = TRUE,
  interval = 3000,
  trigger = "hover",
  indicator_position = NULL,
  arrow = "hover",
  type = NULL,
  loop = TRUE,
  direction = "horizontal",
  card_scale = NULL,
  motion_blur = NULL,
  pause_on_hover = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_carousel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  autoplay = NULL,
  interval = NULL,
  height = NULL,
  initial_index = NULL,
  trigger = NULL,
  indicator_position = NULL,
  arrow = NULL,
  loop = NULL,
  direction = NULL
)
```

## Arguments

- id:

  Carousel ID (auto-generated if NULL).

- items:

  A list of slides, each an
  [`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md)
  – or a list with `content` (a tag, tagList or string) and optionally
  `name`, used as the value reported when that slide is showing, and
  `label`, shown on its indicator. A slide's content may hold this
  package's components: they are folded into the carousel's own Vue
  instance and keep reporting their inputs.

- height:

  Slide height, e.g. `"300px"`.

- initial_index:

  Index of the slide shown first, 0-based.

- autoplay:

  Cycle through the slides on a timer.

- interval:

  Milliseconds between slides when `autoplay` is on.

- trigger:

  What switches slides when an indicator is used: `"hover"` (default) or
  `"click"`.

- indicator_position:

  `"outside"`, `"none"`, or NULL for inside.

- arrow:

  When to show the arrows: `"hover"` (default), `"always"` or `"never"`.

- type:

  `"card"` for the stacked card layout, or NULL for plain.

- loop:

  Return to the first slide after the last.

- direction:

  `"horizontal"` (default) or `"vertical"`.

- card_scale:

  When type is card, scaled size of secondary cards. Element Plus's
  `card-scale` (number).

- motion_blur:

  Infuse dynamism and smoothness into the carousel. Element Plus's
  `motion-blur` (boolean).

- pause_on_hover:

  Pause autoplay when hover. Element Plus's `pause-on-hover` (boolean).

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

  In `el_carousel()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_carousel()`, the Shiny session,
  the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- active:

  Index of the slide to show, 0-based.

## Value

A Shiny UI element.

## Shiny inputs

`input$<id>` holds the index of the slide currently showing, 0-based,
and `input$<id>_name` its `name` if one was given. Both are reported on
load and whenever the slide changes.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `next()` – Switch to the next slide

- `prev()` – Switch to the previous slide

- `setActiveItem()` – Manually switch slide

## Updating from the server

`update_el_carousel()` changes the component from the server.

Every other argument of `el_carousel()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_carousel()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_carousel(
  id = "banner",
  height = "200px",
  items = list(
    list(name = "one", content = shiny::tags$h3("First slide")),
    list(name = "two", content = shiny::tags$h3("Second slide")),
    list(name = "three", content = shiny::tags$h3("Third slide"))
  )
)
#> <div id="banner" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="banner_container" style="display: contents">
#>   <el-carousel ref="carousel" :height="height" :initial-index="initialIndex" :autoplay="autoplay" :interval="interval" :trigger="trigger" :arrow="arrow" :loop="loop" :direction="direction" :indicator-position="indicatorPosition === null ? undefined : indicatorPosition" :type="carouselType === null ? undefined : carouselType" @change="handleChange" :card-scale="carouselCardScale === null ? undefined : carouselCardScale" :motion-blur="carouselMotionBlur === null ? undefined : carouselMotionBlur" :pause-on-hover="carouselPauseOnHover === null ? undefined : carouselPauseOnHover">
#>     <el-carousel-item name="one">
#>       <h3>First slide</h3>
#>     </el-carousel-item>
#>     <el-carousel-item name="two">
#>       <h3>Second slide</h3>
#>     </el-carousel-item>
#>     <el-carousel-item name="three">
#>       <h3>Third slide</h3>
#>     </el-carousel-item>
#>   </el-carousel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"height":"200px","initialIndex":0,"autoplay":true,"interval":3000,"trigger":"hover","arrow":"hover","loop":true,"direction":"horizontal","indicatorPosition":null,"carouselType":null,"itemNames":["one","two","three"],"active":0,"activeName":"one","carouselCardScale":null,"carouselMotionBlur":null,"carouselPauseOnHover":null},"methods":{"handleChange":"function(index) { var self = this; self.active = index; self.activeName = self.itemNames[index] || ''; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('banner_name', self.activeName); }","shinyVueReceive":"function(d) { if ('active' in d) { if (this.$refs.carousel) this.$refs.carousel.setActiveItem(d.active); delete d.active; } return d; }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"banner_name\", self.activeName); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"active","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange","options.methods.shinyVueReceive","options.mounted"]}</script>
#> </div>

# Card layout, switching on click rather than hover
el_carousel(
  id = "cards",
  type = "card",
  trigger = "click",
  height = "180px",
  items = lapply(1:4, function(i) list(content = paste("Card", i)))
)
#> <div id="cards" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cards_container" style="display: contents">
#>   <el-carousel ref="carousel" :height="height" :initial-index="initialIndex" :autoplay="autoplay" :interval="interval" :trigger="trigger" :arrow="arrow" :loop="loop" :direction="direction" :indicator-position="indicatorPosition === null ? undefined : indicatorPosition" :type="carouselType === null ? undefined : carouselType" @change="handleChange" :card-scale="carouselCardScale === null ? undefined : carouselCardScale" :motion-blur="carouselMotionBlur === null ? undefined : carouselMotionBlur" :pause-on-hover="carouselPauseOnHover === null ? undefined : carouselPauseOnHover">
#>     <el-carousel-item>Card 1</el-carousel-item>
#>     <el-carousel-item>Card 2</el-carousel-item>
#>     <el-carousel-item>Card 3</el-carousel-item>
#>     <el-carousel-item>Card 4</el-carousel-item>
#>   </el-carousel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"height":"180px","initialIndex":0,"autoplay":true,"interval":3000,"trigger":"click","arrow":"hover","loop":true,"direction":"horizontal","indicatorPosition":null,"carouselType":"card","itemNames":["","","",""],"active":0,"activeName":"","carouselCardScale":null,"carouselMotionBlur":null,"carouselPauseOnHover":null},"methods":{"handleChange":"function(index) { var self = this; self.active = index; self.activeName = self.itemNames[index] || ''; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('cards_name', self.activeName); }","shinyVueReceive":"function(d) { if ('active' in d) { if (this.$refs.carousel) this.$refs.carousel.setActiveItem(d.active); delete d.active; } return d; }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"cards_name\", self.activeName); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"active","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange","options.methods.shinyVueReceive","options.mounted"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_carousel(session, "banner", active = 2)
  })
}
```
