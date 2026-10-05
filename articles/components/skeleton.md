# Skeleton

When loading data, and you need a rich experience for visual and
interactions for your end users, you can choose `skeleton`.

## Basic usage

The basic skeleton.

``` r

el_skeleton()
```

## Configurable Rows

You can configure the row numbers yourself, for more precise rendering
effect, the actual rendered row number will always be 1 row more than
the given number, that is because we are rendering a title row with 33%
width of the others.

``` r

el_skeleton(rows = 5)
```

## Animation

We have provided a switch flag indicating whether showing the loading
animation, called `animated` when this is true, all children of
`el-skeleton` will show animation

``` r

el_skeleton(rows = 5, animated = TRUE)
```

## Customized Template

Element Plus only provides the most common template, sometimes that
could be a problem, so you have a slot named `template` to do that work.

Also we have provided different types skeleton unit that you can choose,
for more detailed info, please scroll down to the bottom of this page to
see the API description. Also, when building your own customized
skeleton structure, you should be structuring them as closer to the real
DOM as possible, which avoiding the DOM bouncing caused by the height
difference.

``` r

el_skeleton(
  width = "240px",
  slots = list(
    template = tagList(
      el$skeleton_item(
        variant = "image",
        style = "width: 240px; height: 240px"
      ),
      tags$div(
        style = "padding: 14px",
        el$skeleton_item(variant = "p", style = "width: 50%"),
        tags$div(
          style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
          el$skeleton_item(variant = "text", style = "margin-right: 16px"),
          el$skeleton_item(variant = "text", style = "width: 30%")
        )
      )
    )
  )
)
```

## Loading state

When `Loading` ends, we always need to show the real UI with data to our
end users. with the attribute `loading` we can control whether showing
the DOM. You can also use slot `default` to structure the real DOM
element.

`update_el_skeleton(loading = FALSE)` swaps it for its content.

``` r

el_skeleton(
  "sk_load",
  loading = TRUE,
  animated = TRUE,
  el_card(tags$img(
    src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png",
    alt = "A hamburger",
    style = "width: 100%"
  ))
)
```

## Rendering a list of data

Most of the time, skeleton is used as indicators of rendering a list of
data which haven’t been fetched from server yet, then we need to create
a list of skeleton out of no where to make it look like it is loading,
with `count` attribute, you can control how many these templates you
need to render to the browser.

> **Tip**
>
> We do not recommend rendering lots of fake UI to the browser, it will
> still cause the performance issue, it also costs longer to destroy the
> skeleton. Keep `count` as small as it can be to make better user
> experience.

``` r

el_skeleton(count = 3, rows = 2, animated = TRUE)
```

## Avoiding rendering bouncing.

Sometimes API responds very quickly, when that happens, the skeleton
just gets rendered to the DOM then it needs to switch back to real DOM,
that causes the sudden flashy. To avoid such thing, you can use the
`throttle` attribute.

> **Tip**
>
> Since 2.8.8, the `throttle` attribute supports two values: `number`
> and `object`. When passing a `number`, it is equivalent to
> `{leading: xxx}`, controlling the throttling of the skeleton screen
> display. Of course, you can also control the throttling of the
> skeleton screen disappearance by passing `{trailing: xxx}`

``` r

el_skeleton(
  "sk_throttle",
  loading = TRUE,
  throttle = 500,
  animated = TRUE,
  "Content"
)
```

## Initial rendering loading

When the initial value of loading is true, you can set
`throttle: {initVal: true, leading: xxx}` to control the immediate
display of the initial skeleton screen without throttling.

``` r

el_skeleton(
  "sk_initial",
  loading = TRUE,
  throttle = list(leading = 500, initVal = TRUE),
  "Content"
)
```

## Toggle show/hide without rending bouncing

> **Tip**
>
> You can set `throttle: {initVal: true, leading: xxx, trailing: xxx}`
> to control the initial display of the skeleton effect and to make the
> transition of the skeleton more smooth when switching loading states.

Sometimes you want to render the business components more smoothly when
loading toggle show or hide. You can use set the
`throttle: {leading: xxx, trailing:xxx}` to control the rendering
bouncing.

``` r

el_skeleton(
  "sk_lt",
  loading = TRUE,
  throttle = list(leading = 500, trailing = 500),
  "Content"
)
```

## 

## API

Element Plus’s tables, and beside each entry where it is in R.

### Skeleton Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `animated` | `animated` | whether showing the animation | [^1] |  | false |
| `count` | `count` | how many fake items to render to the DOM | [^2] |  | 1 |
| `loading` | `loading` | whether showing the real DOM | [^3] |  | false |
| `rows` | `rows` | numbers of the row, only useful when no template slot were given | [^4] |  | 3 |
| `throttle` | `throttle` | rendering delay in milliseconds. Numbers represent delayed display, and can also be set to delay hide, for example `{ leading: 500, trailing: 500 }`. When needing to control the initial value of loading, you can set `{ initVal: true }` | [^5] / [^6]`{ leading?: number, trailing?: number, initVal?: boolean }` |  | 0 |

### Skeleton Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | real rendering DOM |
| `template` | `slots = list(template = )` | content as rendering skeleton template |

### SkeletonItem Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `variant` | `el_skeleton_item(variant =)` | the current rendering skeleton type | [^7]`'p' \\| 'text' \\| 'h1' \\| 'h3' \\| 'caption' \\| 'button' \\| 'image' \\| 'circle' \\| 'rect'` |  | text |

[^1]: boolean

[^2]: number

[^3]: boolean

[^4]: number

[^5]: number

[^6]: object

[^7]: enum
