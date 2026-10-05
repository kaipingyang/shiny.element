# Element Plus Mention

A text input that offers options after a trigger character, as @mentions
do.

## Usage

``` r
el_mention(
  id = NULL,
  value = NULL,
  options = NULL,
  props = NULL,
  prefix = NULL,
  split = NULL,
  filter_option = NULL,
  placement = NULL,
  show_arrow = NULL,
  offset = NULL,
  whole = NULL,
  check_is_whole = NULL,
  loading = NULL,
  popper_class = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placeholder = NULL,
  disabled = NULL,
  type = NULL,
  rows = NULL,
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

update_el_mention(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  props = NULL,
  prefix = NULL,
  split = NULL,
  filter_option = NULL,
  placement = NULL,
  show_arrow = NULL,
  offset = NULL,
  whole = NULL,
  check_is_whole = NULL,
  loading = NULL,
  popper_class = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placeholder = NULL,
  type = NULL,
  rows = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  Input value: Element Plus's `model-value`, reported as `input$<id>`.

- options:

  The options: a named vector `c(Label = value)`, a vector, or a list of
  `list(value =, label =, disabled =)`, as Element Plus takes them.

- props:

  Configuration options. Element Plus's `props` (MentionOptionProps).

- prefix:

  Prefix character to trigger mentions. The string length must be
  exactly 1. Element Plus's `prefix` (`string / string[]`).

- split:

  Character to split mentions. The string length must be exactly

  1.  Element Plus's `split` (string).

- filter_option:

  Customize filter option logic. Element Plus's `filter-option` (false /
  (pattern: string, option: MentionOption) =\> boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- placement:

  Set popup placement. Element Plus's `placement` ('bottom' \| 'top').

- show_arrow:

  Whether the dropdown panel has an arrow. Element Plus's `show-arrow`
  (boolean).

- offset:

  Offset of the dropdown panel. Element Plus's `offset` (number).

- whole:

  When backspace is pressed to delete, whether the mention content is
  deleted as a whole. Element Plus's `whole` (boolean).

- check_is_whole:

  When backspace is pressed to delete, check if the mention is a whole.
  Element Plus's `check-is-whole` ((pattern: string, prefix: string) =\>
  boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- loading:

  Whether the dropdown panel of mentions is in a loading state. Element
  Plus's `loading` (boolean).

- popper_class:

  Custom class name for dropdown panel. Element Plus's `popper-class`
  (string / object).

- popper_style:

  Custom style for dropdown panel. Element Plus's `popper-style` (string
  / object).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- placeholder, disabled, type, rows:

  As for
  [`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md):
  the placeholder text, whether it can be changed, and
  `type = "textarea"` with its number of rows for a longer message.

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

  Named list of Element slot contents: `label`, `loading`, `header`,
  `footer`. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the value, on load and on every change.

- `input$<id>_search` – Element Plus's `search` event.

- `input$<id>_select` – Element Plus's `select` event.

- `input$<id>_whole_remove` – Element Plus's `whole-remove` event.

## Updating from the server

Server-side update for `el_mention()`.

Every other argument of `el_mention()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_mention()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_mention("msg", options = c("Ada", "Grace", "Linus"), placeholder = "Type @")
#> <div id="msg" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="msg_container" style="display: contents">
#>   <el-mention v-model="value" @search="elEmitSearch" @select="elEmitSelect" @whole-remove="elEmitWholeRemove" :options="options === null ? undefined : options" :props="props === null ? undefined : props" :prefix="prefix === null ? undefined : prefix" :split="split === null ? undefined : split" :filter-option="filterOption === null ? undefined : filterOption" :placement="placement === null ? undefined : placement" :show-arrow="showArrow === null ? undefined : showArrow" :offset="offset === null ? undefined : offset" :whole="whole === null ? undefined : whole" :check-is-whole="checkIsWhole === null ? undefined : checkIsWhole" :loading="loading === null ? undefined : loading" :popper-class="popperClass === null ? undefined : popperClass" :popper-style="popperStyle === null ? undefined : popperStyle" :popper-options="popperOptions === null ? undefined : popperOptions" :placeholder="placeholder === null ? undefined : placeholder" :disabled="disabled === null ? undefined : disabled" :type="type === null ? undefined : type" :rows="rows === null ? undefined : rows"></el-mention>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":null,"options":[{"value":"Ada","label":"Ada"},{"value":"Grace","label":"Grace"},{"value":"Linus","label":"Linus"}],"props":null,"prefix":null,"split":null,"filterOption":null,"placement":null,"showArrow":null,"offset":null,"whole":null,"checkIsWhole":null,"loading":null,"popperClass":null,"popperStyle":null,"popperOptions":null,"placeholder":"Type @","disabled":null,"type":null,"rows":null},"methods":{"elEmitSearch":"function() { window.shinyVue.emit('msg', 'search', arguments); }","elEmitSelect":"function() { window.shinyVue.emit('msg', 'select', arguments); }","elEmitWholeRemove":"function() { window.shinyVue.emit('msg', 'whole_remove', arguments); }"},"watch":{"value":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitSearch","options.methods.elEmitSelect","options.methods.elEmitWholeRemove","options.watch.value"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_mention(session, "x", value = NULL))
}
```
