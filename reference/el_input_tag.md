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
  slots = NULL,
  events = NULL,
  on = NULL
)

update_el_input_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
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
  validate_event = NULL,
  readonly = NULL,
  autofocus = NULL,
  tabindex = NULL,
  max_collapse_tags = NULL,
  maxlength = NULL,
  minlength = NULL,
  placeholder = NULL,
  autocomplete = NULL,
  aria_label = NULL
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

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the tags |
| `input$<id>_input` | `events = "input"` | triggers when the input value change |
| `input$<id>_add_tag` | `events = "add_tag"` | triggers when a tag is added |
| `input$<id>_remove_tag` | `events = "remove_tag"` | triggers when a tag is removed |
| `input$<id>_drag_tag` | `events = "drag_tag"` | triggers when a tag is dragged |
| `input$<id>_focus` | `events = "focus"` | triggers when InputTag focuses |
| `input$<id>_blur` | `events = "blur"` | triggers when InputTag blurs |
| `input$<id>_clear` | `events = "clear"` | triggers when the clear icon is clicked |

The same list as `el_events("el_input_tag")`, which says how an event's
arguments travel.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`focus()`, `blur()`.

## Updating from the server

Server-side update for `el_input_tag()`.

Every other argument of `el_input_tag()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_input_tag()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_input_tag(
  "keywords",
  value = c("shiny", "element"),
  placeholder = "Add a keyword"
)
#> <div id="keywords" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="keywords_container" style="display: contents">
#>   <el-input-tag v-model="value" @change="handleChange" :max="max === null ? undefined : max" :tag-type="tagType === null ? undefined : tagType" :tag-effect="tagEffect === null ? undefined : tagEffect" :effect="effect === null ? undefined : effect" :trigger="trigger === null ? undefined : trigger" :draggable="draggable === null ? undefined : draggable" :delimiter="delimiter === null ? undefined : delimiter" :size="size === null ? undefined : size" :collapse-tags="collapseTags === null ? undefined : collapseTags" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :save-on-blur="saveOnBlur === null ? undefined : saveOnBlur" :clearable="clearable === null ? undefined : clearable" :clear-icon="clearIcon === null ? undefined : clearIcon" :disabled="disabled === null ? undefined : disabled" :validate-event="validateEvent === null ? undefined : validateEvent" :readonly="readonly === null ? undefined : readonly" :autofocus="autofocus === null ? undefined : autofocus" :tabindex="tabindex === null ? undefined : tabindex" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :maxlength="maxlength === null ? undefined : maxlength" :minlength="minlength === null ? undefined : minlength" :placeholder="placeholder === null ? undefined : placeholder" :autocomplete="autocomplete === null ? undefined : autocomplete" :aria-label="ariaLabel === null ? undefined : ariaLabel"></el-input-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":["shiny","element"],"max":null,"tagType":null,"tagEffect":null,"effect":null,"trigger":null,"draggable":null,"delimiter":null,"size":null,"collapseTags":null,"collapseTagsTooltip":null,"saveOnBlur":null,"clearable":null,"clearIcon":null,"disabled":null,"validateEvent":null,"readonly":null,"autofocus":null,"tabindex":null,"maxCollapseTags":null,"maxlength":null,"minlength":null,"placeholder":"Add a keyword","autocomplete":null,"ariaLabel":null},"methods":{"handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_input_tag(session, "x", value = NULL))
}
```
