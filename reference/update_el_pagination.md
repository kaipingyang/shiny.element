# Update Element Plus Pagination

Server-side update for
[`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md).

## Usage

``` r
update_el_pagination(
  session = shiny::getDefaultReactiveDomain(),
  id,
  total = NULL,
  current_page = NULL,
  page_size = NULL,
  disabled = NULL,
  page_sizes = NULL,
  layout = NULL,
  background = NULL,
  small = NULL,
  pager_count = NULL,
  prev_text = NULL,
  next_text = NULL,
  hide_on_single_page = NULL,
  page_count = NULL,
  popper_class = NULL,
  append_size_to = NULL,
  next_icon = NULL,
  popper_style = NULL,
  prev_icon = NULL,
  size = NULL,
  teleported = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Pagination ID (un-namespaced).

- total:

  New total item count.

- current_page:

  New current page number.

- page_size:

  New page size.

- disabled:

  New disabled state.

- page_sizes:

  Vector of page-size options. Default `c(10, 20, 30, 50)`.

- layout:

  Comma-separated list of layout elements. Default
  `"total, sizes, prev, pager, next, jumper"`.

- background:

  Whether to use background colour on page buttons. Default `FALSE`.

- small:

  Whether to use compact (small) mode. Default `FALSE`.

- pager_count:

  Number of pager buttons to show. Default `7`.

- prev_text:

  Text of the previous-page button, in place of the arrow icon.

- next_text:

  Text of the next-page button, in place of the arrow icon.

- hide_on_single_page:

  Whether to hide the pager when there is only one page.

- page_count:

  Total page count. Set either this or `total`.

- popper_class:

  Extra class name for the page-size dropdown.

- append_size_to:

  Which element the size dropdown appends to. Element Plus's
  `append-size-to` (string).

- next_icon:

  Icon for the next button, has a lower priority than `next-text`.
  Element Plus's `next-icon` (string / Component). An icon's name, such
  as `"Search"`.

- popper_style:

  Custom style for the page size Select's dropdown. Element Plus's
  `popper-style` (string / object).

- prev_icon:

  Icon for the prev button, has a lower priority than `prev-text`.
  Element Plus's `prev-icon` (string / Component). An icon's name, such
  as `"Search"`.

- size:

  Pagination size. Element Plus's `size` ('large' \| 'default' \|
  'small').

- teleported:

  Whether Pagination select dropdown is teleported to the body. Element
  Plus's `teleported` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_pagination()`](https://kaipingyang.github.io/shiny.element/reference/el_pagination.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_pagination(session, "pager", current_page = 2)
  })
}
```
