# Empty

Placeholder hints for empty states.

## Basic usage

``` r

el_empty("e1", description = "No data")
```

## Custom image

``` r

el_empty("e2", image = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png")
```

## Image size

``` r

el_empty("e3", image_size = 200)
```

## Bottom content

Content given in `...` goes under the description.

``` r

el_empty("e4", el_button("go", "Button", type = "primary"))
```

## API

### Empty Attributes

| Element       | In R          | Description        | Type   | Accepted | Default |
|---------------|---------------|--------------------|--------|----------|---------|
| `image`       | `image`       | image URL          | string | —        | —       |
| `image-size`  | `image_size`  | image size (width) | number | —        | —       |
| `description` | `description` | description        | string | —        | —       |

### Empty Slots

| Element       | In R                           | Description           |
|---------------|--------------------------------|-----------------------|
| `default`     | default content                | Custom bottom content |
| `image`       | `slots = list(image = )`       | Custom image          |
| `description` | `slots = list(description = )` | Custom description    |
