# Element Plus Button with Vue Instance

Creates an Element Plus button with Vue instance, supporting all Element
Plus button variants including `plain`, `round`, `circle`, and `loading`
states.

## Usage

``` r
el_button(
  id = NULL,
  label = "Button",
  type = "default",
  size = NULL,
  plain = FALSE,
  round = FALSE,
  circle = FALSE,
  loading = FALSE,
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
  width = NULL,
  slots = NULL,
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

  Button text. Ignored (and defaults to `""`) when `circle = TRUE`.

- type:

  Button type: `"default"`, `"primary"`, `"success"`, `"warning"`,
  `"danger"`, `"info"`, `"text"`.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- plain:

  Whether to use the plain (hollow) style. Default `FALSE`.

- round:

  Whether to use rounded corners. Default `FALSE`.

- circle:

  Whether to render as a circle button (icon only, no label). Default
  `FALSE`.

- loading:

  Whether to show loading spinner. Disables click while active. Default
  `FALSE`.

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

- session:

  In `el_button()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_button()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed button component.

## Shiny inputs

`input$<id>` – the number of clicks, as
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
reports it: 0 on load, and counted only while neither `disabled` nor
`loading` is `TRUE`. It carries the same class, so
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
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Primary","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
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
