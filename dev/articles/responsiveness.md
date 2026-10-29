# Responsiveness

A Shiny app can feel slow where a JavaScript app does not: a click, a
pause, then the page changes. This article says where a Shiny app waits,
why, and what this package does about each part – so that the page
answers at once while the server keeps the data.
[Performance](https://kaipingyang.github.io/shiny.element/dev/articles/performance.md)
is about the other kind of slowness, a page taking long to start.

## Where a Shiny app waits

Shiny is driven by the server. The browser reports every change – a
click, a key, a selection – over a WebSocket; R runs the observers and
outputs that depend on it; the result travels back and the page is
changed. Almost all state lives in R, even state only the page needs,
such as whether a dialog is open.

That design is what makes Shiny easy: one language, reactive state, no
API to write. Its costs come in four kinds, and only some of them are
the design’s own:

| The wait | Why | Shiny’s design? |
|----|----|----|
| A click answered after a pause | Every interaction is a round trip: the network, then R | Yes: the state is on the server |
| One user’s work stops the others | An R process serves many sessions, one thing at a time | Partly: R is single-threaded; the round trips make every user meet it |
| Updates that cost more than they change | [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) sends a whole piece of page again, which the browser takes down and builds again | No: a way of sending, not the design |
| A computation that takes long | The data, the model | No: the same in any framework |

The first is the one users see most. A JavaScript application (Vue,
React) splits the work differently: what only the page needs – a dialog
open, a size picked, the tab shown – stays in the browser and costs
nothing, and the backend is asked only for data and decisions.

## What the package does

The package keeps Shiny’s way – R decides, inputs and outputs are
reactive – and adds the browser’s way where it serves. Four parts, one
for each kind of wait.

### 1. The page’s state stays in the page

A component’s argument given
[`vue_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_bind.md)
follows state in the browser, with no round trip:

``` r

el_radio_group(
  "size",
  choices = c("large", "default", "small"),
  selected = "default"
)
el_space(size = vue_bind("$inputs.size"), el_card("One"), el_card("Two"))

vue_store("ui", state = list(open = FALSE))
el_button("open", "Open", on = list(click = "$store.ui.open = true"))
el_dialog(
  "tips",
  title = "Tips",
  visible = vue_bind("$store.ui.open"),
  content = "Opened in the browser."
)
```

Tips

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

Opened in the browser.

`$inputs.<id>` is another component’s value; a
[`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md)
is state several components share, both ways – closing the dialog sets
the store back. An `on` handler acts in the browser too: setting a
store, or showing Element’s message, `"$message('Saved')"`. The server
still hears every `input$<id>`, and can still update a bound field. See
the Shiny guide’s “Linking components in the browser”.

Measured on this package’s development server (headless Chrome, the app
on the same machine, so with no network in the way), the time from a
click to a dialog on screen:

| The dialog opened | R idle | R busy for 2 s with another click |
|----|----|----|
| by the server, [`update_el_dialog()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dialog.md) | 64 ms | 1,822 ms |
| in the browser, [`vue_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_bind.md) | 1.4 ms | 1.2 ms |

Over a real network the first row adds the network’s round trip; the
second row does not change. And the busy column is the second kind of
wait made visible: the server’s dialog waits for R to be free, the
browser’s does not ask it.

### 2. Little crosses the wire

When the server must be asked, the package sends as little as it can:

- **Changes, not pages.** A component an output renders a second time
  gets only the data fields that changed
  ([`render_vue()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_output.md),
  [`render_el_table()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_output.md)):
  no markup, no new Vue app, the user’s sort and open rows kept. A table
  or calendar changed row by row gets only those rows
  (`update_el_table(insert =, replace =, delete =)`).
- **One message per flush.** Updates and method calls are queued and
  sent together when Shiny flushes, as Shiny’s own `update*Input()`s
  are.
- **Only the events asked for.** A component reports its value and the
  user’s deliberate actions; Element’s other events only with
  `events =`. A typed value can be debounced with `rate`.
- **Cached for everyone.**
  [`render_vue()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_output.md),
  [`render_vue_data()`](https://kaipingyang.github.io/shiny.element/dev/reference/render_vue_data.md)
  and
  [`render_el_table()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_output.md)
  work with
  [`bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html): a
  render shared by every session, each page still sent only what it
  lacks.
- **Only what is seen.** A tree loads a node’s children when it opens
  (`lazy = TRUE`);
  [`el_table_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2.md)
  draws the rows in view; a select can draw its options when opened
  (`persistent = FALSE`).

### 3. The page does not wait blind

- **Changed at once, confirmed after.** An editable table cell takes the
  new value in the browser as it is typed, and the server converts it to
  the column’s type afterwards – an optimistic update.
- **Waiting shown where it happens.**
  [`el_table_output()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_output.md)
  covers a table with Element’s mask while Shiny recalculates it
  (`loading`); templates read `$recalculating.<id>` and `$busy`;
  [`el_page()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_page.md)
  covers the page until every component is drawn.

### 4. One user’s work does not stop the others

R does one thing at a time per process, so a long computation in one
session holds up every session in it. Shiny’s `ExtendedTask`, with
`promises` or `mirai`, runs it elsewhere, and every render function of
this package waits for a promise. `el_button(task = TRUE)`, bound with
[`bslib::bind_task_button()`](https://rstudio.github.io/bslib/reference/bind_task_button.html),
is a button for such a task, busy while it runs, as bslib’s own task
button is:

``` r

ui <- el_page(
  el_button("go", "Fit the model", task = TRUE),
  el_table_output("fit")
)
server <- function(input, output, session) {
  fit <- ExtendedTask$new(function(data) {
    mirai::mirai(
      as.data.frame(coef(summary(lm(mpg ~ wt + hp, data = data)))),
      data = data
    )
  })
  bslib::bind_task_button(fit, "go")
  observeEvent(input$go, fit$invoke(mtcars))
  output$fit <- render_el_table(el_table(data = fit$result(), rownames = TRUE))
}
```

## Where each thing goes

| It is | Put it | With |
|----|----|----|
| The page’s own state: open, picked, shown | the browser | [`vue_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_bind.md), [`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md), `on` |
| A message about what the page did | the browser | `on = list(click = "$message(...)")` |
| Data, and what is computed from it | the server | outputs, `update_*()` |
| A decision that matters: who may see what, what is saved | the server | observers; the browser’s state is a convenience, never a permission |
| A long computation | another process | `ExtendedTask` with `mirai` or `promises` |

The two halves meet in `input$<id>`: whatever the page does, the server
can see it, and whatever the server decides, it can set on the page.
