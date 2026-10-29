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

`shiny.element` wraps Element Plus 2.14.7 (Vue 3) for Shiny. Vue 3.5.43 and
Element Plus (with `@element-plus/icons-vue` 2.3.2 and its 67 locales) are
bundled in `inst/vue3` and `inst/element-plus`; there is no vueR and no
htmlwidgets dependency (`JS()` in `R/vue_js.R` marks JavaScript the same way).
To stay under CRAN's 5 MB: eleven locales are files and the other 56 are in
`dist/locale/more.tar.gz`, taken out into `tempdir()` when first used
(`.el_locale_dir()`); Day.js's locales for the same languages, which
Element's date components read, likewise in `inst/dayjs/locale`
(`.el_dayjs_locale_dir()`, set with Element's by `el_locale_dependency()`); Vue's development build is `.Rbuildignore`d, so a
CRAN install loads it from unpkg (`.vue_core_dependency()`); only the
Getting started and Shiny guides are vignettes, the rest pkgdown articles.
A page's theme is compiled once per machine, not per R process
(`R/el_theme_cache.R`: sass's cache, placed where bslib's file output goes);
the default `el_theme()` ships compiled in `inst/el-theme/` for the bslib and
sass on CRAN (`Rscript tools/el-theme-css.R` before a release). `el_page()`
covers the page with Element's loading mask until every host has mounted
(`loading = TRUE`).
The Vue 2 / Element UI version is tagged `v0.1.0-vue2`.

Upstream sources for reference live in `.upstream/element-plus` (git clone of
tag 2.14.7, gitignored; see `.upstream/README.md`). Its
`docs/en-US/component/*.md` and `docs/examples/` are what the site replicates.

### Two layers

The **Vue layer** (`R/vue_*.R`, `inst/js/shiny-vue.js`) knows no component
library and is to become the shiny.vue package: `vue_app()`,
`vue_component()`, `vue_store()` (a Pinia 4.1.0 store, `inst/pinia`:
`state`/`getters`/`actions` or `setup`, `$store.<id>` in every template,
its host exposing the store so updates, calls and outputs reach it),
`vue_output()`/`render_vue()`,
`update_vue()`, `call_vue()`, `vue_answer()`, `vue_router()` (vue-router
5.4.0, `inst/vue-router`: one router per page, in every app, the route
in the hash and as `input$<id>`), `vueuse_dependency()` (VueUse 15.0.0,
Element's own version, `inst/vueuse`, opt-in, for `setup()`),
`vue_bind()` (an argument following `$store`, `$inputs` or `$route` in the
browser, no round trip: `.vue_host()` moves a bound field's path to the
spec's `bound`, the bridge keeps field and path in step; containers
bind what their update can set, `.vue_bound_markup()` writing
`data-shiny-vue-bind` and their bindings applying it through
`shinyVue.bindElement()` as updates; an argument R
reads to draw with says so, `.vue_unbound()`, and `test-vue-bind.R` fails
on any argument of any component that drops a binding), and the
`.vue_*` helpers.
`test-vue-layer.R` fails if any of it names Element; `test-browser-pure-vue.R`
runs it with no Element Plus on the page. The **Element layer** (`R/el_*.R`,
`inst/js/el-*.js`) is built on it: `el_widget()` builds through `.vue_host()`
with `use = "shinyElement.plugin"` (Element Plus, its icons, `$elRef`,
`$elDate`). Design record: `.claude/plans/vue-layer-2026-10-04.md`.

**Calling the Vue layer.** Element code calls a `.vue_*` helper directly;
an `.el_*` helper exists only where the Element layer adds something of
its own (Element's names, its plugin, its defaults), never as a one-line
forwarder or a copy -- one job, one function. A forwarder also breaks
helpers that name their caller (`.vue_check_session()` reads
`sys.call(-1)` for its message). When the Vue layer becomes shiny.vue,
the helpers the Element layer uses are exported there as its API for
library authors (as htmlwidgets exports `createWidget()`), not reached
with `:::`. A helper moved between layers moves with every caller in the
same commit: no name is left behind for compatibility -- internal
helpers are not an API.

**User code goes in untouched.** The Vue layer is to be a package for
any Vue code, so its machinery never takes a name from the user's space:
the bridge's helpers are global properties starting with `$` (`$setInput`,
`$store`, `$inputs`, `$busy`, and `$optional()` once props bind through
it), and options it adds to a component are namespaced (`shinyVue*`).
Whatever Vue the user writes -- `data`, `computed`, `methods`, `watch`,
`setup`, lifecycle hooks, `components`, `directives`, `provide`, `emits`,
plugins through `use`, any other option -- passes through as written.
Where the package and the user give the same thing, the two are merged
and the user's wins: an event handler (`.vue_merge_handlers()`), one
`v-bind` object rather than two, the user's explicit attributes placed
after ours (Vue 3: the later wins). Raw `el$` tags, `template()`, slots
and cells are never rewritten. Values keep Vue's meaning: an R `NULL`
or `NA` is "unset", the component's own default (`undefined` in the
browser); a deliberate `null` -- Element's own `value-on-clear` takes one
-- is `JS("null")`, reachable once props bind through `$optional()`
(`.claude/plans/optional-props-2026-10-26.md`). A change that cannot keep
all of this says which part and why, in its plan, before any code.

**Where a helper lives.** There is no `utils.R` (nor `vue_utils.R`): a
file named for no job collects whatever fits nowhere else. A helper one
component uses lives in that component's file; one several use, in a file
named for its topic -- the Vue layer's `vue_props.R` (unset props),
`vue_args.R` (ids, aliases, choices, camelCase, bookmarks), `vue_markup.R`
(slots, `v-html` strings, the mount point's style), `vue_json.R` (what
travels as JSON), `vue_send.R` (the session check and the queue the
server's messages wait in), `vue_dependencies.R` (the scripts, the
package's files, the per-session memo), `vue_events.R`, `vue_js.R`
(`JS()`); the Element layer's `el_props.R` (props bound and updated),
`el_icon.R`, `el_dates.R` (day.js formats), `el_dependencies.R`,
`el_events.R`, `el_items.R`.

**Splitting is for what code holds, never for its length.** A file is
split when it holds several jobs (`utils.R` did); a function when a part
of it has a job of its own that wants reading or testing apart (the
table's column templates). A long function that reads top to bottom --
arguments checked, attributes, events, data, the widget -- stays one:
most of its length is Element's props, which no split shortens, and
pieces with no job of their own only make the reader jump. Before
splitting, name what the part does that the rest does not; if the answer
is only "it is long", leave it.

### Two kinds of component

**Controls** (input, select, table, form, ...) are Vue apps on a host
element -- one `Vue.createApp()` each, Element Plus installed on each by
`sv.install()` -- built by `el_widget()` (`R/el_widget.R`):

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

**Data components** (`el_table` now; table_v2, tree, transfer to follow)
are outputs in an app: `el_table_output(id)` + `render_el_table(el_table(data
= ...))`. `el_table()` returns a spec object (`.el_component()`,
`R/el_component.R`) drawn by `htmltools::as.tags()`, as htmlwidgets are, so
`el_on()` can pipe events onto it; `.el_resolve()` draws specs inside UI
that code reads as tags. The rendered host is `<id>-el` with
`data-shiny-vue-id=<id>`: the bridge finds it by either. A component
with a value in an output reports `input$<id>` through
`Shiny.setInputValue()` with no binding (`reportFromOutput`), since an
input binding sharing the output's id makes Shiny warn; the table has no
value (`input$<id>` is left free) and reports `_selection_rows`. The
first render sends markup; later renders with the same template and
options send only the changed data fields as JSON
(`.vue_output_value()`, `applyPatch()` in shiny-vue.js), and a page that
cannot apply a patch asks for the markup with `input$<id>__vue_redraw`.
Under `bindCache()` the cache keeps the whole output (`.vue_output_whole()`,
the same for every session, via `cacheWriteHook`) and `cacheReadHook`
compares it with what the session's page has (`.vue_output_send()`).
`el_table_output(loading = TRUE)` shows Element's mask while Shiny
recalculates. The data the table shows is kept per session
(`.el_shown()`, a `reactiveValues()` shared by the data components, read by `el_table_data()` and `el_calendar_events()`): a render writes it only when its own data
changed, an update always -- the rule the browser's patching follows -- so
the `shiny.element.selection` handler returns the right `data[rows, ,
drop = FALSE]`. Editable columns (`el_table_column(editable =)`,
`.el_table_editor()`) apply an edit in the browser at once and on the
server in the `shiny.element.cell_edit` input handler, which converts the
value to the column's type.

### Server to browser

- Updates and method calls are queued per session and sent with the flush,
  in `session$onFlushed()` -- as Shiny's `sendInputMessage()` and DT's and
  leaflet's proxies (`.vue_send()`, `R/vue_send.R`); `flush_vue()` sends
  them at once, `update_el_progress()` is sent at once. A session that
  cannot be asked for a flush (mocks, `testServer()`) is sent to at once.
- `update_el_*()` and `update_vue()` send one custom message,
  `shinyVueUpdate`, a flat `{id, fields..., .action}` (`.vue_send_update()`).
  `.edit` (rows inserted, replaced, deleted by position or key) and `.set`
  (values by path) change a field in place (`update_vue(insert =, ...)`);
  the table and calendar use them.
  The bridge finds the host by id, bound or not -- Shiny's input messages
  reach only bound inputs -- runs `sv.hooks` for dot-keys (`.label`,
  `.error`, `.resolve`), then the component's `shinyVueReceive(data)` if it
  has one (for method calls: form, carousel, tree, upload), then assigns
  declared `$data` fields; an unknown id or field logs `[shiny-vue]`.
- `call_vue()` (and `call_el()`, which adds Element's row/file/node
  references) sends `shinyVueCall` to run a method; a return value comes
  back as `input$<id>_<method>`. `update_vue(value =)` sets the input field;
  updates reach `data` and `setup()` state.
- `render_vue_data()` is an output of a component's data: it renders
  fields by name and the components following it (`vue_app(outputs =
  "id")`) set them as `update_vue()` would -- declared fields only, as Vue
  tracks no others. The bridge places a `.shiny-vue-data-output` element
  per output in the host and binds it (`placeOutputs()`), so it is
  suspended while the component is hidden; `$recalculating.<id>` in
  templates follows its progress. Render functions are built on
  `createRenderFunction()` so they wait for promises.
- `el_calendar(events =, editable =)` is a planner whose events the server
  owns, as toastui's: the user's actions are requests (`_add`, `_update`,
  `_delete`, typed by `shiny.element.cal_event`), answered by
  `update_el_calendar(insert =, replace =, delete =)` by id; the markup is
  the calendar plus a dialog beside it, so its props and slots are put on
  the calendar tag in `.el_calendar_tags()` itself. Like the table it is a
  spec object with an output form (`el_calendar_output()`,
  `render_el_calendar()`); both renders go through
  `.el_render_component()`. Event fields follow Element first (`date`, as
  its day cell names it, `type`, `color`), toastui where Element has none
  (`end`, `title`, `body`, `_update` as `list(event, changes)`).
  Beyond them: times in `date`/`end`, `calendars`, `visible_event_count`,
  `use_detail_popup`, `isReadOnly`, `first_day_of_week` (set on dayjs's
  global locale only while the calendar renders: Element reads it as a
  date table is created) and `workweek`; slots of the events layer's own
  (`event`, `eventForm`, `eventDetail`) are placed by
  `.el_calendar_scoped()` as a one-item `v-for` giving their scope.
- `shinyVue.ask(input, question)` lets a component ask the server (lazy
  loaders, remote search); `el_load_children()` answers through `.resolve`.
- Feedback services (message, notification, message box, loading) use
  `inst/js/el-feedback-handler.js`.
- Every server function takes `session = shiny::getDefaultReactiveDomain()`
  first and calls `.vue_check_session(session)` first.

### Dependency loading

- `el_page()` -- `shiny::fluidPage()` with `el_theme()` (bslib), Vue,
  Element Plus, the bridge, the locale, the global config (`size`, `z_index`)
  and, when the theme changes Element Plus's colours, a `<style>` of its CSS
  variables (`R/el_element_theme.R`, dependency `element-plus-theme`).
- `use_element()` -- the same for other page functions.
- Every component -- control or markup -- carries one set,
  `.el_dependencies()`: the Vue host's (`.vue_host_dependencies()`: jQuery,
  `.vue_core_dependency()`, `.vue_bridge_dependency()`), Element Plus, and
  Element's side of the bridge in one dependency, `shiny-element`
  (`.el_bridge_dependency()`: `el-events.js` and the collapse, tabs and
  overlay bindings), as shinyWidgets keeps its bindings in one file and
  bslib's components share one set. One function per resource, one set
  for all: a new component adds none. Made once per R session
  (`.vue_memo()`). Shiny's inputs carry selectize and htmlwidgets their
  libraries the same way, so a component works on any page and without
  Shiny (static R Markdown); `test-browser-bare-page.R` runs them on a
  `fluidPage()` with neither. htmltools keeps the first copy, so a page
  that loads Element from the CDN keeps it. The theme, locale, global config
  and feedback handlers belong to the page: `el_page()` or `use_element()`.

### Shiny UI inside a template: islands

`.vue_islands()` (`R/vue_app.R`), run by `vue_app()` and `el_widget()`,
takes Shiny UI out of a template -- a tag with a Shiny input's, output's or
htmlwidget's class, a host (`data-shiny-vue`), `data-display-if`, or
`data-shiny-island` (the Element containers carry it) -- into a hidden
holder in the host, and leaves `<shiny-island name="k">`, which the bridge
registers in every app: it moves the UI in when Vue shows it and back out
when Vue removes it. Loose `<script>`/`<style>` go to the holder too.

### Pure tag API

`el` (`R/el_tags.R`) holds a tag generator for every component Element
registers. Raw tags compile only inside a component -- a `template()`, a
slot, a table cell, a wrapper's trigger, `el_widget(markup =)`.

### Naming: arguments and keys

- **R arguments are snake_case**, Element Plus's kebab-case prop names
  turned mechanically (`show-overflow-tooltip` -> `show_overflow_tooltip`).
  No camelCase aliases for them: an alias doubles every signature and help
  page. Two names exist only where Shiny and Element name one concept
  differently (`choices`/`options`, `selected`/`value`).
- **Keys that travel to JavaScript as data accept both spellings**, the
  JavaScript name being the canonical one: column definitions
  (`show_overflow_tooltip` or `showOverflowTooltip`), items, plugin options,
  and the Vue layer's options (`before_unmount` or `beforeUnmount`). Convert
  with `.vue_camel()`; two spellings with different values are an error.
- **Only names the package knows are converted.** Field names in `data`,
  method names, anything a template refers to are the user's and pass
  through exactly as written -- renaming `item_count` would break
  `{{ item_count }}`.

### Shiny input conventions

Every input reports `input$<id>` on load and on change; an empty selection is
`NULL`. Exceptions and extras are documented in each function's "Shiny
inputs" section (`el_table`'s `_selection_change`, `el_form`'s `_valid` and
`_submit`, events as `input$<id>_<event>`).

Two id forms: flat `input$<id>_<name>` for events and states (each observer
fires for its own; event priority works); `input$<id>$<field>` only when
one value has parts (el_form's model, `vue_app(input = c("a", "b"))`).
Event inputs are named after Element's event in snake_case
(`selection-change` -> `_selection_change`); where upstream has no name,
toastui's. A component reports its value, the user's deliberate actions and
the server's requests unasked; Element's other events only when asked for
with `events =` (snake_case, always `input$<id>_<event>`, no renaming).
`on = list(<vue event> = JS("function(report, ...)"))` binds a handler of
the user's own; `report(name, value)` sets `input$<id>_<name>`; on an event
the component handles itself too, `.vue_merge_handlers()` (run by
`el_widget()`) makes the two one handler. The one input not under the
id: `el_cascader(level_inputs =)`, each level of the path under an id the
user gives, as the levels are the value in parts. Every input
of every component is in one registry, `R/el_events_registry.R`, written by
`python tools/events-registry.py` (defaults and value notes there,
descriptions from Element's docs): `el_events()` prints it, every
component's `events` is checked against it, and each help page's "Shiny
inputs" table is generated from it (`` `r .el_events_md("el_x")` ``).
Containers read their reported events from `data-el-events`. The
forwarding itself, its check and `on` are the Vue layer's
(`R/vue_events.R`: `.vue_event_bindings()`, `.vue_events_check()`,
`.vue_on_bindings()`), also behind `vue_app(events =, on =)`. Task buttons
(`el_button(task = TRUE)`) speak bslib's `bslib.taskbutton` protocol. Design
records: `.claude/plans/shiny-style-components-2026-10-06.md`,
`.claude/plans/names-and-events-2026-10-09.md`.

### Adding a new component

**Read `.claude/docs/lessons.md` first.**

1. `R/el_<name>.R`: the component function built with `el_widget()`, and
   `update_el_<name>()` sending `.vue_send_update()`.
2. Optional props go through `.el_props()` and `el_widget(props =)`, which
   binds them on the component's tag as one group,
   `v-bind="$optional('<tag>')"`, with an `NA` placeholder per field so
   they fall back to Element's defaults and stay updatable (`JS("null")`
   is a deliberate `null`). A field named otherwise than its prop, as an
   update already sets it, is `.el_props(fields =)`; a value R gives as
   text is converted by a wrap (`$elDate`, `$elRef`).
3. A stateful component names its value with
   `mounted = .vue_mounted_report(c(<field> = ns_id))`; that field becomes the
   binding's value.
4. Enumerated arguments go in `.el_choices` (`R/el_choices.R`) with
   `.el_check_choices()` first in the function; arguments R reads to draw
   the markup (not fields of the component) in `.vue_unbound()` after it,
   so a `vue_bind()` given them is an error (`test-vue-bind.R` checks).
   A field keeps a binding through its conversions: `.vue_array()`,
   `.vue_flag()` rather than `as.list()`, `isTRUE()`.
5. `roxygen2::roxygenise(".")`, then tests: unit, the browser fixture, and
   **look at a screenshot** (`tools/article-shots.R`).

### Testing

Three layers, each blind to what the next one catches — see lessons.md §5.

| Layer | Where | Catches |
|---|---|---|
| Unit | `test-el_*.R` | HTML generation, message fields, helper logic |
| Browser | `test-browser.R` + `apps/integration.R` | mounting, interaction, geometry, Vue warnings |
| Methods | `test-browser-methods.R` + `apps/methods.R` | every documented method runs on a live component |
| Screenshot | `tools/article-shots.R` | layout and appearance — invisible to the other two |
| Prop reach | `tools/prop-reach.py` + `tools/prop-reach.R` | an argument's value arriving on Element's component instance |
| External props | `tools/external-props.py` + `.csv`, `test-browser-external-props.R` | a prop that arrives and does nothing for want of what it needs -- a router, a locale, Day.js's tokens, a Date or an element from text; each listed with how it is given and the test showing it work |
| Combinations | `tools/combinations.R` + `inst/examples/combinations/` | components put together: folded into one another, in providers and overlays, drawn later -- each app driven step by step |

Browser tests run Vue's development build (`inst/vue3/vue.global.js`,
`el_page(dev = TRUE)`) and assert zero warnings. They skip
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

### Documentation site

The pkgdown site replicates element-plus.org. Component pages are generated:
`tools/demos/<slug>.R` holds the R version of each upstream demo (`## name`
blocks, `#'` prose, `#|` chunk options, `!skip` for prose-only), and
`python tools/ep-pages.py [slug...]` writes
`vignettes/articles/components/<slug>.Rmd` from upstream's markdown and those
demos (color, icon and the overview are hand-written / `tools/ep-overview.py`).
`Rscript tools/article-shots.R [slug...]` screenshots and checks every
example; API coverage is `python tools/api-coverage.py --docs`, then
`Rscript tools/api-coverage.R`, then `python tools/api-coverage.py`
(`--gaps`, `--write-api` for the API tables' JSON with the R name of each
entry, `--write-docs`).

R code is formatted with air (`air.toml`, line width 80): `air format .` for
every .R file but the demos, then `python tools/format-r.py` for the demo
blocks, the hand-written articles' chunks and roxygen `@examples` (it lists
any block air cannot parse), followed by `tools/ep-pages.py` and
`devtools::document()`. `air format --check .` should print nothing.

