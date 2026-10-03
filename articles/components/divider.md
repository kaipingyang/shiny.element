# Divider

The dividing line that separates the content.

## Basic usage

Divide the text of different paragraphs.

``` r

tags$div(
  tags$span("I sit at a desk, wondering how to approach the vast ocean."),
  el_divider(),
  tags$span(
    "I wonder how far the eyes can see, and how far the heart can feel."
  )
)
```

I sit at a desk, wondering how to approach the vast ocean.

I wonder how far the eyes can see, and how far the heart can feel.

## Custom content

You can customize the content on the divider line.

``` r

tags$div(
  tags$span("What you are you do not see, what you see is your shadow."),
  el_divider(content_position = "left", "Rabindranath Tagore"),
  tags$span("I cannot choose the best. The best chooses me."),
  el_divider(el_icon("StarFilled")),
  tags$span("My wishes are fools, they shout across thy song, my Master."),
  el_divider(content_position = "right", "Rabindranath Tagore"),
  tags$span("I cannot choose the best. The best chooses me.")
)
```

What you are you do not see, what you see is your shadow.

Rabindranath Tagore

I cannot choose the best. The best chooses me.

My wishes are fools, they shout across thy song, my Master.

Rabindranath Tagore

I cannot choose the best. The best chooses me.

## dashed line

You can set the style of divider.

``` r

tags$div(
  tags$span("What language is thine, O sea?"),
  el_divider(border_style = "dashed"),
  tags$span("The language of eternal question."),
  el_divider(border_style = "dotted"),
  tags$span("What language is thy answer, O sky?"),
  el_divider(direction = "vertical", border_style = "dashed"),
  tags$span("The language of eternal silence.")
)
```

What language is thine, O sea?

The language of eternal question.

What language is thy answer, O sky?

The language of eternal silence.

## Vertical divider

``` r

tags$div(
  tags$span("Rain"),
  el_divider(direction = "vertical"),
  tags$span("Home"),
  el_divider(direction = "vertical", border_style = "dashed"),
  tags$span("Grass")
)
```

Rain

Home

Grass

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `direction` | `direction` | Set divider’s direction | [^1]`'horizontal' \\| 'vertical'` |  | horizontal |
| `border-style` | `border_style` | Set the style of divider | [^2]`'none' \\| 'solid' \\| 'hidden' \\| 'dashed' \\| ...` [css/border-style](https://developer.mozilla.org/zh-CN/docs/Web/CSS/border-style) |  | solid |
| `content-position` | `content_position` | The position of the customized content on the divider line | [^3]`'left' \\| 'right' \\| 'center'` |  | center |

### Slots

| Element   | In R            | Description                            |
|-----------|-----------------|----------------------------------------|
| `default` | default content | Customized content on the divider line |

[^1]: enum

[^2]: enum

[^3]: enum
