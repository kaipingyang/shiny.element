# What works, and what does not

Every component Element Plus 2.14.7 documents is wrapped, and every
documented attribute, event and slot is reachable from R – each
attribute bound to Element Plus’s own prop, or named in a short list of
aliases and exclusions below – and every method is callable by name.
What follows is the small print: the places where this package behaves
differently from Element in a browser, the few things Element Plus does
that R cannot, and why.

Coverage is measured rather than claimed. `tools/api-coverage.R` renders
every component and reads the markup back; `tools/api-coverage.py`
compares that with the API tables in Element’s own documentation. An
argument counts only when the markup binds it to the prop of the same
name; one that merely shares the name does not. Every method is also
run, once, on a live component in a browser test; the few that cannot be
called from R are listed below.

## Where the argument name differs from Element’s

Arguments are snake_case versions of Element Plus’s prop names, with a
few exceptions. Each is deliberate; the rest translate mechanically
(`show-overflow-tooltip` becomes `show_overflow_tooltip`).

| Element | Here | Why |
|----|----|----|
| `default-active` | `active` | It is the current item, and [`update_el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md) changes it – “default” would suggest it is only read once |
| `default-expanded-keys` | `expanded` | As above, for [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md) |
| `default-checked-keys` | `checked` | As above |
| `props` | `label_field`, `children_field`, `disabled_field`, `is_leaf_field`, `class_field` | [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)’s field map is arguments rather than a nested list |
| `data` (upload) | `extra_data` | [`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)’s `data` would read as the file, not the fields sent beside it |
| `width` (popover, popconfirm) | `popover_width`, `popconfirm_width` | Every component takes `width` for its own size; this one sizes the card |
| `props.class` (tree) | `class_field` | As for the other fields of [`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)’s map |
| `#reference` slot (tooltip) | `reference` | The element the tooltip describes, as for [`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md); `trigger` is Element’s own, how it opens |
| `virtual-ref` | `virtual_ref`, a CSS selector | Element takes the element itself, which R cannot send; the selector is looked up in the browser |
| `model-value` | `value`, or `visible` (dialog, drawer), `selected` (tabs), `open` (tour) | `v-model`’s prop is the component’s value, read back as `input$<id>` |
| `width` (watermark, table-v2) | `watermark_width`, `table_v2_width` | As for the popover |
| a prop named like a child’s field | prefixed: `tip_`, `pop_`, `pc_` | A component that absorbs its children keeps their data apart from its own |

### Arguments and the keys inside them

One rule decides how a name is spelled:

- **A function’s arguments are snake_case** – Element Plus’s kebab-case
  props, with `-` turned into `_`. There is no camelCase spelling of
  them; the help pages and autocompletion would list every argument
  twice.
- **A key inside a list that goes to the browser as it is accepts both
  spellings.** The key ends up as a JavaScript property, so its
  JavaScript name is the canonical one and the snake_case one is an
  alias. This is what
  [`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)‘s
  column definitions,
  [`el_descriptions()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions.md)’
  and
  [`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md)’s
  items, and
  [`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)’s
  props do:

``` r

el_table(
  data = mtcars[1:3, 1:2],
  columns = list(
    list(prop = "mpg", show_overflow_tooltip = TRUE), # R's spelling
    list(prop = "cyl", showOverflowTooltip = TRUE) # Element's
  )
)
```

- **Names you choose are never changed.** A field of your own in a
  template’s data, a method’s name, anything a template refers to,
  passes through exactly as written: `{{ item_count }}` needs a field
  called `item_count`, not `itemCount`.

### Two names for the choice components

[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md),
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md)
and
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md)
sit beside
[`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html),
[`radioButtons()`](https://rdrr.io/pkg/shiny/man/radioButtons.html) and
[`checkboxGroupInput()`](https://rdrr.io/pkg/shiny/man/checkboxGroupInput.html),
so they take Shiny’s names – and Element’s as well:

| Shiny’s name | Element’s name | Meaning            |
|--------------|----------------|--------------------|
| `choices`    | `options`      | what can be picked |
| `selected`   | `value`        | what is picked     |

Either works, in the components and in their `update_el_*()`, so code
reads naturally to someone coming from either side:

``` r

el_select(
  "city_shiny",
  choices = c(Beijing = "bj", Shanghai = "sh"),
  selected = "sh"
)
el_select(
  "city_element",
  options = c(Beijing = "bj", Shanghai = "sh"),
  value = "sh"
)
```

The same holds in the server:
`update_el_select(session, "city", selected = "bj")` and
`update_el_select(session, "city", value = "bj")` do one thing.

Given both names in one call, the two must agree; two different values
are an error rather than one quietly winning. The help pages document
each pair as one argument (`selected, value`). No other component has a
second name: everywhere else Shiny and Element already agree on `value`.

A component’s `value` prop is its `v-model`, so it is the `value`
argument where the component has one and the binding elsewhere –
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md)
and
[`el_popover()`](https://kaipingyang.github.io/shiny.element/reference/el_popover.md)
use `value` for whether they are open, which `update_el_*(value =)`
sets.

[`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)’s
`on-success`, `on-error` and `http-request` are taken: they are how
files reach Shiny. The other hooks (`on-change`, `on-progress`,
`before-upload`, …) are yours.