## Finishing a change

Every round of changes ends the same way, without being asked:

1. verify (tests for what changed, `air format --check .`, and for a
   release-level change the full suites, `R CMD check` and the article
   shots);
2. commit on the working branch, `dev`, and push it. **`main` is not
   touched without the user's word**: it holds the version submitted to
   CRAN (0.3.1) while CRAN reviews it, and the released pkgdown site (the
   root) is built from it. Fixes a reviewer asks for go on `main` when the
   user says so, and `main` is then merged into `dev`; `dev` goes to `main`
   only once CRAN has answered and the user asks. GitHub Actions run on
   pushes to `main` only, so on `dev` the checks are the local ones --
   except pkgdown, as in the tidyverse: `development: mode: auto` puts a
   version with four components (`0.3.1.9000`, `dev`) at `/dev/`, marked
   in-development and not indexed, and a released one (`main`) at the
   root. (`dev` was called `element-plus` until 2026-10-23, from the move
   off Vue 2; GitHub redirects the old name.)
3. install into the user's home library, `R CMD INSTALL --no-multiarch .`,
   and check its `Built:` date -- tests use `load_all()` and pkgdown and
   `R CMD check` install into temporary libraries, so without this the
   user's own `library(shiny.element)` stays on an old build.

### Versions

NEWS.md gets one section per version, newest first; a version is never
reopened. While a round of changes is in progress its entries go under
`# shiny.element (development version)` and DESCRIPTION reads
`X.Y.Z.9000`. Small changes -- fixes, documentation, a new argument --
stay there, collecting. A version is closed only for:
- a large update (a new family of components, a new layer, a redesign
  of how components report or render): the minor one, `0.3.0`;
