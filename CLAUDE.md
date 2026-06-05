# CLAUDE.md

claude –dangerously-skip-permissions This file provides guidance to
Claude Code (claude.ai/code) when working with code in this repository.

## Commands

``` r

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

`shiny.element` is an R package that wraps Element-UI (Vue 2) components
as Shiny widgets, using `vueR` as the bridge between Vue and
htmlwidgets.

### Component Pattern

Every Vue-backed component follows the same structure:

1.  **R function** (`R/el_*.R`) — builds HTML tags, creates a Vue
    instance via [`vueR::vue()`](https://rdrr.io/pkg/vueR/man/vue.html),
    and attaches the JS handler dependency.
2.  **JS handler** (`inst/js/el-*-handler.js`) — registers
    `Shiny.addCustomMessageHandler` to receive server-side update
    messages.
3.  **Update function** (`update_el_*`) — in the same R file, sends
    `session$sendCustomMessage(...)` to the corresponding JS handler.

The Vue instance mounts on `<div id="{ns_id}_container">`, while
`vueR::vue(elementId = ns_id, ...)` holds Vue data and methods.
Component IDs are always namespaced via `session$ns(id)` to support
Shiny modules.

### Dependency Loading

- [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
  — top-level page wrapper; loads Vue, Element-UI CDN,
  `vue-handlers.js`, and layout CSS. Wraps
  [`shiny::fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)
  with bslib Bootstrap 5.
- [`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
  — alternative for non-`el_page` contexts (bslib, navbarPage). Place at
  top of UI.
- Each component also calls `attachDependencies()` with its own handler
  JS, so components work even without
  [`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
  /
  [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md).

### Generic Vue Update API

`inst/js/vue-handlers.js` (loaded by
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md))
registers two universal handlers in `R/vue_update.R`:

- `update_vue_component(session, id, ...)` — updates named fields on any
  Vue instance’s `$data`.
- `update_vue_data(session, id, data)` — replaces the entire `$data` of
  a Vue instance.

Prefer these for components not yet covered by a dedicated `update_el_*`
function.

### Pure Tag API

`R/el_tags.R` exports `el` — a named list of tag-generator functions
covering all Element-UI components (e.g. `el$table(...)`,
`el$steps(...)`). These produce plain HTML tags with no Vue instance or
Shiny binding. Use them for static markup or when composing components
manually.

### Template Helper

`template(..., slot, scope)` in `R/template.R` generates a Vue
`<template>` tag for slot usage (e.g. `slot="dateCell"` with
`slot-scope`). Returns
[`htmltools::HTML`](https://rstudio.github.io/htmltools/reference/HTML.html).

### Shiny Input Conventions

| Component | Shiny input key | Value |
|----|----|----|
| `el_button` | `input$<id>` | Click count (integer) |
| `el_cascader` | `input$<id>_value` | Selected path (list) |
| `el_table` (selection) | `input$<id>_selected` | Selected rows (list of row data) |
| `el_calendar` | `input$<id>` | Selected date (string “YYYY-MM-DD”) |
| `el_steps` | `input$<id>` | Active step index (0-based integer) |

### Adding a New Component

1.  Create `R/el_<name>.R` with the widget function, an
    `update_el_<name>()` function, and a private
    `el_<name>_handler_dependency()`.
2.  Create `inst/js/el-<name>-handler.js` with
    `Shiny.addCustomMessageHandler('updateEl<Name>', ...)`.
3.  Add the handler dependency function in `R/el_dependencies.R`.
4.  Document with roxygen2 and run `devtools::document()`.

### Testing Pattern

Tests use a `mock_session` list to avoid a live Shiny session:

``` r

mock_session <- list(
  ns = function(id) id,
  sendCustomMessage = function(type, msg) { captured <<- msg }
)
```

Test HTML output by converting to string:
`paste(as.character(tag), collapse = "")`.
