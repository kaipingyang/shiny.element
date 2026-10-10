# Architecture

How the package is built: a Vue layer that knows no component library,
and the Element layer on top of it. Each diagram follows a component
from the R function that writes it to the browser and back to the
server.

## The layers

**Element layer — `R/el_*.R`, `inst/js/el-*.js`** Element Plus's
components as Shiny inputs and outputs: what each one reports, its
updates and methods, Element's containers, theme, locale and feedback
services.

el_widget()el_input() ... el_tree() el_tabs() el_dialog()el_table()
render_el_table() update_el\_\*()call_el() el_events()el_page()
use_element()

**Vue layer — `R/vue_*.R`, `inst/js/shiny-vue.js`** Any Vue 3 component
as a Shiny input, output or both, knowing no component library — to
become the shiny.vue package.

vue_app()vue_component() vue_store()render_vue()
render_vue_data()update_vue() call_vue()flush_vue() vue_answer()

**Underneath** Shiny's inputs, outputs, messages and bookmarks;
htmltools' tags and dependencies; Vue 3.5 and Element Plus 2.14, bundled
in `inst/vue3` and `inst/element-plus`.

## The Vue layer

R, in the app's UI and server Shiny's channel The browser:
`shiny-vue.js`

R

Shiny

Browser

A component is written

##### `vue_app(id, template, data, ...)`

- Vue's options under Vue's names: `methods`, `computed`, `watch`,
  `setup`, hooks; functions as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
- `components = vue_component()`, `use` plugins
- Shiny UI in the template taken out to **islands**

the host's HTML

`page / renderUI()`

##### The host, mounted

- `<script type="text/x-template">`, options JSON, the islands' holder
- `Vue.createApp()` on its own box; `app.use()` each plugin
- globals: `$setInput` `$store` `$inputs` `$errors` `$busy`
  `$recalculating`; `<shiny-island>` moves Shiny UI in and out

It reports

##### `input$<id>`, `input$<id>_<event>`

- the value: `input =`, typed by `type =`, paced by `rate =`
- events: `emits`, `events =`, `on =` handlers' `report()`, with event
  priority
