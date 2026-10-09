# Element Plus Button with Vue Instance

Creates an Element Plus button with Vue instance, supporting all Element
Plus button variants including `plain`, `round`, `circle`, and `loading`
states.

## Usage

``` r
el_button(
  id = NULL,
  label = "Button",
  type = NULL,
  size = NULL,
  plain = NULL,
  round = NULL,
  circle = FALSE,
  loading = FALSE,
  task = FALSE,
  disabled = FALSE,
  icon = NULL,
  native_type = "button",
  autofocus = FALSE,
  auto_insert_space = NULL,
  bg = NULL,
  color = NULL,
  dark = NULL,
  dashed = NULL,
  link = NULL,
  loading_icon = NULL,
  tag = NULL,
  text = NULL,
  class = NULL,
  style = NULL,
  width = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
)

update_el_button(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  type = NULL,
  size = NULL,
  plain = NULL,
  round = NULL,
  loading = NULL,
  disabled = NULL,
  circle = NULL,
  icon = NULL,
  autofocus = NULL,
  auto_insert_space = NULL,
  bg = NULL,
  color = NULL,
  dark = NULL,
  dashed = NULL,
  link = NULL,
  loading_icon = NULL,
  tag = NULL,
  text = NULL
)
```

## Arguments

- id:

  Button ID. Auto-generated UUID if `NULL`.

- label:

  Button text, or tags –
  `tagList("Next", el_icon("ArrowRight", class = "el-icon--right"))` –
  drawn as they are. Ignored (and defaults to `""`) when
  `circle = TRUE`.

- type:

  Button type: `"default"`, `"primary"`, `"success"`, `"warning"`,
  `"danger"`, `"info"`, `"text"`. `NULL` leaves it to a config
  provider's `button` settings, or Element's default.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- plain:

  Whether to use the plain (hollow) style.

- round:

  Whether to use rounded corners. `plain` and `round` left `NULL` are
  off, or a config provider's [el_config_provider(button
  =)](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md).

- circle:

  Whether to render as a circle button (icon only, no label). Default
  `FALSE`.

- loading:

  Whether to show loading spinner. Disables click while active.

- task:

  A task button, as
  [`bslib::input_task_button()`](https://rstudio.github.io/bslib/reference/input_task_button.html):
  clicked, it shows Element's loading state at once, in the browser,
  until the server has handled the click – the observers it runs are
  done – or, bound to an
  [shiny::ExtendedTask](https://rdrr.io/pkg/shiny/man/ExtendedTask.html)
  with
  [`bslib::bind_task_button()`](https://rstudio.github.io/bslib/reference/bind_task_button.html),
  until the task is. `input$<id>` counts the clicks, as for any button.
  Default `FALSE`.

- disabled:

  Whether the button is disabled. Default `FALSE`.

- icon:

  Either an Element icon class name such as `"el-icon-search"`, which
  Element renders itself and `update_el_button()` can change, or a tag
  (for example from
  [`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)),
  which is inserted as button content.

- native_type:

  HTML native button type: `"button"` (default), `"submit"`, `"reset"`.

- autofocus:

  Whether the button takes focus on page load. Default `FALSE`.

- auto_insert_space:

  Automatically insert a space between two chinese characters(this will
  only take effect when the text length is 2 and all characters are in
  Chinese.). Element Plus's `auto-insert-space` (boolean).

- bg:

  Determine whether the text button background color is always on.
  Element Plus's `bg` (boolean).

- color:

  Custom button color, automatically calculate `hover` and `active`
  color. Works with `link`/`text` buttons since. Element Plus's `color`
  (string).

- dark:

  Dark mode, which automatically converts `color` to dark mode colors.
  Element Plus's `dark` (boolean).

- dashed:

  Determine whether it's a dashed button. Element Plus's `dashed`
  (boolean).

- link:

  Determine whether it's a link button. Element Plus's `link` (boolean).

- loading_icon:

  Customize loading icon component. Element Plus's `loading-icon`
  (string / Component). An icon's name, such as `"Search"`.

- tag:

  Custom element tag. Element Plus's `tag` (string / Component). An
  icon's name, such as `"Search"`.

- text:

  Determine whether it's a text button. Element Plus's `text` (boolean).

- class, style:

  Extra classes and inline style on the button, as Element passes them
  to its root.

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

  In `el_button()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_button()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed button component.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the number of clicks, as [`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html) reports it |

The same list as `el_events("el_button")`, which says how an event's
arguments travel.

Counted as
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
counts: 0 on load, and only while neither `disabled` nor `loading` is
`TRUE`. It carries the same class, so
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) and
[`req()`](https://rdrr.io/pkg/shiny/man/req.html) treat 0 as not yet
clicked.

## Updating from the server

Server-side update for `el_button()`. Supports all visual states
including `size`, `plain`, `round`, and `loading`.

Every other argument of `el_button()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_button()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# Basic usage
el_button("btn_primary", "Primary", type = "primary")
#> <div id="btn_primary" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="btn_primary_container" style="display: contents">
#>   <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Primary","type":"primary","size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"state":"ready","autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_button("btn1", "Primary", type = "primary"),
    verbatimTextOutput("count")
  )
  server <- function(input, output, session) {
    output$count <- renderPrint(input$btn1)
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_button(session, "save", loading = TRUE)
  })
}
```
