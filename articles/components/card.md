# Card

Integrate information in a card container. `header` is optional; the
body holds any Shiny UI.

## Basic usage

``` r

el_card(header = tags$div(style = "display: flex; justify-content: space-between; align-items: center",
                            tags$span("Card name"), el_button("op", "Operating button", type = "text")),
        lapply(1:4, function(i) tags$div(style = "margin-bottom: 12px", paste("List item", i))))
```

Card name

List item 1

List item 2

List item 3

List item 4

## Simple card

``` r

el_card(lapply(1:4, function(i) tags$div(style = "margin-bottom: 12px", paste("List item", i))))
```

List item 1

List item 2

List item 3

List item 4

## With images

`body_style` styles the body.

``` r

el_row(gutter = 20, lapply(1:2, function(i) el_col(span = 8,
  el_card(body_style = "padding: 0",
    tags$img(src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png", alt = "A hamburger",
             style = "width: 100%; display: block"),
    tags$div(style = "padding: 14px", tags$span("Yummy hamburger"))))))
```

![A
hamburger](https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png)

Yummy hamburger

![A
hamburger](https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png)

Yummy hamburger

## Shadow

``` r

el_row(gutter = 12,
  el_col(span = 8, el_card(shadow = "always", "Always")),
  el_col(span = 8, el_card(shadow = "hover", "Hover")),
  el_col(span = 8, el_card(shadow = "never", "Never")))
```

Always

Hover

Never

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `header` | `header` | title of the card. Also accepts a DOM passed by `slot#header` | string | — | — |
| `body-style` | `body_style` | CSS style of body | object | — | { padding: ‘20px’ } |
| `shadow` | `shadow` | when to show card shadows | string | always / hover / never | always |
