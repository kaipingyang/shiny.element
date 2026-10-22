# Layout

Quickly and easily create layouts with the basic 24-column.

> **Tip**
>
> The component uses flex layout by default, no need to set
> `type="flex"` manually.
>
> Please note that the parent container should avoid using `inline`
> related styles, which will cause the component to not fill up its
> width.
>
> The basic unit of a column is 1, with a maximum of 24 and a minimum of
> 0.

## Basic layout

Create basic grid layout using columns.

With `row` and `col`, we can easily manipulate the layout using the
`span` attribute.

``` r

cell <- function(dark = FALSE) {
  tags$div(
    class = "grid-content",
    style = sprintf(
      "border-radius: 4px; min-height: 36px; background: %s",
      if (dark) "#99a9bf" else "#d3dce6"
    )
  )
}
row <- function(...) el_row(style = "margin-bottom: 20px", ...)
tagList(
  row(el_col(span = 24, cell(TRUE))),
  row(lapply(1:2, function(i) el_col(span = 12, cell(i == 2)))),
  row(lapply(1:3, function(i) el_col(span = 8, cell(i == 2)))),
  row(lapply(1:4, function(i) el_col(span = 6, cell(i %% 2 == 0)))),
  row(lapply(1:6, function(i) el_col(span = 4, cell(i %% 2 == 0))))
)
```

## Column spacing

Column spacing is supported.

Row provides `gutter` attribute to specify spacings between columns, and
its default value is 0.

``` r

cell <- tags$div(
  style = "border-radius: 4px; min-height: 36px; background: #d3dce6"
)
el_row(gutter = 20, lapply(1:4, function(i) el_col(span = 6, cell)))
```

## Hybrid layout

Form a more complex hybrid layout by combining the basic 1/24 columns.

``` r

cell <- tags$div(
  style = "border-radius: 4px; min-height: 36px; background: #d3dce6"
)
tagList(
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 16, cell),
    el_col(span = 8, cell)
  ),
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 8, cell),
    el_col(span = 8, cell),
    el_col(span = 4, cell),
    el_col(span = 4, cell)
  ),
  el_row(
    gutter = 20,
    el_col(span = 4, cell),
    el_col(span = 16, cell),
    el_col(span = 4, cell)
  )
)
```

## Column offset

You can specify column offsets.

You can specify the number of column offset by setting the value of
`offset` attribute of Col.

``` r

cell <- tags$div(
  style = "border-radius: 4px; min-height: 36px; background: #d3dce6"
)
tagList(
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 6, cell),
    el_col(span = 6, offset = 6, cell)
  ),
  el_row(
    gutter = 20,
    style = "margin-bottom: 20px",
    el_col(span = 6, offset = 6, cell),
    el_col(span = 6, offset = 6, cell)
  ),
  el_row(gutter = 20, el_col(span = 12, offset = 6, cell))
)
```

## Alignment

Default use the flex layout to make flexible alignment of columns.

You can define the layout of child elements by setting `justify`
attribute with start, center, end, space-between, space-around or
space-evenly.

``` r

cell <- function(light = FALSE) {
  tags$div(
    style = sprintf(
      "border-radius: 4px; min-height: 36px; background: %s",
      if (light) "#e5e9f2" else "#d3dce6"
    )
  )
}
cols <- function() {
  list(
    el_col(span = 6, cell()),
    el_col(span = 6, cell(TRUE)),
    el_col(span = 6, cell())
  )
}
tagList(lapply(
  c("start", "center", "end", "space-between", "space-around", "space-evenly"),
  function(j) {
    el_row(
      justify = j,
      style = "margin-bottom: 20px; background: #f9fafc",
      cols()
    )
  }
))
```

## Responsive Layout

Taking example by Bootstrap’s responsive design, five breakpoints are
preset: xs, sm, md, lg and xl.

