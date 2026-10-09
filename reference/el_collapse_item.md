# A panel of [`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md)

Element Plus's `el-collapse-item`, for `el_collapse(items =)`.

## Usage

``` r
el_collapse_item(title, ..., name = title, icon = NULL, disabled = NULL)
```

## Arguments

- title:

  Title of the panel.

- ...:

  The panel's content.

- name:

  The panel's value, reported in `input$<id>` while it is open. Defaults
  to `title`.

- icon:

  The expand icon, by name (Element's default `"ArrowRight"`), or a tag.

- disabled:

  Whether the panel is disabled.

## Value

A panel, for `el_collapse(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
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
el_collapse(
  "c",
  items = list(
    el_collapse_item("Consistency", "Consistent with real life."),
    el_collapse_item("Feedback", "Operation feedback.", disabled = TRUE)
  )
)
#> <div id="c" class="el-collapse el-collapse-icon-position-right" data-el-collapse="true" data-shiny-island data-accordion="false">
#>   <div class="el-collapse-item" data-el-name="Consistency">
#>     <div id="c-head-Consistency" role="button" tabindex="0" aria-expanded="false" aria-controls="c-content-Consistency" aria-describedby="c-content-Consistency" class="el-collapse-item__header">
#>       <span class="el-collapse-item__title">Consistency</span>
#>       <i class="el-icon el-collapse-item__arrow" data-el-icon="ArrowRight"></i>
#>     </div>
#>     <div id="c-content-Consistency" role="region" aria-hidden="true" aria-labelledby="c-head-Consistency" class="el-collapse-item__wrap" style="display:none">
#>       <div class="el-collapse-item__content">Consistent with real life.</div>
#>     </div>
#>   </div>
#>   <div class="el-collapse-item is-disabled" data-el-name="Feedback">
#>     <div id="c-head-Feedback" role="button" aria-expanded="false" aria-controls="c-content-Feedback" aria-describedby="c-content-Feedback" aria-disabled="true" class="el-collapse-item__header">
#>       <span class="el-collapse-item__title">Feedback</span>
#>       <i class="el-icon el-collapse-item__arrow" data-el-icon="ArrowRight"></i>
#>     </div>
#>     <div id="c-content-Feedback" role="region" aria-hidden="true" aria-labelledby="c-head-Feedback" class="el-collapse-item__wrap" style="display:none">
#>       <div class="el-collapse-item__content">Operation feedback.</div>
#>     </div>
#>   </div>
#> </div>
```
