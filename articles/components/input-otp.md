# InputOtp

Used to enter a one-time password (OTP).

## Basic Usage

``` r

el_input_otp("otp")
```

## Custom Length

The length of the input fields can be customized by setting the `length`
prop.

``` r

el_input_otp("otp_len", length = 4)
```

## Types

There are three types available: `outlined` (default), `filled`, and
`underlined`.

``` r

tags$div(style = "display: grid; gap: 16px",
  el_input_otp("otp_o", type = "outlined"), el_input_otp("otp_f", type = "filled"),
  el_input_otp("otp_u", type = "underlined"))
```

## Sizes

There are three sizes available: `large`, `default`, and `small`.

``` r

tags$div(style = "display: grid; gap: 16px",
  el_input_otp("otp_l", size = "large"), el_input_otp("otp_d"), el_input_otp("otp_s", size = "small"))
```

## Disabled & Readonly

Disabled and readonly states are supported.

``` r

el_input_otp("otp_dis", value = "123456", disabled = TRUE)
```

## Mask

Use the `mask` prop to hide the input characters.

``` r

el_input_otp("otp_mask", mask = TRUE)
```

## Separator

Customize the separator between OTP fields.

``` r

el_input_otp("otp_sep", separator = "-")
```

## Custom Validation

Set the `validator` prop to validate the input character, and use
`inputmode` to specify the keyboard type.

`validator`, a
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
function, decides which characters each field takes.

``` r

el_input_otp("otp_val", validator = JS("function(char) { return /^[0-9]$/.test(char); }"))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | The value of the OTP fields. Since numbers must not have leading zeros, `modelValue` is allowed to be a number only during initialization. | [^1] / [^2] |  | undefined |
| `length` | `length` | The OTP fields length | [^3] |  | 6 |
| `validator` | `validator` | Custom validator function | [^4]`(char: string, index: number) => boolean` |  | () =\> true |
| `inputmode` | `inputmode` | Native `inputmode` attribute | [^5] |  | — |
| `type` | `type` | The type of the OTP fields | [^6]`'outlined' \\| 'filled' \\| 'underlined'` |  | ‘outlined’ |
| `size` | `size` | The size of the OTP fields | [^7]`'large' \\| 'default' \\| 'small'` |  | — |
| `mask` | `mask` | Whether to enable password mode | [^8] |  | — |
| `disabled` | `disabled` | Whether the OTP fields are disabled | [^9] |  | undefined |
| `separator` | `separator` | The separator between OTP fields | [^10] / [^11] / [^12]`() => string \\| VNode` |  | — |
| `validate-event` | `validate_event` | Whether to trigger form validation | [^13] |  | true |
| `readonly` | `readonly` | Same as `readonly` in native input | [^14] |  | false |
| `id` | `id`, the Shiny input’s | Native `id` attribute | [^15] |  | — |
| `aria-label` | `aria_label` | Native `aria-label` attribute | [^16] |  | — |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>_change` | Triggers when the value changes after input blur |
| `finish` | `input$<id>_finish` | Fires when all fields have been filled |
| `focus` | `input$<id>_focus` | Triggers when input is focused |
| `blur` | `input$<id>_blur` | Triggers when input is blurred |

### Slots

| Element     | In R                         | Description                      |
|-------------|------------------------------|----------------------------------|
| `separator` | `slots = list(separator = )` | The separator between OTP fields |

### Exposes

| Element | In R                            | Description                      |
|---------|---------------------------------|----------------------------------|
| `focus` | `el_call(session, id, "focus")` | Focus an OTP input field         |
| `blur`  | `el_call(session, id, "blur")`  | Blur the focused OTP input field |

[^1]: string

[^2]: number

[^3]: number

[^4]: Function

[^5]: string

[^6]: enum

[^7]: enum

[^8]: boolean

[^9]: boolean

[^10]: string

[^11]: VNode

[^12]: Function

[^13]: boolean

[^14]: boolean

[^15]: string

[^16]: string
