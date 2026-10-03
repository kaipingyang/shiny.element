# Element Plus Input Tag

A text input that turns each entry into a tag: keywords, e-mail
addresses, labels.

## Usage

``` r
el_input_tag(
  id = NULL,
  value = list(),
  max = NULL,
  tag_type = NULL,
  tag_effect = NULL,
  effect = NULL,
  trigger = NULL,
  draggable = NULL,
  delimiter = NULL,
  size = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  save_on_blur = NULL,
  clearable = NULL,
  clear_icon = NULL,
  disabled = NULL,
  validate_event = NULL,
  readonly = NULL,
  autofocus = NULL,
  tabindex = NULL,
  max_collapse_tags = NULL,
  maxlength = NULL,
  minlength = NULL,
  placeholder = NULL,
  autocomplete = NULL,
  aria_label = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  Binding value: Element Plus's `model-value`, reported as `input$<id>`.

- max:

  Max number tags that can be enter. Element Plus's `max` (number).

- tag_type:

  Tag type. Element Plus's `tag-type` (” \| 'success' \| 'info' \|
  'warning' \| 'danger').

- tag_effect:

  Tag effect. Element Plus's `tag-effect` (” \| 'light' \| 'dark' \|
  'plain').

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- trigger:

  The key to trigger input tag. Element Plus's `trigger` ('Enter' \|
  'Space').

- draggable:

  Whether tags can be dragged. Element Plus's `draggable` (boolean).

- delimiter:

  Add a tag when a delimiter is matched. Element Plus's `delimiter`
  (string / regex).

- size:

  Input box size. Element Plus's `size` ('large' \| 'default' \|
  'small').

- collapse_tags:

  Whether to collapse tags to a text when multiple selecting. Element
  Plus's `collapse-tags` (boolean).

- collapse_tags_tooltip:

  Whether show all selected tags when mouse hover text of collapse-tags.
  To use this, collapse-tags must be true. Element Plus's
  `collapse-tags-tooltip` (boolean).

- save_on_blur:

  Whether to save the input value when the input loses focus. Element
  Plus's `save-on-blur` (boolean).

- clearable:

  Whether to show clear button. Element Plus's `clearable` (boolean).

- clear_icon:

  Custom clear icon component. Element Plus's `clear-icon` (string /
  Component). An icon's name, such as `"Search"`.

- disabled:

  Whether to disable input-tag. Element Plus's `disabled` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- readonly:

  Same as `readonly` in native input. Element Plus's `readonly`
  (boolean).

- autofocus:

  Same as `autofocus` in native input. Element Plus's `autofocus`
  (boolean).

- tabindex:

  Same as `tabindex` in native input. Element Plus's `tabindex` (string
  / number).

- max_collapse_tags:

  The max tags number to be shown. To use this, collapse-tags must be
  true. Element Plus's `max-collapse-tags` (number).

- maxlength:

  Same as `maxlength` in native input. Element Plus's `maxlength`
  (string / number).

- minlength:

  Same as `minlength` in native input. Element Plus's `minlength`
  (string / number).

- placeholder:

  Placeholder of input. Element Plus's `placeholder` (string).

- autocomplete:

  Same as `autocomplete` in native input. Element Plus's `autocomplete`
  (string).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `tag`, `prefix`, `suffix`. A
  scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the value, on load and on every change.

- `input$<id>_change` – Element Plus's `change` event.

- `input$<id>_input` – Element Plus's `input` event.

- `input$<id>_add_tag` – Element Plus's `add-tag` event.

- `input$<id>_remove_tag` – Element Plus's `remove-tag` event.

- `input$<id>_drag_tag` – Element Plus's `drag-tag` event.

- `input$<id>_focus` – Element Plus's `focus` event.

- `input$<id>_blur` – Element Plus's `blur` event.

- `input$<id>_clear` – Element Plus's `clear` event.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):
`focus()`, `blur()`.

## Examples

``` r
el_input_tag("keywords", value = c("shiny", "element"), placeholder = "Add a keyword")
#> <div id="keywords" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="keywords_container" style="display: contents">
#>   <el-input-tag v-model="value" @change="handleChange" @input="elEmitInput" @add-tag="elEmitAddTag" @remove-tag="elEmitRemoveTag" @drag-tag="elEmitDragTag" @focus="elEmitFocus" @blur="elEmitBlur" @clear="elEmitClear" :max="max === null ? undefined : max" :tag-type="tagType === null ? undefined : tagType" :tag-effect="tagEffect === null ? undefined : tagEffect" :effect="effect === null ? undefined : effect" :trigger="trigger === null ? undefined : trigger" :draggable="draggable === null ? undefined : draggable" :delimiter="delimiter === null ? undefined : delimiter" :size="size === null ? undefined : size" :collapse-tags="collapseTags === null ? undefined : collapseTags" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :save-on-blur="saveOnBlur === null ? undefined : saveOnBlur" :clearable="clearable === null ? undefined : clearable" :clear-icon="clearIcon === null ? undefined : clearIcon" :disabled="disabled === null ? undefined : disabled" :validate-event="validateEvent === null ? undefined : validateEvent" :readonly="readonly === null ? undefined : readonly" :autofocus="autofocus === null ? undefined : autofocus" :tabindex="tabindex === null ? undefined : tabindex" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :maxlength="maxlength === null ? undefined : maxlength" :minlength="minlength === null ? undefined : minlength" :placeholder="placeholder === null ? undefined : placeholder" :autocomplete="autocomplete === null ? undefined : autocomplete" :aria-label="ariaLabel === null ? undefined : ariaLabel"></el-input-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":["shiny","element"],"max":null,"tagType":null,"tagEffect":null,"effect":null,"trigger":null,"draggable":null,"delimiter":null,"size":null,"collapseTags":null,"collapseTagsTooltip":null,"saveOnBlur":null,"clearable":null,"clearIcon":null,"disabled":null,"validateEvent":null,"readonly":null,"autofocus":null,"tabindex":null,"maxCollapseTags":null,"maxlength":null,"minlength":null,"placeholder":"Add a keyword","autocomplete":null,"ariaLabel":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('keywords', 'input', arguments); }","elEmitAddTag":"function() { window.shinyVue.emit('keywords', 'add_tag', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('keywords', 'remove_tag', arguments); }","elEmitDragTag":"function() { window.shinyVue.emit('keywords', 'drag_tag', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('keywords', 'focus', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('keywords', 'blur', arguments); }","elEmitClear":"function() { window.shinyVue.emit('keywords', 'clear', arguments); }","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitAddTag","options.methods.elEmitRemoveTag","options.methods.elEmitDragTag","options.methods.elEmitFocus","options.methods.elEmitBlur","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#> </div>
```
