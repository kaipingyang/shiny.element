# Pagination

If you have too much data to display in one page, use pagination.
`input$<id>` is the current page, `input$<id>_size` the page size.

## Basic usage

`layout` lists the parts, separated by commas: `prev`, `pager`,
[`next`](https://rdrr.io/r/base/Control.html), `jumper`, `->`, `total`,
`sizes`.

``` r

el_pagination("p1", total = 50, layout = "prev, pager, next")
el_pagination("p2", total = 1000, layout = "prev, pager, next")
```

## Number of pagers

``` r

el_pagination("pc", total = 1000, pager_count = 11, layout = "prev, pager, next")
```

## Buttons with background color

``` r

el_pagination("bg", total = 1000, background = TRUE, layout = "prev, pager, next")
```

## Small pagination

``` r

el_pagination("sm", total = 50, small = TRUE, layout = "prev, pager, next")
```

## More elements

``` r

el_pagination("m1", total = 100, current_page = 5, layout = "total, prev, pager, next")
el_pagination("m2", total = 400, current_page = 5, page_sizes = c(100, 200, 300, 400),
              page_size = 100, layout = "sizes, prev, pager, next")
el_pagination("m3", total = 400, current_page = 5, page_size = 100, layout = "prev, pager, next, jumper")
el_pagination("m4", total = 400, current_page = 4, page_sizes = c(100, 200, 300, 400),
              page_size = 100, layout = "total, sizes, prev, pager, next, jumper")
```

## Hide pagination when there is only one page

``` r

el_pagination("hide", total = 5, hide_on_single_page = TRUE, layout = "prev, pager, next")
tags$p("(nothing above: one page)")
```

(nothing above: one page)

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `small` | `small` | whether to use small pagination | boolean | — | false |
| `background` | `background` | whether the buttons have a background color | boolean | — | false |
| `page-size` | `page_size` | item count of each page, supports the .sync modifier | number | — | 10 |
| `total` | `total` | total item count | number | — | — |
| `page-count` | `page_count` | total page count. Set either `total` or `page-count` and pages will be displayed; if you need `page-sizes`, `total` is required | number | — | — |
| `pager-count` | `pager_count` | number of pagers. Pagination collapses when the total page count exceeds this value | number | odd number between 5 and 21 | 7 |
| `current-page` | `current_page` | current page number, supports the .sync modifier | number | — | 1 |
| `layout` | `layout` | layout of Pagination, elements separated with a comma | string | `sizes`, `prev`, `pager`, [`next`](https://rdrr.io/r/base/Control.html), `jumper`, `->`, `total`, `slot` | ‘prev, pager, next, jumper, -\>, total’ |
| `page-sizes` | `page_sizes` | options of item count per page | number\[\] | — | \[10, 20, 30, 40, 50, 100\] |
| `popper-class` | `popper_class` | custom class name for the page size Select’s dropdown | string | — | — |
| `prev-text` | `prev_text` | text for the prev button | string | — | — |
| `next-text` | `next_text` | text for the next button | string | — | — |
| `disabled` | `disabled` | whether Pagination is disabled | boolean | — | false |
| `hide-on-single-page` | `hide_on_single_page` | whether to hide when there’s only one page | boolean | — | \- |

### Events

| Element | In R | Description |
|----|----|----|
| `size-change` | one of the component’s inputs – see its reference page | triggers when `page-size` changes |
| `current-change` | one of the component’s inputs – see its reference page | triggers when `current-page` changes |
| `prev-click` | `input$<id>_prev_click` | triggers when the prev button is clicked and current page changes |
| `next-click` | `input$<id>_next_click` | triggers when the next button is clicked and current page changes |
