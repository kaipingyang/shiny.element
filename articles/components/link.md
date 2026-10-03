# Link

Text hyperlink

> **Warning**
>
> The `href` prop will be rendered directly to an `<a>` tag. If you pass
> a value such as `javascript:alert(1)` or a malicious URL, it may cause
> **XSS** or **open redirect vulnerabilities**.
>
> Always validate and sanitize the URL before use. For example:
>
> Show code example

## Basic

Basic text link

``` r

tags$div(style = "display: flex; gap: 16px",
  el_link("default", href = "https://element-plus.org", target = "_blank"),
  lapply(c("primary", "success", "warning", "danger", "info"), function(t) el_link(t, type = t)))
```

[default](https://element-plus.org) primary success warning danger info

## Disabled

Disabled state of link

``` r

tags$div(style = "display: flex; gap: 16px",
  lapply(c("default", "primary", "success", "warning", "danger", "info"), function(t)
    el_link(t, type = t, disabled = TRUE)))
```

default primary success warning danger info

## Underline

Controlling when underlines should appear

> **Warning**
>
> The `boolean` value has been **deprecated**, and **will be** removed
> in 3.0.0 , consider switching to new values.

> **Tip**
>
> Starting from 2.9.9 , you can use `'always' | 'hover' | 'never'` to
> control when underlines should appear. The examples in the document
> all use these values. If you are using a version **less than** 2.9.9 ,
> please refer to:

``` r

tags$div(style = "display: flex; gap: 16px",
  el_link("default"), el_link("always", underline = "always"),
  el_link("hover", underline = "hover"), el_link("never", underline = "never"))
```

default always hover never

## Icon

Link with icon

> **Tip**
>
> Use the `icon` attribute to add icon. You can pass either string for
> the component name (registered in advance) or the component itself
> which is a SVG Vue component. Element Plus has provided a set of icon
> that you can find at
> [icon](https://kaipingyang.github.io/shiny.element/articles/components/icon.md)

``` r

tags$div(style = "display: flex; gap: 16px",
  el_link("Edit", icon = "Edit"),
  el_link(tagList("Check", el_icon("View", class = "el-icon--right"))))
```

Edit Check

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `type` | `type` | type | [^1]`'primary' \\| 'success' \\| 'warning' \\| 'danger' \\| 'info' \\| 'default'` |  | default |
| `underline` | `underline` | when underlines should appear | [^2]`'always' \\| 'hover' \\| 'never' \\| boolean` |  | hover |
| `disabled` | `disabled` | whether the component is disabled | [^3] |  | false |
| `href` | `href` | same as native hyperlink’s `href` | [^4] |  | — |
| `target` | `target` | same as native hyperlink’s `target` | [^5]`'_blank' \\| '_parent' \\| '_self' \\| '_top'` |  | \_self |
| `icon` | `icon` | icon component | [^6] / [^7] |  | — |

### Slots

| Element   | In R                    | Description               |
|-----------|-------------------------|---------------------------|
| `default` | default content         | customize default content |
| `icon`    | `slots = list(icon = )` | customize icon component  |

[^1]: enum

[^2]: enum

[^3]: boolean

[^4]: string

[^5]: enum

[^6]: string

[^7]: Component
