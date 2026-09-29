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

`shiny.element` is an R package that wraps Element-UI (Vue 2) components as Shiny widgets, using `vueR` as the bridge between Vue and htmlwidgets.

### Component Pattern

Every Vue-backed component follows the same structure:

1. **R function** (`R/el_*.R`) — builds HTML tags, creates a Vue instance via `vueR::vue()`, and attaches the JS handler dependency.
2. **JS handler** (`inst/js/el-*-handler.js`) — registers `Shiny.addCustomMessageHandler` to receive server-side update messages.
3. **Update function** (`update_el_*`) — in the same R file, sends `session$sendCustomMessage(...)` to the corresponding JS handler.

The Vue instance mounts on `<div id="{ns_id}_container">`, while `vueR::vue(elementId = ns_id, ...)` holds Vue data and methods. Component IDs are always namespaced via `session$ns(id)` to support Shiny modules.

### Dependency Loading

- `el_page()` — top-level page wrapper; loads Vue, Element-UI (bundled in `inst/element-ui`, not a CDN), `vue-handlers.js`, and layout CSS. Wraps `shiny::fluidPage()` with bslib Bootstrap 5. Takes `offline`, `locale` and `dev`.
- `use_element()` — alternative for non-`el_page` contexts (bslib, navbarPage). Place at top of UI.
- Each component calls `attachDependencies()` with `.el_handler_dependency("<name>")`, which pairs its handler JS with the shared `el-update.js`, so components work even without `use_element()` / `el_page()`.

### Generic Vue Update API

`inst/js/vue-handlers.js` (loaded by `use_element()`) registers two universal handlers in `R/vue_update.R`:

- `update_vue_component(session, id, ...)` — updates named fields on any Vue instance's `$data`.
- `update_vue_data(session, id, data)` — replaces the entire `$data` of a Vue instance.

Prefer these for components not yet covered by a dedicated `update_el_*` function.

### Pure Tag API

`R/el_tags.R` exports `el` — a named list of tag-generator functions covering all Element-UI components (e.g. `el$table(...)`, `el$steps(...)`). These produce plain HTML tags with no Vue instance or Shiny binding. Use them for static markup or when composing components manually.

### Template Helper

`template(..., slot, scope)` in `R/template.R` generates a Vue `<template>` tag for slot usage (e.g. `slot="dateCell"` with `slot-scope`). Returns `htmltools::HTML`.

### Shiny Input Conventions

| Component | Shiny input key | Value |
|-----------|----------------|-------|
| `el_button` | `input$<id>` | Click count (integer) |
| `el_cascader` | `input$<id>_value` | Selected path (list) |
| `el_table` (selection) | `input$<id>_selected` | Selected rows (list of row data) |
| `el_calendar` | `input$<id>` | Selected date (string "YYYY-MM-DD") |
| `el_steps` | `input$<id>` | Active step index (0-based integer) |
| `el_table` | `input$<id>_selected_rows` | 1-based row numbers, types intact |
| `el_form` | `input$<id>` / `_valid` / `_submit` | Model, verdict, submit counter |
| `el_menu` | `input$<id>` / `_path` | Selected index, and its full path |
| `el_tree` | `input$<id>` / `_checked` | Last clicked key, checked keys |
| `el_upload` | `input$<id>` | Same data frame as `fileInput()` |

`input$<id>` is reported on load as well as on change. An empty selection
arrives as `NULL`, which is what Shiny does with an empty array.

### Adding a New Component

**Read `.claude/docs/lessons.md` first** — it has the checklist and the
constraints that are not obvious from the code.

1. `R/el_<name>.R`: the widget function, `update_el_<name>()`, and
   `el_<name>_handler_dependency()` (one line: `.el_handler_dependency("<name>")`).
2. Mount point gets `style = .el_host_style()`; the widget gets
   `width = 0, height = 0`. Both matter for layout — see lessons.md §1.3, §1.4.
3. Optional props use `.el_optional_bind()` with an `NA` placeholder, so they
   fall back to Element's own defaults (§2.1, §2.2).
4. Stateful components call `.el_mounted_init()` to report their initial value,
   or `input$<id>` stays NULL until the user touches them (§3.1).
5. `inst/js/el-<name>-handler.js`: normally one line,
   `elRegisterUpdate('updateEl<Name>')`. Write a bespoke handler only when the
   update needs a component method (form, tree, upload, feedback do).
6. Parent/child structures are declarative — generate them in R or pass them
   through a `data` prop. Components cannot nest (§1.1).
7. `roxygen2::roxygenise(".")`, then tests: unit, browser fixture, **and look
   at a screenshot** (§5.1).

### Testing

Three layers, each blind to what the next one catches — see lessons.md §5.

| Layer | Where | Catches |
|---|---|---|
| Unit | `test-el_*.R` | HTML generation, message fields, helper logic |
| Browser | `test-browser.R` + `apps/integration.R` | mounting, interaction, geometry, Vue warnings |
| Screenshot | by hand | layout and appearance — invisible to the other two |

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
