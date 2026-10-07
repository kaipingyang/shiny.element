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

`shiny.element` wraps Element Plus 2.14.7 (Vue 3) for Shiny. Vue 3.5.43
and Element Plus (with `@element-plus/icons-vue` 2.3.2 and its 67
locales) are bundled in `inst/vue3` and `inst/element-plus`; there is no
vueR and no htmlwidgets dependency
([`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
in `R/js.R` marks JavaScript the same way). The Vue 2 / Element UI
version is tagged `v0.1.0-vue2`.

Upstream sources for reference live in `.upstream/element-plus` (git
clone of tag 2.14.7, gitignored; see `.upstream/README.md`). Its
`docs/en-US/component/*.md` and `docs/examples/` are what the site
replicates.

### Two layers

The **Vue layer** (`R/vue_*.R`, `inst/js/shiny-vue.js`) knows no
component library and is to become the shiny.vue package:
[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`vue_component()`](https://kaipingyang.github.io/shiny.element/reference/vue_component.md),
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md),
[`vue_output()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)/[`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md),
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
[`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md),
[`vue_answer()`](https://kaipingyang.github.io/shiny.element/reference/vue_answer.md),
and the `.vue_*` helpers. `test-vue-layer.R` fails if any of it names
Element; `test-browser-pure-vue.R` runs it with no Element Plus on the
page. The **Element layer** (`R/el_*.R`, `inst/js/el-*.js`) is built on
it:
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
builds through
[`.vue_host()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_host.md)
with `use = "shinyElement.plugin"` (Element Plus, its icons, `$elRef`,
`$elDate`), and the `.el_*` helpers delegate to the `.vue_*` ones.
Design record: `.claude/plans/vue-layer-2026-10-04.md`.

### Two kinds of component

**Controls** (input, select, table, form, …) are Vue apps on a host
element – one `Vue.createApp()` each, Element Plus installed on each by
`sv.install()` – built by
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md)
(`R/el_widget.R`):

``` html
<div id=ID data-shiny-vue style="display: contents">
  <script type="text/x-template" data-shiny-vue-template>
    <div id=ID_container ...>markup</div>      <!-- or the labelled form item -->
  </script>
  <script type="application/json" data-shiny-vue-options>{options,input,rate,type,evals}</script>
</div>
```

`inst/js/shiny-vue.js` (generic, Element-free – meant to become
shiny.vue) compiles the template off-page and appends it to the host,
and registers one Shiny InputBinding, `shiny.vue`, on every host with a
value (`input` names the reported field; `type` an input handler such as
`shiny.element.date` or `shiny.action`; `rate` a debounce).
`inst/js/el-events.js` is Element’s side: error drawing for
shinyvalidate and `update_el_*(error =)`, label updates, row indexes,
the raw-`<el-*>`-tag warning.

**Containers** (`el_tabs`, `el_collapse`, `el_dialog`, `el_drawer`,
`el_row`, `el_col`, `el_container`) are plain markup with Element’s
classes and a Shiny input binding of their own
(`inst/js/el-*-binding.js`). A Vue instance mounted over a container
would recompile and detach the components inside.

**Data components** (`el_table` now; table_v2, tree, transfer to follow)
are outputs in an app: `el_table_output(id)` +
`render_el_table(el_table(data = ...))`.
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
returns a spec object
([`.el_component()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_component.md),
`R/el_component.R`) drawn by
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html),
as htmlwidgets are, so
[`el_on()`](https://kaipingyang.github.io/shiny.element/reference/el_on.md)
can pipe events onto it;
[`.el_resolve()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_resolve.md)
draws specs inside UI that code reads as tags. The rendered host is
`<id>-el` with `data-shiny-vue-id=<id>`: the bridge finds it by either.
A component with a value in an output reports `input$<id>` through
`Shiny.setInputValue()` with no binding (`reportFromOutput`), since an
input binding sharing the output’s id makes Shiny warn; the table has no
value (`input$<id>` is left free) and reports `_selection_rows`. The
first render sends markup; later renders with the same template and
options send only the changed data fields as JSON
([`.vue_output_value()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_output_value.md),
`applyPatch()` in shiny-vue.js), and a page that cannot apply a patch
asks for the markup with `input$<id>__vue_redraw`. Under `bindCache()`
the cache keeps the whole output (`.vue_output_whole()`, the same for
every session, via `cacheWriteHook`) and `cacheReadHook` compares it
with what the session’s page has (`.vue_output_send()`).
`el_table_output(loading = TRUE)` shows Element’s mask while Shiny
recalculates. The data the table shows is kept per session
(`.el_tables()`, a `reactiveValues()`, read by
[`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md)):
a render writes it only when its own data changed, an update always –
the rule the browser’s patching follows – so the
`shiny.element.selection` handler returns the right
`data[rows, , drop = FALSE]`. Editable columns
(`el_table_column(editable =)`,
[`.el_table_editor()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_table_editor.md))
apply an edit in the browser at once and on the server in the
`shiny.element.cell_edit` input handler, which converts the value to the
column’s type.

### Server to browser

- `update_el_*()` and
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
  send one custom message, `shinyVueUpdate`, a flat
  `{id, fields..., .action}`
  ([`.el_send_update()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_send_update.md)).
  The bridge finds the host by id, bound or not – Shiny’s input messages
  reach only bound inputs – runs `sv.hooks` for dot-keys (`.label`,
  `.error`, `.resolve`), then the component’s `shinyVueReceive(data)` if
  it has one (for method calls: form, carousel, tree, upload), then
  assigns declared `$data` fields; an unknown id or field logs
  `[shiny-vue]`.
- [`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md)
  (and
  [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md),
  which adds Element’s row/file/node references) sends `shinyVueCall` to
  run a method; a return value comes back as `input$<id>_<method>`.
  `update_vue(value =)` sets the input field; updates reach `data` and
  `setup()` state.
- [`render_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/render_vue_data.md)
  is an output of a component’s data: it renders fields by name and the
  components following it (`vue_app(outputs = "id")`) set them as
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
  would – declared fields only, as Vue tracks no others. The bridge
  places a `.shiny-vue-data-output` element per output in the host and
  binds it (`placeOutputs()`), so it is suspended while the component is
  hidden; `$recalculating.<id>` in templates follows its progress.
  Render functions are built on `createRenderFunction()` so they wait
  for promises.
- `el_calendar(events =, editable =)` is a planner whose events the
  server owns, as toastui’s: the user’s actions are requests (`_add`,
  `_update`, `_delete`, typed by `shiny.element.cal_event`), answered by
  `update_el_calendar(insert =, replace =, delete =)` by id; the markup
  is the calendar plus a dialog beside it, so its props and slots are
  put on the calendar tag in `.el_calendar_tags()` itself. Like the
  table it is a spec object with an output form
  ([`el_calendar_output()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md),
  [`render_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md));
  both renders go through
  [`.el_render_component()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_render_component.md).
  Event fields follow Element first (`type`, `color`), toastui where
  Element has none (`start`, `end`, `title`, `body`, `_update` as
  `list(event, changes)`).
- `shinyVue.ask(input, question)` lets a component ask the server (lazy
  loaders, remote search);
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md)
  answers through `.resolve`.
- Feedback services (message, notification, message box, loading) use
  `inst/js/el-feedback-handler.js`.
- Every server function takes
  `session = shiny::getDefaultReactiveDomain()` first and calls
  `.el_check_session(session)` first.

### Dependency loading

- [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
  – [`shiny::fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)
  with
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)
  (bslib), Vue, Element Plus, the bridge, the locale, the global config
  (`size`, `z_index`) and, when the theme changes Element Plus’s
  colours, a `<style>` of its CSS variables (`R/el_element_theme.R`,
  dependency `element-plus-theme`).
- [`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
  – the same for other page functions.
- Every component also attaches what it needs, so it works on any page
  and without Shiny (static R Markdown, the pkgdown site).

### Pure tag API

`el` (`R/el_tags.R`) holds a tag generator for every component Element
registers. Raw tags compile only inside a component – a
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md),
a slot, a table cell, a wrapper’s trigger, `el_widget(markup =)`.

### Naming: arguments and keys

- **R arguments are snake_case**, Element Plus’s kebab-case prop names
  turned mechanically (`show-overflow-tooltip` -\>
  `show_overflow_tooltip`). No camelCase aliases for them: an alias
  doubles every signature and help page. Two names exist only where
  Shiny and Element name one concept differently (`choices`/`options`,
  `selected`/`value`).
- **Keys that travel to JavaScript as data accept both spellings**, the
  JavaScript name being the canonical one: column definitions
  (`show_overflow_tooltip` or `showOverflowTooltip`), items, plugin
  options, and the Vue layer’s options (`before_unmount` or
  `beforeUnmount`). Convert with
  [`.el_camel_case()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_camel_case.md);
  two spellings with different values are an error.
- **Only names the package knows are converted.** Field names in `data`,
  method names, anything a template refers to are the user’s and pass
  through exactly as written – renaming `item_count` would break
  `{{ item_count }}`.

### Shiny input conventions

Every input reports `input$<id>` on load and on change; an empty
selection is `NULL`. Exceptions and extras are documented in each
function’s “Shiny inputs” section (`el_table`’s `_selection_change`,
`el_form`’s `_valid` and `_submit`, events as `input$<id>_<event>`).

Two id forms: flat `input$<id>_<name>` for events and states (each
observer fires for its own; event priority works); `input$<id>$<field>`
only when one value has parts (el_form’s model,
`vue_app(input = c("a", "b"))`). Event inputs are named after Element’s
event in snake_case (`selection-change` -\> `_selection_change`); where
upstream has no name, toastui’s. A component reports a few events by
default and the rest when asked (`events =`,
[`el_on()`](https://kaipingyang.github.io/shiny.element/reference/el_on.md)).
Design record: `.claude/plans/shiny-style-components-2026-10-06.md`.

### Adding a new component

**Read `.claude/docs/lessons.md` first.**

1.  `R/el_<name>.R`: the component function built with
    [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md),
    and `update_el_<name>()` sending
    [`.el_send_update()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_send_update.md).
2.  Optional props bind through
    [`.el_optional_bind()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_optional_bind.md)
    with an `NA` placeholder so they fall back to Element’s defaults and
    stay updatable.
3.  A stateful component names its value with
    `mounted = .el_mounted_init(c(<field> = ns_id))`; that field becomes
    the binding’s value.
4.  Enumerated arguments go in `.el_choices` (`R/el_choices.R`) with
    [`.el_check_choices()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_check_choices.md)
    first in the function.
5.  `roxygen2::roxygenise(".")`, then tests: unit, the browser fixture,
    and **look at a screenshot** (`tools/article-shots.R`).

### Testing

Three layers, each blind to what the next one catches — see lessons.md
§5.

| Layer | Where | Catches |
|----|----|----|
| Unit | `test-el_*.R` | HTML generation, message fields, helper logic |
| Browser | `test-browser.R` + `apps/integration.R` | mounting, interaction, geometry, Vue warnings |
| Methods | `test-browser-methods.R` + `apps/methods.R` | every documented method runs on a live component |
| Screenshot | `tools/article-shots.R` | layout and appearance — invisible to the other two |

Browser tests run Vue’s development build (`inst/vue3/vue.global.js`,
`el_page(dev = TRUE)`) and assert zero warnings. They skip on CRAN and
where no Chrome is available:

``` bash
NOT_CRAN=true Rscript -e 'devtools::load_all("."); testthat::test_dir("tests/testthat")'
```

Unit tests use a `mock_session` list to avoid a live Shiny session:

``` r

mock_session <- list(
  ns = function(id) id,
  sendCustomMessage = function(type, msg) { captured <<- msg }
)
```

Test HTML output by converting to string:
`paste(as.character(tag), collapse = "")`. A bare list of tags needs
[`htmltools::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
first, or [`as.character()`](https://rdrr.io/r/base/character.html)
deparses it instead of rendering.

`test-update-fields.R` renders every component and checks that each
field its `update_*()` sends really exists in the Vue data — a mismatch
is otherwise a silent no-op.

### Documentation site

The pkgdown site replicates element-plus.org. Component pages are
generated: `tools/demos/<slug>.R` holds the R version of each upstream
demo (`## name` blocks, `#'` prose, `#|` chunk options, `!skip` for
prose-only), and `python tools/ep-pages.py [slug...]` writes
`vignettes/articles/components/<slug>.Rmd` from upstream’s markdown and
those demos (color, icon and the overview are hand-written /
`tools/ep-overview.py`). `Rscript tools/article-shots.R [slug...]`
screenshots and checks every example; API coverage is
`python tools/api-coverage.py --docs`, then
`Rscript tools/api-coverage.R`, then `python tools/api-coverage.py`
(`--gaps`, `--write-api` for the API tables’ JSON with the R name of
each entry, `--write-docs`).

R code is formatted with air (`air.toml`, line width 80): `air format .`
for every .R file but the demos, then `python tools/format-r.py` for the
demo blocks, the hand-written articles’ chunks and roxygen `@examples`
(it lists any block air cannot parse), followed by `tools/ep-pages.py`
and `devtools::document()`. `air format --check .` should print nothing.

## Finishing a change

Every round of changes ends the same way, without being asked:

1.  verify (tests for what changed, `air format --check .`, and for a
    release-level change the full suites, `R CMD check` and the article
    shots);
2.  commit on the working branch (`element-plus` now) and push it;
    `main` follows by fast-forward
    (`git push origin element-plus:main`), and the pkgdown deploy that
    push starts is checked until it succeeds;
3.  install into the user’s home library,
    `R CMD INSTALL --no-multiarch .`, and check its `Built:` date –
    tests use `load_all()` and pkgdown and `R CMD check` install into
    temporary libraries, so without this the user’s own
    [`library(shiny.element)`](https://kaipingyang.github.io/shiny.element/)
    stays on an old build.

## Lessons and gotchas

`.claude/docs/lessons.md` records what was learned the hard way:
architectural constraints that cannot be worked around, Element and
Shiny behaviours that fail silently, and the verification habits that
caught them. Read it before changing how components are built or
rendered.

`.claude/docs/screenshot-recipe.R` is the driver template for looking at
a page yourself.

`.claude/docs/bridges-survey.md` is how Shiny itself, bslib,
htmlwidgets, vueR, reactR, shiny.react and shinyreact connect components
to Shiny – read from their sources, each claim with its evidence – and
how ours compares. Read it before changing how components render, update
or report.