Where a name does differ, the component’s help page documents both.

## Checked arguments

An argument Element takes from a fixed set – a button’s `type`, an
input’s `size`, a tooltip’s `placement` – is checked against that set,
and a value outside it is an error naming the ones that are allowed:

    el_button("go", "Go", type = "primry")
    #> Error: `type` should be one of "default", "primary", "success", "warning",
    #> "danger", "info", "text", not "primry".

Element itself would draw the button in its default style and say
nothing. The sets are read from Element’s documentation, its source and
its stylesheet together, so a value any of them accepts is accepted
here. Matching is exact: `"prim"` is not taken for `"primary"`.

## Containers reimplemented as markup

Tabs, collapse, dialog and drawer are not Element’s Vue components here
but their markup and classes, driven by a Shiny input binding – a Vue
instance over them would recompile the components placed inside and
disconnect them. They follow Element closely:

- stacking, the backdrop, scroll lock, Escape and a click on the
  backdrop go through Element’s own popup manager, so a dialog shares
  one z-index counter with every select, popover and message box, and
  starts where `el_page(z_index =)` says;
- `opened` and `closed` follow the end of Element’s own transitions, and
  a drawer gives focus back to what had it;
- focus stays inside the topmost open dialog or drawer – one opened over
  another included – as Element Plus’s focus trap keeps it: Tab and
  Shift+Tab go round its controls, and focus that lands on the page
  underneath is brought back. Element’s own popups – a select’s
  dropdown, a date picker’s panel – are left alone;
- closed straight after opening, a dialog never reports `opened`: the
  closing cancels the opening, as Vue’s transitions do;
- tabs take the arrow keys and Delete, passing over disabled tabs,
  scroll when they outgrow the bar, and carry Element’s ARIA; a disabled
  tab cannot be closed, and Enter on the “+” adds one; collapse headers
  take Enter and Space, animate open and closed, and carry Element’s
  ARIA.

What remains different: a dialog’s or drawer’s props other than
`visible`, `title`, `width` and `size` are set when the page is built –
there is no reactive data behind them for an update to change – and
anything that reaches into Element’s own component instance, `$refs` on
a dialog say, has no instance to reach.

## Browsers, CSP and the road ahead

Element Plus 2.14.7 on Vue 3.5 is bundled – both under active
development upstream. Each component is its own Vue application, made
with `Vue.createApp()`, so one that fails to mount leaves the rest of
the page working, and a component removed by Shiny unmounts cleanly.

The bridge needs a browser that supports `display: contents`, `:scope`
selectors and regular-expression lookbehind – every current Chrome,
Edge, Firefox and Safari (16.4 and later); not Internet Explorer. A page
with a strict Content-Security-Policy must allow `'unsafe-eval'`: Vue
compiles templates in the browser, and functions given with
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
are evaluated there.

## Writing what Element Plus writes in JavaScript

Element Plus’s own examples build cells, header rows, messages and
spacers with render functions in JSX. The same goes through R:

- **[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  code is evaluated in the browser**, so a prop, a column field or a
  message that upstream builds with `h()` takes
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  code calling `Vue.h()` – with Element Plus’s components as
  `ElementPlus.ElSwitch` and the like. A message whose content changes
  is a function returning the VNode, as upstream says.
- **Slots are templates.** A table’s `cell`, `header-cell` or `row` slot
  is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md),
  and `<component :is="cell" />` draws a cell Element handed the slot –
  merging new props into it, as `cloneVNode()` does.
- **`el_table_v2(methods =)`** gives its slot templates functions of
  your own, so upstream’s row and header functions port across nearly
  line for line.
- **`$setInput(name, value)`** in a template is Shiny’s
  `setInputValue()`, which Vue does not let a template reach: a checkbox
  in a table cell can report the rows ticked.
