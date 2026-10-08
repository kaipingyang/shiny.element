# Empty

Placeholder hints for empty states.

## Basic usage

``` r

el_empty(description = "description")
```

## Custom image

Use `image` prop to set image URL.

``` r

el_empty(
  image = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
)
```

## Image size

Use `image-size` prop to control image size.

``` r

el_empty(image_size = 200)
```

## Bottom content

Use the default slot to insert content at the bottom.

``` r

el_empty("empty", el_button("empty_btn", "Button", type = "primary"))
```

## Custom styles

Now you can set custom style for empty component. Use `css/scss`
language to change the global or local color. We set some global color
variables: `--el-empty-fill-color-0`, `--el-empty-fill-color-1`,
`--el-empty-fill-color-2`, ……, `--el-empty-fill-color-9`. You can use
like:
`:root { --el-empty-fill-color-0: red; --el-empty-fill-color-1: blue; }`.
But usually, if you want to change style, you need to change all color,
because these colors are a combination.

### Default Variables

| Variable               | Color                |
|------------------------|----------------------|
| –el-empty-fill-color-0 | var(–el-color-white) |
| –el-empty-fill-color-1 | \#fcfcfd             |
| –el-empty-fill-color-2 | \#f8f9fb             |
| –el-empty-fill-color-3 | \#f7f8fc             |
| –el-empty-fill-color-4 | \#eeeff3             |
| –el-empty-fill-color-5 | \#edeef2             |
| –el-empty-fill-color-6 | \#e9ebef             |
| –el-empty-fill-color-7 | \#e5e7e9             |
| –el-empty-fill-color-8 | \#e0e3e9             |
| –el-empty-fill-color-9 | \#d5d7de             |

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element       | In R          | Description                 | Type | Accepted | Default |
|---------------|---------------|-----------------------------|------|----------|---------|
| `image`       | `image`       | image URL of empty          | [^1] |          | ’’      |
| `image-size`  | `image_size`  | image size (width) of empty | [^2] |          | —       |
| `description` | `description` | description of empty        | [^3] |          | ’’      |

### Slots

| Element       | In R                           | Description               |
|---------------|--------------------------------|---------------------------|
| `default`     | default content                | content as bottom content |
| `image`       | `slots = list(image = )`       | content as image          |
| `description` | `slots = list(description = )` | content as description    |

[^1]: string

[^2]: number

[^3]: string
