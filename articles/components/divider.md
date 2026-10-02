# Divider

The dividing line that separates the content.

## Basic usage

``` r

tags$span("I sit at a desk and set up a box.")
el_divider()
tags$span("Sheet music, the sound of the night.")
```

I sit at a desk and set up a box.

Sheet music, the sound of the night.

## Custom content

``` r

tags$span("What you are you do not see, what you see is your shadow.")
el_divider(content = "Rabindranath Tagore", content_position = "left")
tags$span("I cannot choose the best. The best chooses me.")
el_divider(content = el_icon("mobile-phone"))
tags$span("My wishes are fools, they shout across thy song, my Master.")
el_divider(content = "Rabindranath Tagore", content_position = "right")
```

What you are you do not see, what you see is your shadow.

Rabindranath Tagore

I cannot choose the best. The best chooses me.

My wishes are fools, they shout across thy song, my Master.

Rabindranath Tagore

## Vertical divider

``` r

tags$span("Rain", el_divider(direction = "vertical"), "Home", el_divider(direction = "vertical"), "Grass")
```

Rain

Home

Grass

## API

### Divider Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `direction` | `direction` | Set divider’s direction | string | horizontal / vertical | horizontal |
| `content-position` | `content_position` | customize the content on the divider line | String | left / right / center | center |
