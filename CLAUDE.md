# CLAUDE.md
claude --dangerously-skip-permissions
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```r
# Install package locally (in R console)
devtools::install()

# Load package for development
devtools::load_all()

# Generate documentation from roxygen2 comments
devtools::document()

# Run all tests
devtools::test()

# Run a single test file
devtools::test(filter = "el_button")

# Build and check package
devtools::check()
```

## Architecture

`shiny.element` wraps Element UI 2.15.14 (Vue 2) for Shiny. Vue 2.7.14 and
Element are bundled in `inst/vue` and `inst/element-ui`; there is no vueR and
no htmlwidgets dependency (`JS()` in `R/js.R` marks JavaScript the same way).

### Two kinds of component

**Controls** (input, select, table, form, ...) are Vue instances on a host
element, built by `el_widget()` (`R/el_widget.R`):

```html
<div id=ID data-shiny-vue style="display: contents">
  <script type="text/x-template" data-shiny-vue-template>
    <div id=ID_container ...>markup</div>      <!-- or the labelled form item -->
  </script>
  <script type="application/json" data-shiny-vue-options>{options,input,rate,type,evals}</script>
</div>
```

`inst/js/shiny-vue.js` (generic, Element-free -- meant to become shiny.vue)
compiles the template off-page and appends it to the host, and registers one
Shiny InputBinding, `shiny.vue`, on every host with a value (`input` names
the reported field; `type` an input handler such as `shiny.element.date` or
`shiny.action`; `rate` a debounce). `inst/js/el-events.js` is Element's side:
error drawing for shinyvalidate and `update_el_*(error =)`, label updates, row
indexes, the raw-`<el-*>`-tag warning.

**Containers** (`el_tabs`, `el_collapse`, `el_dialog`, `el_drawer`, `el_row`,
`el_col`, `el_container`) are plain markup with Element's classes and a Shiny
input binding of their own (`inst/js/el-*-binding.js`). A Vue instance
mounted over a container would recompile and detach the components inside.

### Server to browser

- `update_el_*()` and `update_vue_data()` send one custom message,
  `shinyVueUpdate`, a flat `{id, fields..., .action}` (`.el_send_update()`).
  The bridge finds the host by id, bound or not -- Shiny's input messages
  reach only bound inputs -- runs `sv.hooks` for dot-keys (`.label`,
  `.error`, `.resolve`), then the component's `shinyVueReceive(data)` if it
  has one (for method calls: form, carousel, tree, upload), then assigns
  declared `$data` fields; an unknown id or field logs `[shiny-vue]`.
- `el_call()` sends `shinyVueCall` to run an Element method; a return value
  comes back as `input$<id>_<method>`.
- `shinyVue.ask(input, question)` lets a component ask the server (lazy
  loaders, remote search); `el_load_children()` answers through `.resolve`.
- Feedback services (message, notification, message box, loading) use
  `inst/js/el-feedback-handler.js`.
- Every server function takes `session = shiny::getDefaultReactiveDomain()`
  first and calls `.el_check_session(session)` first.

### Dependency loading

- `el_page()` -- `shiny::fluidPage()` with `el_theme()` (bslib), Vue,
  Element, the bridge, the locale, the global config (`size`, `z_index`) and,
  when the theme changes Element's colours, Element's stylesheet recoloured
  (`R/el_colors.R`, served as `element-ui` 2.15.14.1).
- `use_element()` -- the same for other page functions.
- Every component also attaches what it needs, so it works on any page and
  without Shiny (static R Markdown, the pkgdown site).

### Pure tag API

`el` (`R/el_tags.R`) holds a tag generator for every component Element
registers. Raw tags compile only inside a component -- a `template()`, a
slot, a table cell, a wrapper's trigger, `el_widget(markup =)`.

### Shiny input conventions

Every input reports `input$<id>` on load and on change; an empty selection is
`NULL`. Exceptions and extras are documented in each function's "Shiny
inputs" section (`el_table`'s `_selected_rows`, `el_form`'s `_valid` and
`_submit`, events as `input$<id>_<event>`).

### Adding a new component

**Read `.claude/docs/lessons.md` first.**

1. `R/el_<name>.R`: the component function built with `el_widget()`, and
   `update_el_<name>()` sending `.el_send_update()`.
2. Optional props bind through `.el_optional_bind()` with an `NA` placeholder
   so they fall back to Element's defaults and stay updatable.
3. A stateful component names its value with
   `mounted = .el_mounted_init(c(<field> = ns_id))`; that field becomes the
   binding's value.
4. Enumerated arguments go in `.el_choices` (`R/el_choices.R`) with
   `.el_check_choices()` first in the function.
5. `roxygen2::roxygenise(".")`, then tests: unit, the browser fixture, and
   **look at a screenshot** (`tools/article-shots.R`).

### Testing

Three layers, each blind to what the next one catches — see lessons.md §5.

| Layer | Where | Catches |
|---|---|---|
| Unit | `test-el_*.R` | HTML generation, message fields, helper logic |
| Browser | `test-browser.R` + `apps/integration.R` | mounting, interaction, geometry, Vue warnings |
| Screenshot | `tools/article-shots.R` | layout and appearance — invisible to the other two |

Browser tests run Vue's development build and assert zero warnings. They skip
on CRAN and where no Chrome is available:

```bash
NOT_CRAN=true Rscript -e 'devtools::load_all("."); testthat::test_dir("tests/testthat")'
```

Unit tests use a `mock_session` list to avoid a live Shiny session:

```r
mock_session <- list(
  ns = function(id) id,
  sendCustomMessage = function(type, msg) { captured <<- msg }
)
```

Test HTML output by converting to string: `paste(as.character(tag), collapse = "")`.
A bare list of tags needs `htmltools::tagList()` first, or `as.character()`
deparses it instead of rendering.

`test-update-fields.R` renders every component and checks that each field its
`update_*()` sends really exists in the Vue data — a mismatch is otherwise a
silent no-op.

## Lessons and gotchas

`.claude/docs/lessons.md` records what was learned the hard way: architectural
constraints that cannot be worked around, Element UI and Shiny behaviours that
fail silently, and the verification habits that caught them. Read it before
changing how components are built or rendered.

`.claude/docs/screenshot-recipe.R` is the driver template for looking at a page
yourself.