``` r

cell <- function(light = FALSE) {
  tags$div(
    style = sprintf(
      "border-radius: 4px; min-height: 36px; background: %s",
      if (light) "#e5e9f2" else "#d3dce6"
    )
  )
}
el_row(
  gutter = 10,
  el_col(xs = 8, sm = 6, md = 4, lg = 3, xl = 1, cell()),
  el_col(xs = 4, sm = 6, md = 8, lg = 9, xl = 11, cell(TRUE)),
  el_col(xs = 4, sm = 6, md = 8, lg = 9, xl = 11, cell()),
  el_col(xs = 8, sm = 6, md = 4, lg = 3, xl = 1, cell(TRUE))
)
```

## Utility classes for hiding elements

Additionally, Element Plus provides a series of classes for hiding
elements under certain conditions. These classes can be added to any DOM
elements or custom components. You need to import the following CSS file
to use these classes:

The classes are:

- `hidden-xs-only` - hide when on extra small viewports only
- `hidden-sm-only` - hide when on small viewports only
- `hidden-sm-and-down` - hide when on small viewports and down
- `hidden-sm-and-up` - hide when on small viewports and up
- `hidden-md-only` - hide when on medium viewports only
- `hidden-md-and-down` - hide when on medium viewports and down
- `hidden-md-and-up` - hide when on medium viewports and up
- `hidden-lg-only` - hide when on large viewports only
- `hidden-lg-and-down` - hide when on large viewports and down
- `hidden-lg-and-up` - hide when on large viewports and up
- `hidden-xl-only` - hide when on extra large viewports only

## API

Element Plus’s tables, and beside each entry where it is in R.

### Row Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `gutter` | `el_row(gutter =)` | grid spacing | [^1] |  | 0 |
| `justify` | `el_row(justify =)` | horizontal alignment of flex layout | [^2]`'start' \\| 'end' \\| 'center' \\| 'space-around' \\| 'space-between' \\| 'space-evenly'` |  | start |
| `align` | `el_row(align =)` | vertical alignment of flex layout | [^3]`'top' \\| 'middle' \\| 'bottom'` |  | — |
| `tag` | `el_row(tag =)` | custom element tag | [^4] |  | div |

### Row Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Col Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `span` | `el_col(span =)` | number of column the grid spans | [^5] |  | 24 |
| `offset` | `el_col(offset =)` | number of spacing on the left side of the grid | [^6] |  | 0 |
| `push` | `el_col(push =)` | number of columns that grid moves to the right | [^7] |  | 0 |
| `pull` | `el_col(pull =)` | number of columns that grid moves to the left | [^8] |  | 0 |
| `xs` | `el_col(xs =)` | `<768px` Responsive columns or column props object | [^9] / [^10]`{span?: number, offset?: number, pull?: number, push?: number}` |  | — |
| `sm` | `el_col(sm =)` | `≥768px` Responsive columns or column props object | [^11] / [^12]`{span?: number, offset?: number, pull?: number, push?: number}` |  | — |
| `md` | `el_col(md =)` | `≥992px` Responsive columns or column props object | [^13] / [^14]`{span?: number, offset?: number, pull?: number, push?: number}` |  | — |
| `lg` | `el_col(lg =)` | `≥1200px` Responsive columns or column props object | [^15] / [^16]`{span?: number, offset?: number, pull?: number, push?: number}` |  | — |
| `xl` | `el_col(xl =)` | `≥1920px` Responsive columns or column props object | [^17] / [^18]`{span?: number, offset?: number, pull?: number, push?: number}` |  | — |
| `tag` | `el_row(tag =)` | custom element tag | [^19] |  | div |

### Col Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: number

[^2]: enum

[^3]: enum

[^4]: string

[^5]: number

[^6]: number

[^7]: number

[^8]: number

[^9]: number

[^10]: object

[^11]: number

[^12]: object

[^13]: number

[^14]: object

[^15]: number

[^16]: object

[^17]: number

[^18]: object

[^19]: string
