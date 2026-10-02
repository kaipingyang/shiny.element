# Backtop

A button to go back to the top. `target` names the scrolling element;
the page’s by default.

## Basic usage

``` r

tags$div(id = "report", style = "height: 200px; overflow: auto",
         lapply(1:40, function(i) tags$p(paste("Line", i))))
el_backtop("top", target = "#report", visibility_height = 100, right = 40, bottom = 40)
```

Line 1

Line 2

Line 3

Line 4

Line 5

Line 6

Line 7

Line 8

Line 9

Line 10

Line 11

Line 12

Line 13

Line 14

Line 15

Line 16

Line 17

Line 18

Line 19

Line 20

Line 21

Line 22

Line 23

Line 24

Line 25

Line 26

Line 27

Line 28

Line 29

Line 30

Line 31

Line 32

Line 33

Line 34

Line 35

Line 36

Line 37

Line 38

Line 39

Line 40

## Customizations

`content` replaces the arrow.

``` r

tags$div(id = "long", style = "height: 200px; overflow: auto",
         lapply(1:40, function(i) tags$p(paste("Line", i))))
el_backtop("up", target = "#long", visibility_height = 100, bottom = 100,
           content = tags$div(style = "height: 100%; width: 100%; background: #f2f5f6; box-shadow: 0 0 6px rgba(0,0,0,.12); text-align: center; line-height: 40px; color: #1989fa", "UP"))
```

Line 1

Line 2

Line 3

Line 4

Line 5

Line 6

Line 7

Line 8

Line 9

Line 10

Line 11

Line 12

Line 13

Line 14

Line 15

Line 16

Line 17

Line 18

Line 19

Line 20

Line 21

Line 22

Line 23

Line 24

Line 25

Line 26

Line 27

Line 28

Line 29

Line 30

Line 31

Line 32

Line 33

Line 34

Line 35

Line 36

Line 37

Line 38

Line 39

Line 40

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `target` | `target` | the target to trigger scroll | string |  |  |
| `visibility-height` | `visibility_height` | the button will not show until the scroll height reaches this value | number |  | 200 |
| `right` | `right` | right distance | number |  | 40 |
| `bottom` | `bottom` | bottom distance | number |  | 40 |

### Events

| Element | In R               | Description         |
|---------|--------------------|---------------------|
| `click` | `input$<id>_click` | triggers when click |
