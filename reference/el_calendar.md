# Element Plus Calendar

A month of days to pick one from, or a range of weeks to show – and,
with `events`, a month planner: each day shows its events, which the
user can add, edit, delete and drag to another day (`editable`).

## Usage

``` r
el_calendar(
  id = NULL,
  value = NULL,
  range = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  controller_type = NULL,
  formatter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL,
  events = NULL,
  editable = FALSE,
  event_labels = NULL
)

update_el_calendar(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  range = NULL,
  label = NULL,
  error = NULL,
  controller_type = NULL,
  formatter = NULL,
  events = NULL,
  insert = NULL,
  replace = NULL,
  delete = NULL,
  editable = NULL,
  event_labels = NULL
)
```

## Arguments

- id:

  Calendar ID (auto-generated if NULL)

- value:

  Bound value (Date/string/number)

- range:

  Date range, c("YYYY-MM-DD", "YYYY-MM-DD")

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- controller_type:

  How the header switches month and year: `"button"` (the default) or
  `"select"`. Element Plus's `controller-type`.

- formatter:

  With `controller_type = "select"`, a
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(value, type)` returning the label of each option.
  Element Plus's `formatter`.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels.

- slots:

  Named list of Element slot contents. `dateCell` renders one day:
  Element hands the template `date` and `data`, so write it with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).
  A default is used when none is given.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

- events:

  The events to show: a data.frame, or a list of rows, with `date`, the
  day (a Date, a date-time or `"YYYY-MM-DD"`), named as Element names
  the day of a cell; optionally `end`, the last day of an event spanning
  several, `title`, `body` (shown on hover), `id` (the row's number when
  absent) – toastui's names, where Element has none – and, from
  Element's tag, `type` (`"primary"`, `"success"`, `"info"`,
  `"warning"`, `"danger"`) or `color`, a background colour of your own.
  Any other column travels with the event and comes back in the inputs.
  In a Shiny app whose events come from the server, render the calendar
  as an output:
  [`el_calendar_output()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md).
  A day cell of your own (`slots = list(dateCell = ...)`) replaces the
  one that draws them; call `eventsOn(data.day)` in it for the day's
  events.

- editable:

  Whether the user can change the events: double-click a day to add one,
  click an event to edit or delete it in a dialog, drag it to another
  day to move it (a span keeps its length).

- event_labels:

  The dialog's words, to change any of: a named list of `add`, `edit`
  (its titles), `title`, `date`, `end`, `type` (its fields), `save`,
  `delete`, `cancel` (its buttons) –
  `list(add = "新建日程", save = "保存")`.

- insert:

  Events to add, each with its `id`.

- replace:

  Events to put in place of those with the same `id`.

- delete:

  The `id`s of events to delete.

## Value

A Shiny UI element.

## Details

The server owns the events, as toastui's calendar has it: what the user
does arrives as a request – `input$<id>_add`, `_update`, `_delete` – and
the calendar changes when the server answers with `update_el_calendar()`
(`insert`, `replace`, `delete`, or all of them with `events`). So the
server can check a change, give a new event its id from a database, or
refuse. Without Shiny – a static page – the calendar applies the user's
changes itself.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | When | Value |
| `input$<id>` | on load and when a day is picked | the day, `"YYYY-MM-DD"` |
| `input$<id>_dates` | on load and when another month is shown | `list(current, start, end)`, Dates: the day the calendar is on and the first and last days drawn |
| `input$<id>_click` | an event is clicked | the event, a list with its dates as Dates |
| `input$<id>_add` | the user saves a new event (`editable`) | the event asked for, without an `id`: `list(date, end, title, type)` |
| `input$<id>_update` | the user saves an edit or drops an event on another day | `list(event, changes)`: the event as it is, and what to change – toastui's shape |
| `input$<id>_delete` | the user deletes an event | the event |

The requests change nothing by themselves: answer them with
`update_el_calendar()`, as the example does.

## Updating from the server

Server-side update for `el_calendar()`: the selected day, the range, and
every other argument that can change once the calendar is drawn, under
the same name. One left `NULL` stays as it is; `NA` returns a prop to
Element's default.

`events` replaces all the events; `insert`, `replace` and `delete`
change a few, found by `id`, and send only those – one of the four per
call.