- an ordinary breaking change (a renamed argument or input, one removed):
  the patch one, `0.2.1`, taking what has collected with it.
Closing sets DESCRIPTION and the NEWS heading and pushes a tag `vX.Y.Z`
with the branch. When it is unclear which a round is, ask. Entries are grouped
under "Breaking changes", "New features", "Bug fixes" and "Documentation".
CRAN gets whichever version is current when the user decides to submit.

### CRAN submission

0.3.1 was submitted on 2026-10-12 (`CRAN-SUBMISSION` records it; tag
`v0.3.1`). Where a submission is in CRAN's queue:

```r
foghorn::cran_incoming("shiny.element")   # its folder and when it got there
foghorn::cran_incoming(folders = "newbies")  # the whole queue for new packages
```

`pretest` is CRAN's automatic check; `newbies` is a first submission
passed it and waiting for a person; `inspect`, `pending`, `waiting` are
under review or waiting on the maintainer; `publish` is accepted. A
package in none of them and not on CRAN is no longer submitted: a
reviewer's request ends a submission, and the fix goes in a new one
(`devtools::submit_cran()`, then the confirmation link in the
maintainer's mail -- the submission counts only once that is done).

A version is closed once CRAN accepts it: a submission sent back by a
reviewer is fixed and resubmitted under the same version, with a
"Resubmission" section at the top of `cran-comments.md` answering each
point, and its tag moved to the fixed commit.

Checking locally (`R CMD check --as-cran`, `R CMD Rd2pdf`): TinyTeX here is
read-only (`/opt/.TinyTeX`), so TeX cannot make the bitmap font the manual
needs and the PDF fails with `Font tctt0900 at 600 not found` -- the
machine, not the Rd. Always give it a writable font cache, recreated each
time as `/tmp` is cleaned:

```bash
mkdir -p /tmp/eco/texmfvar
TEXMFVAR=/tmp/eco/texmfvar R CMD check --as-cran shiny.element_X.Y.Z.tar.gz
```

The other local notes are the container's: no HTML `tidy`, the clock
unverifiable, and an installed size counted larger on overlayfs than on
tmpfs. Build from a clean tree: a worktree's `.git` file and a stray
`Rplots.pdf` go into the tarball (`.Rbuildignore` has `^\.git$`).

## Lessons and gotchas

`.claude/docs/lessons.md` records what was learned the hard way: architectural
constraints that cannot be worked around, Element and Shiny behaviours that
fail silently, and the verification habits that caught them. Read it before
changing how components are built or rendered.

`.claude/docs/screenshot-recipe.R` is the driver template for looking at a page
yourself.

`.claude/docs/bridges-survey.md` is how Shiny itself, bslib, htmlwidgets, vueR,
reactR, shiny.react and shinyreact connect components to Shiny -- read from
their sources, each claim with its evidence -- and how ours compares. Read it
before changing how components render, update or report.
