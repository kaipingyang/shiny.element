# Text

Used for text.

## Basic

Use the `type` attribute to define Text’s type.

``` r

tags$div(lapply(
  c("default", "primary", "success", "info", "warning", "danger"),
  function(t) {
    tags$span(
      style = "margin: 0 4px",
      el_text(tools::toTitleCase(t), type = if (t != "default") t)
    )
  }
))
```

## Sizes

Use attribute `size` to set additional sizes with `large`, `default` or
`small`.

``` r

tags$div(
  tags$span(style = "margin: 0 4px", el_text("Large", size = "large")),
  tags$span(style = "margin: 0 4px", el_text("Default")),
  tags$span(style = "margin: 0 4px", el_text("Small", size = "small"))
)
```

## Ellipsis

Pass the `truncated` prop to render an ellipsis when the text exceeds
the width of the viewport or max-width set. `line-clamp` prop to render
multiline ellipsis. Starting from version 2.14.6, `isTruncated` is
exposed to indicate whether the text is truncated. You can use it to
show a tooltip only when truncation occurs.

``` r

tagList(
  tags$div(el_text(
    "Self element set width 150px",
    truncated = TRUE,
    width = "150px"
  )),
  tags$div(
    style = "width: 150px",
    el_text("Squeezed by parent element", truncated = TRUE)
  ),
  tags$div(el_text(
    HTML(
      "The -webkit-line-clamp CSS property<br>allows limiting of the contents of<br>",
      "a block to the specified number of lines."
    ),
    line_clamp = 2
  ))
)
```

## Override

Use attribute `tag` to override element

`tag` draws the text as another element.

``` r

el_space(
  direction = "vertical",
  el_text("span"),
  el_text("This is a paragraph.", tag = "p"),
  el_text("Bold", tag = "b"),
  el_text("Italic", tag = "i"),
  el_text("This is ", el_text("subscript", tag = "sub", size = "small")),
  el_text("This is ", el_text("superscript", tag = "sup", size = "small")),
  el_text("Inserted", tag = "ins"),
  el_text("Deleted", tag = "del"),
  el_text("Marked", tag = "mark")
)
```

## Mixed

Text mixed component

``` r

el_space(
  direction = "vertical",
  el_text(el_icon("ElementPlus"), " Element-Plus"),
  el_row(
    el_text("Rate"),
    tags$span(style = "margin-left: 4px", el_rate("txt_rate"))
  ),
  el_text(
    "This is text mixed icon ",
    el_icon("Bell"),
    " and component ",
    el_button("txt_btn", "Button")
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `type` | `type` | text type | [^1]`'primary' \\| 'success' \\| 'warning' \\| 'danger' \\| 'info'` |  | — |
| `size` | `size` | text size | [^2]`'large' \\| 'default' \\| 'small'` |  | default |
| `truncated` | `truncated` | render ellipsis | [^3] |  | false |
| `line-clamp` | `line_clamp` | maximum lines | [^4] / [^5] |  | — |
| `tag` | `tag` | custom element tag | [^6] |  | span |

### Slots

| Element   | In R            | Description     |
|-----------|-----------------|-----------------|
| `default` | default content | default content |

[^1]: enum

[^2]: enum

[^3]: boolean

[^4]: string

[^5]: number

[^6]: string
