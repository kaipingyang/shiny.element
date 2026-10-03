# Migration from Element UI

shiny.element was first built on Element UI 2 and Vue 2; that version is
tagged `v0.1.0-vue2` on GitHub. It is now built on Element Plus and Vue
3, as Element UI’s own successor is. Most code runs unchanged: the R
functions, their arguments and their inputs are the same. What follows
is what does change, and what reads the old spelling for you.

Element Plus’s own migration notes – for Vue code – are in its
[changelog](https://element-plus.org/en-US/guide/changelog.html).

## Read for you

These keep working, converted to Element Plus’s form:

| Element UI | Element Plus | Where |
|----|----|----|
| `"el-icon-search"`, `"search"` | `"Search"` | every `icon`, `prefix_icon`, `suffix_icon`, … |
| `"el-icon-user-solid"` | `"UserFilled"` | the few icons renamed upstream |
| `"yyyy-MM-dd"`, `"timestamp"` | `"YYYY-MM-DD"`, `"x"` | date and time `format`, `value_format` |
| `el_link(underline = TRUE / FALSE)` | `"hover"` / `"never"` | [`el_link()`](https://kaipingyang.github.io/shiny.element/reference/el_link.md) |
| `el_icon(lib = "element-ui")` | `lib = "element-plus"` | [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md) |
| `ELEMENT.Message(...)` in your [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md) | `ElementPlus.ElMessage(...)` | `window.ELEMENT` is kept, pointing at Element Plus’s services |
| `slot-scope="scope"` in [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md) | `v-slot:default="scope"` | `template(scope =)` writes it |

## Changed

**Sizes.** Element Plus has `"large"`, `"default"` and `"small"`.
Element UI’s `"medium"` and `"mini"` are an error, with the values to
use instead: `"medium"` becomes `"default"`, `"mini"` becomes `"small"`.

``` r

tagList(
  el_button("l", "Large", size = "large"),
  el_button("d", "Default"),
  el_button("s", "Small", size = "small")
)
```

**Text buttons.** Element UI’s `type = "text"` button is `link = TRUE`
(a coloured link-like button) or `text = TRUE` (a borderless one) in
Element Plus; `type` keeps the colour.

``` r

tagList(
  el_button("a", "Link button", link = TRUE, type = "primary"),
  el_button("b", "Text button", text = TRUE),
  el_button("c", "Text, filled", text = TRUE, bg = TRUE)
)
```

**Dependencies.** `element_ui_dependency()` is
[`element_plus_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_plus_dependency.md).
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
and
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
load it, so most apps never call either.

**Themes.** `el_theme(element =)` names Element Plus’s CSS variables,
without the `--el-` (`"border-radius-base"`, `"component-size"`), where
Element UI named its Sass variables without the `$--`. Many names are
the same; the Sass-only ones (`"input-height"`) have CSS variable
counterparts (`"component-size"`). Nothing is compiled any more, and
sass is not needed.

**The default language** is English. Element UI’s default was Simplified
Chinese; `el_page(locale = "zh-cn")` brings it back.

**Menus.** A submenu is Element Plus’s `el-sub-menu`;
[`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md)’s
items build it; raw markup uses `el$sub_menu()`.

**Upload’s file list** is `v-model:file-list` upstream;
[`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)
keeps it, and `input$<id>` is unchanged.

## Your own components

Code given to
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
– its `methods`, `watch`, `mounted` – runs in a Vue 3 component
instance. Vue 3’s own migration guide covers the differences; those you
are likely to meet:

- `this.$set(obj, key, value)` is gone: assign, `obj[key] = value`. Vue
  3 sees new properties.
- `beforeDestroy` and `destroyed` are `beforeUnmount` and `unmounted`;
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
  renames them for you.
- `$children` is gone;
  [`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md)
  and the package’s own lookups find a component by its ref.
- Filters (`{{ x | money }}`) are gone: call a method, `{{ money(x) }}`.
- `v-model` on a component binds `modelValue`, and a named one,
  `v-model:file-list`, a prop of that name.

`data` may stay a list:
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
makes it the function Vue 3 wants.

## New components

Element Plus brought components Element UI did not have, each wrapped:
[`el_input_otp()`](https://kaipingyang.github.io/shiny.element/reference/el_input_otp.md),
[`el_input_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_input_tag.md),
[`el_segmented()`](https://kaipingyang.github.io/shiny.element/reference/el_segmented.md),
[`el_select_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_select_v2.md),
[`el_mention()`](https://kaipingyang.github.io/shiny.element/reference/el_mention.md),
[`el_tree_select()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_select.md),
[`el_tree_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_tree_v2.md),
[`el_table_v2()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2.md),
[`el_color_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker_panel.md),
[`el_date_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker_panel.md),
[`el_check_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_check_tag.md),
[`el_anchor()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor.md),
[`el_tour()`](https://kaipingyang.github.io/shiny.element/reference/el_tour.md),
[`el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/el_image_viewer.md),
[`el_countdown()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md),
[`el_affix()`](https://kaipingyang.github.io/shiny.element/reference/el_affix.md),
[`el_space()`](https://kaipingyang.github.io/shiny.element/reference/el_space.md),
[`el_scrollbar()`](https://kaipingyang.github.io/shiny.element/reference/el_scrollbar.md),
[`el_watermark()`](https://kaipingyang.github.io/shiny.element/reference/el_watermark.md),
[`el_text()`](https://kaipingyang.github.io/shiny.element/reference/el_text.md),
[`el_avatar_group()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar_group.md),
[`el_splitter()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter.md)
and
[`el_config_provider()`](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md).
The components overview lists them in Element Plus’s groups.