- bookmarks restore the value
  ([`restoreInput()`](https://rdrr.io/pkg/shiny/man/restoreInput.html))

`setInputValue`

one binding: `shiny.vue`

##### InputBinding `shiny.vue`

- [`find()`](https://rdrr.io/r/utils/apropos.html) mounts every host it
  finds — start-up,
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html),
  [`insertUI()`](https://rdrr.io/pkg/shiny/man/insertUI.html)
- `getValue()` reads the input field; `sv.emit()` sends events, a key
  pressed as its key

The server changes it

##### `update_vue()`, `call_vue()`, `vue_answer()`

- fields whole, or in place: `insert` `replace` `delete` by position or
  `key`, `set` by path
- queued per session
  ([`.vue_send()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_send.md)),
  sent in [`onFlushed()`](https://rdrr.io/pkg/shiny/man/onFlush.html) as
  `update*Input()` are;
  [`flush_vue()`](https://kaipingyang.github.io/shiny.element/reference/flush_vue.md)
  sends now

after the outputs

`shinyVueUpdate``shinyVueCall`

##### `sv.update()`, `sv.call()`

- host by id, bound or not; a component folded into another through its
  wrapper
- `.edit` / `.set`, hooks, `shinyVueReceive()`, then declared fields; a
  method's result as `input$<id>_<method>`

Outputs

##### `render_vue()` · `render_vue_data()`

- [`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md):
  components the server writes, in
  [`vue_output()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)
- [`render_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/render_vue_data.md):
  values for fields of the components following it (`outputs =`,
  `shinyVue.useOutput()`)
- wait for promises;
  [`bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html)

markup, then patches

`output values`

##### Output bindings

- three-way patch: what the server changed is applied, what the user did
  kept
- data outputs set fields; `$recalculating`, `$errors`

Shared state

##### `vue_store(id, data, input)`

- one [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) for
  every component; reported and updated like a component

a host too

##### `$store.<id>`

- read and written by every template, at once, in the browser

## The Element layer

Every Element component is built on the Vue layer. What the layer adds
is Element’s: its components and their props, the inputs each one
reports, its containers, its theme and locale.

R Shiny's channel The browser: `el-events.js`, the containers' bindings

##### Controls

[`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md),
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md),
[`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md),
...

- [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md):
  the Element tag, its props
  ([`.el_props()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_props.md),
  `NA` for Element's default), the label, slots
- built by
  [`.vue_host()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_host.md)
  with `use = "shinyElement.plugin"`

##### Wrappers, folding others in

[`el_space()`](https://kaipingyang.github.io/shiny.element/reference/el_space.md),
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md),
[`el_card()`](https://kaipingyang.github.io/shiny.element/reference/el_card.md),
...

- [`.el_absorb()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_absorb.md):
  the components inside join the wrapper's Vue instance, their fields
  renamed, their ids kept in a registry

##### Containers

[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md),
[`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md),
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md),
[`el_drawer()`](https://kaipingyang.github.io/shiny.element/reference/el_drawer.md)

- Element's markup and classes, a Shiny binding of their own, no Vue
  instance — the components inside stay theirs

##### Data components

[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md),
[`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md)

- a specification, drawn by
  [`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md)
  /
  [`render_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md)
  through
  [`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md);
  the data kept per session

##### Feedback services

[`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md),
[`el_notification()`](https://kaipingyang.github.io/shiny.element/reference/el_notification.md),
[`el_message_box()`](https://kaipingyang.github.io/shiny.element/reference/el_message_box.md),
[`el_loading()`](https://kaipingyang.github.io/shiny.element/reference/el_loading.md)

- called from the server, sent at once

##### The page

[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md),
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)

- the theme (bslib, Element's CSS variables), the locale, size and
  z-index

R

Shiny

Browser

What a component reports

##### One registry: `R/el_events_registry.R`

- each component's inputs, and Element's events: unasked or on request
- [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md)
  prints it; `events =` is checked against it; each help page's "Shiny
  inputs" table comes from it
- forwarded by the Vue layer
  ([`.vue_event_bindings()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_event_bindings.md)),
  with `on =` handlers

`input$<id>_<event>`

Element's events

##### The component's Vue instance

- `@<event>="svEmit..."` on Element's tag
- containers report what `data-el-events` lists
- task buttons speak bslib's `bslib.taskbutton`

The server changes it

##### `update_el_*()`, `call_el()`, `el_load_children()`

- every argument that can change, under its name
- [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
  Element's 151 methods, with rows, files and nodes named
  ([`el_table_row()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md),
  [`el_tree_node()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md))
- sent through the Vue layer, with the flush

the Vue layer's

`shinyVueUpdate`

##### `shinyElement.plugin` (`el-events.js`)

- installs Element Plus and its icons on each app; `$elRef`, `$elDate`
- labels and errors (`.label`, `.error`, shinyvalidate)
- config providers, nested, for components drawn later too

Containers

##### `el_tabs()` · `insert_el_tab()` · `update_el_dialog()`

- markup with `data-el-*`; Shiny's input messages

`sendInputMessage`

##### `el-tabs-binding.js`, `el-collapse-binding.js`, `el-overlay-binding.js`

- Element's behaviour in plain markup: the active bar, focus trap,
  Escape, Element's z-index counter

## Where to read more

- The Vue layer as a user sees it: the “Building your own” part of
  [Shiny
  Integration](https://kaipingyang.github.io/shiny.element/articles/shiny.md).
- What each component reports:
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md),
  and each help page’s “Shiny inputs”.
- Which Element features have no R equivalent, and why: [What Works, and
  What Does
  Not](https://kaipingyang.github.io/shiny.element/articles/limitations.md).
