# Element Plus Scrollbar

A scroll area with Element's own thin scrollbars.

## Usage

``` r
el_scrollbar(
  ...,
  id = NULL,
  height = NULL,
  max_height = NULL,
  native = NULL,
  wrap_style = NULL,
  wrap_class = NULL,
  view_style = NULL,
  view_class = NULL,
  noresize = NULL,
  tag = NULL,
  always = NULL,
  min_size = NULL,
  role = NULL,
  aria_label = NULL,
  aria_orientation = NULL,
  tabindex = NULL,
  distance = NULL,
  width = NULL,
  slots = NULL
)
```

## Arguments

- ...:

  Its content: any Shiny UI. Components of this package are folded into
  this one's Vue instance, as
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md)
  folds its buttons.

- id:

  Component ID. Auto-generated if `NULL`.

- height:

  Height of scrollbar. Element Plus's `height` (string / number).

- max_height:

  Max height of scrollbar. Element Plus's `max-height` (string /
  number).

- native:

  Whether to use the native scrollbar style. Element Plus's `native`
  (boolean).

- wrap_style:

  Style of wrap container. Element Plus's `wrap-style` (string /
  CSSProperties \| CSSProperties\[\] \| string\[\]).

- wrap_class:

  Class of wrap container. Element Plus's `wrap-class` (string).

- view_style:

  Style of view. Element Plus's `view-style`
  (`string / CSSProperties | CSSProperties[] | string[]`).

- view_class:

  Class of view. Element Plus's `view-class` (string).

- noresize:

  Do not respond to container size changes, if the container size does
  not change, it is better to set it to optimize performance. Element
  Plus's `noresize` (boolean).

- tag:

  Element tag of the view. Element Plus's `tag` (string).

- always:

  Always show scrollbar. Element Plus's `always` (boolean).

- min_size:

  Minimum size of scrollbar. Element Plus's `min-size` (number).

- role:

  Role of view. Element Plus's `role` (string).

- aria_label:

  Aria-label of view. Element Plus's `aria-label` (string).

- aria_orientation:

  Aria-orientation of view. Element Plus's `aria-orientation`
  ('horizontal' \| 'vertical').

- tabindex:

  Tabindex of wrap container. Element Plus's `tabindex` (number /
  string).

- distance:

  Trigger end-reached event distance(px). Element Plus's `distance`
  (number).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_scroll` – Element Plus's `scroll` event.

- `input$<id>_end_reached` – Element Plus's `end-reached` event.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`handleScroll()`, `scrollTo()`, `setScrollTop()`, `setScrollLeft()`,
[`update()`](https://rdrr.io/r/stats/update.html).

## Examples

``` r
el_scrollbar(height = "200px", lapply(1:20, function(i) shiny::tags$p(i)))
#> <div id="el_scrollbar_e7f223dd-cc06-451d-bf7c-8b36d5af6c59" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_scrollbar_e7f223dd-cc06-451d-bf7c-8b36d5af6c59_container" style="display: contents">
#>   <el-scrollbar :height="height === null ? undefined : height" :max-height="maxHeight === null ? undefined : maxHeight" :native="native === null ? undefined : native" :wrap-style="wrapStyle === null ? undefined : wrapStyle" :wrap-class="wrapClass === null ? undefined : wrapClass" :view-style="viewStyle === null ? undefined : viewStyle" :view-class="viewClass === null ? undefined : viewClass" :noresize="noresize === null ? undefined : noresize" :tag="tag === null ? undefined : tag" :always="always === null ? undefined : always" :min-size="minSize === null ? undefined : minSize" :role="role === null ? undefined : role" :aria-label="ariaLabel === null ? undefined : ariaLabel" :aria-orientation="ariaOrientation === null ? undefined : ariaOrientation" :tabindex="tabindex === null ? undefined : tabindex" :distance="distance === null ? undefined : distance" @scroll="elEmitScroll" @end-reached="elEmitEndReached">
#>     <p>1</p>
#>     <p>2</p>
#>     <p>3</p>
#>     <p>4</p>
#>     <p>5</p>
#>     <p>6</p>
#>     <p>7</p>
#>     <p>8</p>
#>     <p>9</p>
#>     <p>10</p>
#>     <p>11</p>
#>     <p>12</p>
#>     <p>13</p>
#>     <p>14</p>
#>     <p>15</p>
#>     <p>16</p>
#>     <p>17</p>
#>     <p>18</p>
#>     <p>19</p>
#>     <p>20</p>
#>   </el-scrollbar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"height":"200px","maxHeight":null,"native":null,"wrapStyle":null,"wrapClass":null,"viewStyle":null,"viewClass":null,"noresize":null,"tag":null,"always":null,"minSize":null,"role":null,"ariaLabel":null,"ariaOrientation":null,"tabindex":null,"distance":null},"methods":{"elEmitScroll":"function() { window.shinyVue.emit('el_scrollbar_e7f223dd-cc06-451d-bf7c-8b36d5af6c59', 'scroll', arguments, 200); }","elEmitEndReached":"function() { window.shinyVue.emit('el_scrollbar_e7f223dd-cc06-451d-bf7c-8b36d5af6c59', 'end_reached', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.elEmitScroll","options.methods.elEmitEndReached"]}</script>
#> </div>
```
