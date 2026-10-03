# Config Provider

Config Provider is used for providing global configurations, which
enables your entire application to access these configurations
everywhere.

## i18n Configurations

Configure i18n related properties via Config Provider, to get language
switching feature.

Use two attributes to provide i18n related config

The page’s language and z-index are `el_page(locale =, z_index =)`,
given to every component; a config provider sets the rest for what is
inside it – here the size of a table’s pagination and input.

``` r

el_config_provider(size = "small",
  el_input("cfg_inp", placeholder = "Small, from the provider"),
  el_pagination("cfg_pg", total = 100))
```

## Button Configurations

``` r

el_config_provider(button = list(autoInsertSpace = TRUE, plain = TRUE, round = TRUE, type = "primary"),
  el_button("cfg_b1", "中文"), el_button("cfg_b2", "Button"))
```

## Link Configurations

``` r

el_config_provider(link = list(type = "success", underline = "always"),
  el_link("Link", id = "cfg_link"))
```

## Card Configurations

``` r

el_config_provider(card = list(shadow = "hover"), el_card("Card desu!"))
```

## Dialog Configurations

``` r

el_config_provider(dialog = list(alignCenter = TRUE, draggable = TRUE),
  el_button("cfg_open", "Open dialog"),
  el_dialog("cfg_dlg", title = "Tips", content = "This is a message"))
```

## Message Configurations

> **In R**
>
> A message sent with
> [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md)
> is not inside any component, so a config provider’s `message` settings
> do not reach it; give
> [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md)
> its `plain`, `placement` and `grouping` instead.

## Empty Values Configurations

Supported components list

- Cascader
- ColorPicker 2.10.3
- DatePicker
- Select
- SelectV2
- TimePicker
- TimeSelect
- TreeSelect

Set `empty-values` to support empty values of components. The fallback
value is `['', null, undefined]`. If you think the empty string is
meaningful, write `[undefined, null]`.

Set `value-on-clear` to set the return value when cleared. The fallback
value is `undefined`. In the date component is `null`. If you want to
set `undefined`, use `() => undefined`.

``` r

el_config_provider(value_on_clear = NULL, empty_values = list(NULL),
  el_select("cfg_sel", choices = c("Option1", "Option2", "Option3"), clearable = TRUE,
            placeholder = "Select", width = "240px"))
```

## Table Configurations

``` r

el_config_provider(table = list(showOverflowTooltip = TRUE, tooltipEffect = "light"),
  el_table("cfg_t2", data = data.frame(date = "2016-05-03", name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a very long address that overflows")))
```

## Experimental features

In this section, you can learn how to use Config Provider to provide
experimental features. For now, we haven’t added any experimental
features, but in the feature roadmap, we will add some experimental
features. You can use this config to manage the features you want or
not.

## API

Element Plus’s tables, and beside each entry where it is in R.

### Config Provider Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `locale` | `el_page(locale =)` | Locale Object | [^1]`{name: string, el: TranslatePair}`[](https://github.com/element-plus/element-plus/blob/a98ff9b40c0c3d2b9959f99919bd8363e3e3c25a/packages/locale/index.ts#L5) [languages](https://github.com/element-plus/element-plus/tree/dev/packages/locale/lang) |  | [en](https://github.com/element-plus/element-plus/blob/dev/packages/locale/lang/en.ts) |
| `size` | `size` | global component size | [^2]`'large' \\| 'default' \\| 'small'` |  | default |
| `zIndex` | `el_page(z_index =)` | global Initial zIndex | [^3] |  | — |
| `namespace` | `(fixed:`el`)` | global component className prefix (cooperated with [\$namespace](https://github.com/element-plus/element-plus/blob/dev/packages/theme-chalk/src/mixins/config.scss#L1)) | [^4] |  | el |
| `button` | `button` | button related configuration, [see the following table](#button-attribute) | [^5]`{autoInsertSpace?: boolean, type?: string, plain?: boolean, text?: boolean, round?: boolean, dashed?: boolean}` |  | see the following table |
| `link` | `link` | link related configuration, [see the following table](#link-attribute) | [^6]`{type?: string, underline?: boolean \\| string}` |  | see the following table |
| `dialog` | `dialog` | dialog related configuration, [see the following table](#dialog-attribute) | [^7]`{alignCenter?: boolean, draggable?: boolean, overflow?: boolean, transition?: DialogTransition}` |  | see the following table |
| `message` | `message` | message related configuration, [see the following table](#message-attribute) | [^8]`{max?: number}` |  | see the following table |
| `experimental-features` | `experimental_features` | features at experimental stage to be added, all features are default to be set to false | [^9] |  | — |
| `empty-values` | `empty_values` | global empty values of components | [^10] |  | — |
| `value-on-clear` | `value_on_clear` | global clear return value | [^11] / [^12] / [^13] / [^14] |  | — |
| `table` | `table` | table related configuration, [see the following table](#table-attribute) | [^15]`{showOverflowTooltip?: boolean \\| object, tooltipEffect?: string, tooltipOptions?: object, tooltipFormatter?: Function}` |  | see the following table |

### Config Provider Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: object

[^2]: enum

[^3]: number

[^4]: string

[^5]: object

[^6]: object

[^7]: object

[^8]: object

[^9]: object

[^10]: array

[^11]: string

[^12]: number

[^13]: boolean

[^14]: Function

[^15]: object
