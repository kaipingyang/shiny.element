# Element Plus Tag

Creates a styled tag/chip component. Tracks click and close events as
Shiny inputs.

## Usage

``` r
el_tag(
  id = NULL,
  label = "Tag",
  type = NULL,
  closable = FALSE,
  size = NULL,
  effect = "light",
  color = NULL,
  hit = FALSE,
  disable_transitions = FALSE,
  round = NULL,
  width = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
)

update_el_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  type = NULL,
  closable = NULL,
  size = NULL,
  effect = NULL,
  color = NULL,
  hit = NULL,
  disable_transitions = NULL,
  round = NULL
)
```

## Arguments

- id:

  Tag ID. Auto-generated UUID if `NULL`.

- label:

  Tag text.

- type:

  Tag colour: `NULL` (default blue), `"success"`, `"info"`, `"warning"`,
  `"danger"`.

- closable:

  Whether to show a close button. Default `FALSE`. When `TRUE`,
  `input$<id>_close` fires once when the user closes the tag.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- effect:

  Visual effect: `"light"` (default), `"dark"`, `"plain"`.

- color:

  Custom background colour (CSS string). `NULL` for themed colour.

- hit:

  Whether to show a solid border. Default `FALSE`.

- disable_transitions:

  Disable the zoom-in-center animation. Default `FALSE`.

- round:

  Whether Tag is rounded. Element Plus's `round` (boolean).

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_tag()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_tag()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed tag component.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the number of clicks on the tag, as [`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html) reports it |
| `input$<id>_close` | unasked | fires when the user closes it (`closable = TRUE`) |

The same list as `el_events("el_tag")`, which says how an event's
arguments travel.

The clicks are counted as
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
counts them, 0 on load.

## Updating from the server

Server-side update for `el_tag()`.

Every other argument of `el_tag()` that can change once it is drawn is
an argument here too, under the same name. One left `NULL` stays as it
is; `NA` returns it to Element's default.

`update_el_tag()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_tag("tag1", "Success", type = "success")
#> <div id="tag1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tag1_container" style="display: contents">
#>   <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose" :size="size === null ? undefined : size" :color="color === null ? undefined : color" :round="round === null ? undefined : round">{{label}}</el-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Success","type":"success","closable":false,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0,"round":null},"methods":{"handleClick":"function() { this.count++; }","handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tag1_close', 1, {priority: 'event'}); }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick","options.methods.handleClose"]}</script>
#> </div>
el_tag("tag2", "Closable", closable = TRUE)
#> <div id="tag2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tag2_container" style="display: contents">
#>   <el-tag :type="type" :closable="closable" :effect="effect" :hit="hit" :disable-transitions="disableTransitions" @click="handleClick" @close="handleClose" :size="size === null ? undefined : size" :color="color === null ? undefined : color" :round="round === null ? undefined : round">{{label}}</el-tag>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Closable","type":null,"closable":true,"size":null,"effect":"light","color":null,"hit":false,"disableTransitions":false,"count":0,"round":null},"methods":{"handleClick":"function() { this.count++; }","handleClose":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tag2_close', 1, {priority: 'event'}); }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick","options.methods.handleClose"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tag(session, "status", label = "done", type = "success")
  })
}
```