`update_el_calendar()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# The default day cell
el_calendar("cal")
#> <div id="cal" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cal_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" class="el-calendar--events" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{ data }"><div class="el-calendar-cell" style="height: 100%; display: flex; flex-direction: column; gap: 2px; overflow: hidden;" @dblclick="openAdd(data.day)" @dragover.prevent @drop.prevent="dropOn(data.day)">
#>   <span class="el-calendar-cell__day">{{ Number(data.day.slice(8)) }}</span>
#>   <div class="el-calendar-cell__events" style="flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 2px;">
#>     <el-tag v-for="ev in eventsOn(data.day)" :key="ev.id" :type="ev.type || &#39;primary&#39;" size="small" class="el-calendar-event" style="width: 100%; justify-content: flex-start; cursor: pointer; overflow: hidden;" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="ev.color" :style="eventStyle(ev)" :draggable="editable" @dragstart="dragStart(ev, $event)" @click.stop="clickEvent(ev)">{{ ev.title }}</el-tag>
#>   </div>
#> </div></template></el-calendar>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="420px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="64px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" type="date" value-format="YYYY-MM-DD" :clearable="false" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" type="date" value-format="YYYY-MM-DD" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.title">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-07","range":null,"events":[],"editable":false,"eventForm":null,"eventDragged":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","date":"Date","end":"Until","type":"Type","save":"Save","delete":"Delete","cancel":"Cancel"},"controllerType":null,"formatter":null},"methods":{"eventStyle":"function(ev) { return ev.color ? {borderColor: ev.color, color: 'var(--el-text-color-primary)'} : null; }","eventsOn":"function(day) { return (this.events || []).filter(function(e) { var end = e.end || e.date; return e.date <= day && day <= end; }); }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('cal_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev) { var self = this; self.eventRequest('click', ev); if (self.editable) self.eventForm = Object.assign({}, ev, {end: ev.end || null}); }","openAdd":"function(day) { if (!this.editable) return; this.eventForm = {date: day, end: null, title: '', type: 'primary'}; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.title) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.editable) { e.preventDefault(); return; } this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || old.date === day) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day}; if (old.end) changes.end = fmt(parse(old.end) + shift); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('cal_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"}}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventStyle","options.methods.eventsOn","options.methods.eventRequest","options.methods.clickEvent","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler"]}</script>
#> </div>

# Your own, with whatever Element hands the template
el_calendar(
  "cal",
  slots = list(
    dateCell = template(
      htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
      slot = "dateCell",
      scope = "{date, data}"
    )
  )
)
#> <div id="cal" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cal_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" class="el-calendar--events" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{date, data}"><p>{{ data.day.slice(8) }}</p></template></el-calendar>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="420px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="64px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" type="date" value-format="YYYY-MM-DD" :clearable="false" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" type="date" value-format="YYYY-MM-DD" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.title">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-07","range":null,"events":[],"editable":false,"eventForm":null,"eventDragged":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","date":"Date","end":"Until","type":"Type","save":"Save","delete":"Delete","cancel":"Cancel"},"controllerType":null,"formatter":null},"methods":{"eventStyle":"function(ev) { return ev.color ? {borderColor: ev.color, color: 'var(--el-text-color-primary)'} : null; }","eventsOn":"function(day) { return (this.events || []).filter(function(e) { var end = e.end || e.date; return e.date <= day && day <= end; }); }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('cal_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev) { var self = this; self.eventRequest('click', ev); if (self.editable) self.eventForm = Object.assign({}, ev, {end: ev.end || null}); }","openAdd":"function(day) { if (!this.editable) return; this.eventForm = {date: day, end: null, title: '', type: 'primary'}; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.title) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.editable) { e.preventDefault(); return; } this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || old.date === day) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day}; if (old.end) changes.end = fmt(parse(old.end) + shift); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('cal_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"}}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventStyle","options.methods.eventsOn","options.methods.eventRequest","options.methods.clickEvent","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler"]}</script>
#> </div>
# Basic usage
el_calendar(id = "calendar1", value = Sys.Date())
#> <div id="calendar1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="calendar1_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" class="el-calendar--events" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{ data }"><div class="el-calendar-cell" style="height: 100%; display: flex; flex-direction: column; gap: 2px; overflow: hidden;" @dblclick="openAdd(data.day)" @dragover.prevent @drop.prevent="dropOn(data.day)">
#>   <span class="el-calendar-cell__day">{{ Number(data.day.slice(8)) }}</span>
#>   <div class="el-calendar-cell__events" style="flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 2px;">
#>     <el-tag v-for="ev in eventsOn(data.day)" :key="ev.id" :type="ev.type || &#39;primary&#39;" size="small" class="el-calendar-event" style="width: 100%; justify-content: flex-start; cursor: pointer; overflow: hidden;" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="ev.color" :style="eventStyle(ev)" :draggable="editable" @dragstart="dragStart(ev, $event)" @click.stop="clickEvent(ev)">{{ ev.title }}</el-tag>
#>   </div>
#> </div></template></el-calendar>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="420px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="64px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" type="date" value-format="YYYY-MM-DD" :clearable="false" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" type="date" value-format="YYYY-MM-DD" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.title">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-07","range":null,"events":[],"editable":false,"eventForm":null,"eventDragged":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","date":"Date","end":"Until","type":"Type","save":"Save","delete":"Delete","cancel":"Cancel"},"controllerType":null,"formatter":null},"methods":{"eventStyle":"function(ev) { return ev.color ? {borderColor: ev.color, color: 'var(--el-text-color-primary)'} : null; }","eventsOn":"function(day) { return (this.events || []).filter(function(e) { var end = e.end || e.date; return e.date <= day && day <= end; }); }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('calendar1_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev) { var self = this; self.eventRequest('click', ev); if (self.editable) self.eventForm = Object.assign({}, ev, {end: ev.end || null}); }","openAdd":"function(day) { if (!this.editable) return; this.eventForm = {date: day, end: null, title: '', type: 'primary'}; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.title) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.editable) { e.preventDefault(); return; } this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || old.date === day) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day}; if (old.end) changes.end = fmt(parse(old.end) + shift); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('calendar1_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"}}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventStyle","options.methods.eventsOn","options.methods.eventRequest","options.methods.clickEvent","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler"]}</script>
#> </div>

# With date range
el_calendar(id = "calendar2", range = c("2025-01-01", "2025-01-31"))
#> <div id="calendar2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="calendar2_container" style="display: contents">
#>   <el-calendar ref="calendar" :model-value="elDate(value)" @update:model-value="elPick" class="el-calendar--events" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{ data }"><div class="el-calendar-cell" style="height: 100%; display: flex; flex-direction: column; gap: 2px; overflow: hidden;" @dblclick="openAdd(data.day)" @dragover.prevent @drop.prevent="dropOn(data.day)">
#>   <span class="el-calendar-cell__day">{{ Number(data.day.slice(8)) }}</span>
#>   <div class="el-calendar-cell__events" style="flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 2px;">
#>     <el-tag v-for="ev in eventsOn(data.day)" :key="ev.id" :type="ev.type || &#39;primary&#39;" size="small" class="el-calendar-event" style="width: 100%; justify-content: flex-start; cursor: pointer; overflow: hidden;" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="ev.color" :style="eventStyle(ev)" :draggable="editable" @dragstart="dragStart(ev, $event)" @click.stop="clickEvent(ev)">{{ ev.title }}</el-tag>
#>   </div>
#> </div></template></el-calendar>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="420px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="64px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" type="date" value-format="YYYY-MM-DD" :clearable="false" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" type="date" value-format="YYYY-MM-DD" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.title">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-07","range":["2025-01-01","2025-01-31"],"events":[],"editable":false,"eventForm":null,"eventDragged":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","date":"Date","end":"Until","type":"Type","save":"Save","delete":"Delete","cancel":"Cancel"},"controllerType":null,"formatter":null},"methods":{"eventStyle":"function(ev) { return ev.color ? {borderColor: ev.color, color: 'var(--el-text-color-primary)'} : null; }","eventsOn":"function(day) { return (this.events || []).filter(function(e) { var end = e.end || e.date; return e.date <= day && day <= end; }); }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('calendar2_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev) { var self = this; self.eventRequest('click', ev); if (self.editable) self.eventForm = Object.assign({}, ev, {end: ev.end || null}); }","openAdd":"function(day) { if (!this.editable) return; this.eventForm = {date: day, end: null, title: '', type: 'primary'}; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.title) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.editable) { e.preventDefault(); return; } this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || old.date === day) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day}; if (old.end) changes.end = fmt(parse(old.end) + shift); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('calendar2_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"}}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventStyle","options.methods.eventsOn","options.methods.eventRequest","options.methods.clickEvent","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler"]}</script>
#> </div>

# A planner whose events the server keeps, rendered as an output: each
# request changes them, and the calendar is rendered again -- patched,
# only the events sent
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(el_calendar_output("plan"))
  server <- function(input, output, session) {
    events <- reactiveVal(data.frame(
      id = 1:2,
      date = Sys.Date() + c(0, 3),
      title = c("Standup", "Review"),
      type = c("primary", "warning")
    ))
    output$plan <- render_el_calendar(
      el_calendar(events = events(), editable = TRUE)
    )
    observeEvent(input$plan_add, {
      new <- input$plan_add
      events(rbind(
        events(),
        data.frame(
          id = max(events()$id) + 1L,
          date = new$date,
          title = new$title,
          type = new$type
        )
      ))
    })
    observeEvent(input$plan_update, {
      d <- events()
      i <- d$id == input$plan_update$event$id
      for (k in intersect(names(input$plan_update$changes), names(d))) {
        d[[k]][i] <- input$plan_update$changes[[k]]
      }
      events(d)
    })
    observeEvent(input$plan_delete, {
      events(events()[events()$id != input$plan_delete$id, ])
    })
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_calendar(session, "cal", value = "2026-06-01")
  })
  update_el_calendar(session, "cal", controller_type = "select")
}
```