- **`virtual_ref`** is a CSS selector for the element a tooltip, popover
  or dropdown attaches to; one matching several elements gives them a
  single popup that follows the pointer. The target may come later –
  drawn by [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) –
  or be replaced: the popup attaches to whatever matches when it
  appears.

The table-v2, tree, message-box, notification, space and tooltip pages
show each of these on Element Plus’s own examples.

## What R cannot do

Out of every example in Element Plus’s documentation, one has no R
version:

- **`v-popover`, the directive.** A directive is template syntax on
  another component’s element, and each component here is an application
  of its own. `virtual_ref` does what the directive does: it attaches a
  popover to an element drawn elsewhere.

And a few things are different by construction:

- **A component’s own instance stays in the browser.** Of the 151
  methods Element Plus documents, three take an object only the browser
  can make: the calendar’s `pickDay()` and
  `calculateValidatedDateRange()` take day.js dates – set the day with
  `update_el_calendar(value =)` instead – and the upload’s
  `handleStart()` takes a file the user picked. The objects a component
  already holds are named from R: a table’s rows
  ([`el_table_row()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)),
  an upload’s files
  ([`el_upload_file()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md))
  and a tree’s nodes
  ([`el_tree_node()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)).
  A method’s callback argument is left out: Element’s promise form,
  where it has one, is what
  [`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md)
  uses. The rest are each run in a browser test
  (`test-browser-methods.R`).
- **[`el_config_provider()`](https://kaipingyang.github.io/shiny.element/reference/el_config_provider.md)’s
  `locale`, `z-index` and `namespace` are the page’s:**
  `el_page(locale =, z_index =)`. Every component is an application of
  its own, so a locale cannot be scoped to part of the page; and the
  bundled stylesheet is built for the `el-` namespace. Its other
  settings – `message` included, which reaches
  [`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md)
  – work as upstream’s do.
- **[`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)’s
  `on-success`, `on-error` and `http-request`** are how files reach
  Shiny, so they are taken. Releasing an upload that was interrupted
  reaches into Shiny’s own upload context, for which Shiny has no public
  interface; `test-el_upload.R` checks the installed Shiny still has it,
  and if a future one does not, the partial upload stays until the
  session ends and a warning says so.

## Attributes not bound, and why

`tools/api-coverage.py` lists each upstream attribute not bound to a
prop of its own name, with the reason (`EXCLUDED`, `ALIASES`). They fall
into a few kinds:

- **Owned by a group.** A checkbox or radio inside a group takes its
  value, `true-value`, `false-value` and ARIA from the group, which
  binds them.
- **Deprecated upstream, with the replacement bound.** The
  `auto-complete` spellings of select and input; `popper-append-to-body`
  of autocomplete; the `label` of switch, rate, color picker and time
  picker, which upstream marks as an old name for `aria-label` – here
  `label` is the Shiny label above the control, and `aria_label` is
  bound.
- **Any element’s.** `class`, `style` and `prefix-cls` on space and
  table-v2; `model-modifiers`, which are template syntax.
- **Cross-references.** Rows in upstream’s tables that point to another
  component’s: tree select takes the select’s and the tree’s attributes
  (`...` for those without an argument), popover and popconfirm the
  tooltip’s (`...` likewise).
- **Aliases.** `options` for `choices` in the choice components, drawn
  as child options rather than through the prop; a select’s `props`,
  which renames the fields of its choices in R for the same reason.
- **The page’s.** ConfigProvider’s `locale`, `z-index` and `namespace`,
  as above.

## Other notes

**Element’s i18n covers the component text, not yours.**
`el_page(locale =)` switches Element’s own strings – a date picker’s
month names, a table’s “No Data”. Text you pass in is yours to
translate.

**A component inside a
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) is
re-created, not updated.** That is Shiny’s behaviour rather than this
package’s, but it matters more here: the new instance starts from its
arguments, so anything the user had changed is lost. Prefer
`update_el_*()` where you can.

**A table-v2’s `scrollToRow()` also scrolls it sideways.** In Element
Plus 2.14.7, with `fixed = TRUE` and columns wider than the table, the
default strategy scrolls to the last column when the table was at the
first: the grid behind it is one column as wide as all of them, and the
horizontal position is put back only when it was not zero. Element
Plus’s own demo does the same. Pass a strategy,
`call_el(id = "tbl", method = "scrollToRow", args = list(10, "start"))`,
and the row goes to the top with the columns left where they were.
