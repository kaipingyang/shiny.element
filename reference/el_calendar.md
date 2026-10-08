# Element Plus Calendar

A month of days to pick one from, or a range of weeks to show – and,
with `events`, a month planner: each day shows its events, which the
user can add, edit, delete and drag to another day (`editable`). Days
show times, groups (`calendars`) and a "+N more" beyond
`visible_event_count`; the dialog and the popovers take Element's
components of your own through slots.

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
  event_labels = NULL,
  calendars = NULL,
  visible_event_count = NULL,
  use_detail_popup = FALSE,
  first_day_of_week = NULL,
  workweek = FALSE
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
  event_labels = NULL,
  calendars = NULL,
  visible_event_count = NULL,
  use_detail_popup = NULL,
  first_day_of_week = NULL,
  workweek = NULL
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

  Named list of slot contents. Element's: `dateCell` renders one day –
  Element hands the template `date` and `data`, so write it with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md)
  – and replaces the one that draws the events; call
  `eventsOn(data.day)` in it for the day's events. The events layer's
  own, for Element's components in what it draws: `event`, the content
  of an event's tag (scope `{ event, day }`); `eventForm`, the dialog's
  fields in place of ours (scope `{ form, labels, calendars }`: bind a
  field with `` `v-model` = "form.location" `` and it travels with the
  event in `_add` and `_update`); `eventDetail`, the popover of
  `use_detail_popup` (scope `{ event, labels, calendars }`). Write a
  scope of your own with `template(scope = "{ event }")`.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

- events:

  The events to show: a data.frame, or a list of rows, with `date`, the
  day – a Date or `"YYYY-MM-DD"` – or the time it starts – a date-time
  or `"YYYY-MM-DD HH:MM"` –, named as Element names the day of a cell.
  Optionally, from toastui where Element has no name: `end`, the day or
  time it ends; `title`; `body`, shown on hover and in the popover; `id`
  (the row's number when absent); `calendarId`, its group in
  `calendars`; `isReadOnly`, an event the user cannot change;
  `isVisible = FALSE`, one not shown; `category = "allday"`, times not
  shown. From Element's tag: `type` (`"primary"`, `"success"`, `"info"`,
  `"warning"`, `"danger"`) or `color`, a background colour of your own.
  toastui's camelCase names can be written in snake_case
  (`calendar_id`). Any other column travels with the event and comes
  back in the inputs. A day shows its all-day events first, then the
  others by time, the time before the title. In a Shiny app whose events
  come from the server, render the calendar as an output:
  [`el_calendar_output()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md).

- editable:

  Whether the user can change the events: double-click a day, or drag
  across several, to add one; click an event to edit or delete it in a
  dialog; drag it to another day to move it (its times and a span's
  length kept). An event with `isReadOnly` stays as it is.

- event_labels:

  The dialog's and popovers' words, to change any of: a named list of
  `add`, `edit` (the dialog's titles), `title`, `allday`, `date`, `end`,
  `calendar`, `type`, `body` (its fields), `save`, `delete`, `cancel`
  (its buttons), `more` (the link to a day's hidden events, `{n}` their
  number) –
  `list(add = "新建日程", save = "保存", more = "还有 {n} 项")`.

- calendars:

  Groups of events, toastui's: a data.frame, or a list of rows, with
  `id`, which an event names as its `calendarId`; optionally `name`,
  shown in the dialog and the popover; `type` or `color`, for its events
  with none of their own; `isVisible = FALSE`, its events hidden.

- visible_event_count:

  How many events a day shows; the rest are behind a "+N more" that
  lists them in a popover. `NULL` shows them all, scrolling. toastui's
  `visibleEventCount`.

- use_detail_popup:

  Whether a click on an event the user cannot edit shows it in a
  popover: its title, when, calendar and body, or the `eventDetail`
  slot. toastui's `useDetailPopup`.

- first_day_of_week:

  The day the week starts on, `1` (Monday) to `7` (Sunday), as Element
  UI's `firstDayOfWeek`. `NULL` keeps Element Plus's, which is Sunday.

- workweek:

  Whether to hide Saturday and Sunday, as toastui's `workweek`.

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
| `input$<id>_click` | an event is clicked | the event, a list with its days as Dates and its times as date-times (the time shown, in the R session's time zone) |
| `input$<id>_add` | the user saves a new event (`editable`) | the event asked for, without an `id`: `list(date, end, title, type, body)`, its `calendarId` with `calendars`, and the fields of an `eventForm` slot |
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
call. `calendars` replaces the groups: an `isVisible = FALSE` hides a
group's events, as toastui's `cal_proxy_toggle()` does.

`update_el_calendar()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# The default day cell
el_calendar("cal")
#> <div id="cal" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cal_container" style="display: contents">
#>   <el-calendar ref="calendar" :key="&#39;week-&#39; + weekStart()" :model-value="elDate(value)" @update:model-value="elPick" :class="calendarClass()" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{ data }"><div class="el-calendar-cell" :class="{ &#39;is-selecting&#39;: inSelection(data.day) }" @dblclick="openAdd(data.day)" @mousedown="selectStart(data.day, $event)" @mouseenter="selectMove(data.day)" @dragover.prevent @drop.prevent="dropOn(data.day)">
#>   <div class="el-calendar-cell__head">
#>     <span class="el-calendar-cell__day">{{ Number(data.day.slice(8)) }}</span>
#>     <span v-if="eventsHidden(data.day) &gt; 0" class="el-calendar-more" role="button" tabindex="0" @mousedown.stop @dblclick.stop @click.stop="openMore(data.day, $event)" @keydown.enter.stop="openMore(data.day, $event)">{{ moreLabel(data.day) }}</span>
#>   </div>
#>   <div class="el-calendar-cell__events" :class="{ &#39;is-scrolling&#39;: visibleEventCount === null }">
#>     <el-tag v-for="ev in eventsShown(data.day)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" :draggable="canEdit(ev)" @dragstart="dragStart(ev, $event)" @mousedown.stop @dblclick.stop @click.stop="clickEvent(ev, $event)">{{ eventLabel(ev, data.day) }}</el-tag>
#>   </div>
#> </div></template></el-calendar>
#>   <el-popover :visible="eventMore !== null" :virtual-ref="eventAnchor" virtual-triggering placement="bottom" :width="220" popper-class="el-calendar-popover">
#>     <div v-if="eventMore !== null" class="el-calendar-more__list">
#>       <div class="el-calendar-more__day">{{ eventMore }}</div>
#>       <el-tag v-for="ev in eventsOn(eventMore)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" @click.stop="clickEvent(ev, $event, true)">{{ eventLabel(ev, eventMore) }}</el-tag>
#>     </div>
#>   </el-popover>
#>   <el-popover :visible="eventDetail !== null" :virtual-ref="eventAnchor" virtual-triggering placement="right" :width="260" popper-class="el-calendar-popover">
#>     <div v-if="eventDetail !== null" class="el-calendar-detail">
#>       <div class="el-calendar-detail__title">{{ eventDetail.title }}</div>
#>       <div class="el-calendar-detail__when">{{ eventWhen(eventDetail) }}</div>
#>       <div v-if="eventCalendar(eventDetail)" class="el-calendar-detail__calendar">{{ eventCalendar(eventDetail).name || eventCalendar(eventDetail).id }}</div>
#>       <div v-if="eventDetail.body" class="el-calendar-detail__body">{{ eventDetail.body }}</div>
#>     </div>
#>   </el-popover>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="460px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="72px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.allday">
#>         <el-switch :model-value="isAllday(eventForm)" @update:model-value="setAllday"></el-switch>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%" :clearable="false"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.calendar" v-if="calendars.length">
#>         <el-select v-model="eventForm.calendarId">
#>           <el-option v-for="c in calendars" :key="c.id" :label="c.name || c.id" :value="c.id"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type" :placeholder="eventType(eventForm)">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.body">
#>         <el-input v-model="eventForm.body" type="textarea" :rows="2"></el-input>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.date">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-08","range":null,"events":[],"editable":false,"calendars":[],"visibleEventCount":null,"useDetailPopup":false,"firstDayOfWeek":null,"workweek":false,"eventForm":null,"eventDragged":null,"eventDetail":null,"eventMore":null,"eventAnchor":null,"eventSelect":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","allday":"All day","date":"Date","end":"Until","calendar":"Calendar","type":"Type","body":"Details","save":"Save","delete":"Delete","cancel":"Cancel","more":"+{n} more"},"controllerType":null,"formatter":null},"methods":{"eventCalendar":"function(ev) { if (!ev || ev.calendarId === undefined || ev.calendarId === null) return null; var id = String(ev.calendarId); return (this.calendars || []).filter(function(c) { return String(c.id) === id; })[0] || null; }","eventType":"function(ev) { var c = this.eventCalendar(ev); return ev.type || (c && c.type) || 'primary'; }","eventColor":"function(ev) { var c = this.eventCalendar(ev); return ev.color || (c && c.color) || undefined; }","eventStyle":"function(ev) { var col = this.eventColor(ev); return col ? {borderColor: col, color: 'var(--el-text-color-primary)'} : null; }","eventLabel":"function(ev, day) { var d = String(ev.date); return (d.length > 10 && d.slice(0, 10) === day ? d.slice(11, 16) + ' ' : '') + (ev.title || ''); }","eventWhen":"function(ev) { if (!ev) return ''; var d = String(ev.date), e = ev.end ? String(ev.end) : ''; if (!e) return d; return d + ' – ' + (e.slice(0, 10) === d.slice(0, 10) ? e.slice(11) : e); }","eventsOn":"function(day) { var self = this; var on = (self.events || []).filter(function(e) { if (e.isVisible === false) return false; var c = self.eventCalendar(e); if (c && c.isVisible === false) return false; var start = String(e.date).slice(0, 10), end = e.end ? String(e.end).slice(0, 10) : start; return start <= day && day <= end; }); var key = function(e) { var d = String(e.date); return d.length > 10 && d.slice(0, 10) === day ? d.slice(11) : ''; }; return on.map(function(e, i) { return [e, i]; }).sort(function(a, b) { var ka = key(a[0]), kb = key(b[0]); return ka < kb ? -1 : ka > kb ? 1 : a[1] - b[1]; }).map(function(p) { return p[0]; }); }","eventsShown":"function(day) { var all = this.eventsOn(day), n = this.visibleEventCount; return n && all.length > n ? all.slice(0, n) : all; }","eventsHidden":"function(day) { var n = this.visibleEventCount; if (!n) return 0; return Math.max(0, this.eventsOn(day).length - n); }","moreLabel":"function(day) { return String(this.eventLabels.more).replace('{n}', this.eventsHidden(day)); }","canEdit":"function(ev) { return !!this.editable && !ev.isReadOnly; }","isAllday":"function(f) { return !f || !f.date || String(f.date).length <= 10; }","setAllday":"function(on) { var f = this.eventForm; if (!f || !f.date) return; var day = function(s) { return String(s).slice(0, 10); }; if (on) { f.date = day(f.date); if (f.end) f.end = day(f.end); } else { f.date = day(f.date) + ' 09:00'; if (f.end) f.end = day(f.end) + ' 10:00'; } }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('cal_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev, e, fromMore) { var self = this; self.eventRequest('click', ev); var anchor = fromMore ? self.eventAnchor : (e && e.currentTarget) || null; self.closePopovers(); if (self.canEdit(ev)) { self.eventForm = Object.assign({}, ev, {end: ev.end || null}); return; } if (self.useDetailPopup && anchor) { self.eventAnchor = anchor; self.eventDetail = ev; self.listenOutside(); } }","openMore":"function(day, e) { this.closePopovers(); this.eventAnchor = e.currentTarget; this.eventMore = day; this.listenOutside(); }","closePopovers":"function() { this.eventMore = null; this.eventDetail = null; }","listenOutside":"function() { var self = this; if (self._outside) return; var off = function() { document.removeEventListener('mousedown', down, true); document.removeEventListener('keydown', key, true); self._outside = null; }; var down = function(e) { var t = e.target; if (t.closest && (t.closest('.el-calendar-popover') || t === self.eventAnchor)) return; self.closePopovers(); off(); }; var key = function(e) { if (e.key === 'Escape') { self.closePopovers(); off(); } }; self._outside = off; document.addEventListener('mousedown', down, true); document.addEventListener('keydown', key, true); }","openAdd":"function(day, end) { if (!this.editable) return; this.closePopovers(); var f = {date: day, end: end && end !== day ? end : null, title: '', type: 'primary', body: ''}; if (this.calendars && this.calendars.length) f.calendarId = this.calendars[0].id; this.eventForm = f; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.date) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.canEdit(ev)) { e.preventDefault(); return; } this.closePopovers(); this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || String(old.date).slice(0, 10) === day) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day + String(old.date).slice(10)}; if (old.end) changes.end = fmt(parse(old.end) + shift) + String(old.end).slice(10); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","selectStart":"function(day, e) { var self = this; if (!self.editable || e.button !== 0) return; self.eventSelect = {from: day, to: day}; var up = function() { document.removeEventListener('mouseup', up, true); self.selectEnd(); }; document.addEventListener('mouseup', up, true); }","selectMove":"function(day) { if (this.eventSelect) this.eventSelect.to = day; }","selectEnd":"function() { var s = this.eventSelect; this.eventSelect = null; if (!s || s.from === s.to) return; this.openAdd(s.from < s.to ? s.from : s.to, s.from < s.to ? s.to : s.from); }","inSelection":"function(day) { var s = this.eventSelect; if (!s || s.from === s.to) return false; var a = s.from < s.to ? s.from : s.to, b = s.from < s.to ? s.to : s.from; return a <= day && day <= b; }","weekStart":"function() { var dj = window.ElementPlus && ElementPlus.dayjs; var fdw = this.firstDayOfWeek; if (!dj) return fdw === null || fdw === undefined ? 0 : fdw; var loc = dj.Ls && dj.Ls[dj.locale()]; if (fdw === null || fdw === undefined || !loc) return dj.localeData ? dj.localeData().firstDayOfWeek() : 0; var had = Object.prototype.hasOwnProperty.call(loc, 'weekStart'), old = loc.weekStart; loc.weekStart = fdw; Promise.resolve().then(function() { if (had) loc.weekStart = old; else delete loc.weekStart; }); return fdw; }","calendarClass":"function() { var out = ['el-calendar--events']; if (!this.workweek) return out; var s = this.firstDayOfWeek; if (s === null || s === undefined) { var dj = window.ElementPlus && ElementPlus.dayjs; s = dj && dj.localeData ? dj.localeData().firstDayOfWeek() : 0; } [0, 6].forEach(function(w) { out.push('is-hide-col-' + (((w - s + 7) % 7) + 1)); }); return out; }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('cal_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"},"firstDayOfWeek":"function() { this.reportDates(); }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventCalendar","options.methods.eventType","options.methods.eventColor","options.methods.eventStyle","options.methods.eventLabel","options.methods.eventWhen","options.methods.eventsOn","options.methods.eventsShown","options.methods.eventsHidden","options.methods.moreLabel","options.methods.canEdit","options.methods.isAllday","options.methods.setAllday","options.methods.eventRequest","options.methods.clickEvent","options.methods.openMore","options.methods.closePopovers","options.methods.listenOutside","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.selectStart","options.methods.selectMove","options.methods.selectEnd","options.methods.inSelection","options.methods.weekStart","options.methods.calendarClass","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler","options.watch.firstDayOfWeek"]}</script>
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
#>   <el-calendar ref="calendar" :key="&#39;week-&#39; + weekStart()" :model-value="elDate(value)" @update:model-value="elPick" :class="calendarClass()" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{date, data}"><p>{{ data.day.slice(8) }}</p></template></el-calendar>
#>   <el-popover :visible="eventMore !== null" :virtual-ref="eventAnchor" virtual-triggering placement="bottom" :width="220" popper-class="el-calendar-popover">
#>     <div v-if="eventMore !== null" class="el-calendar-more__list">
#>       <div class="el-calendar-more__day">{{ eventMore }}</div>
#>       <el-tag v-for="ev in eventsOn(eventMore)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" @click.stop="clickEvent(ev, $event, true)">{{ eventLabel(ev, eventMore) }}</el-tag>
#>     </div>
#>   </el-popover>
#>   <el-popover :visible="eventDetail !== null" :virtual-ref="eventAnchor" virtual-triggering placement="right" :width="260" popper-class="el-calendar-popover">
#>     <div v-if="eventDetail !== null" class="el-calendar-detail">
#>       <div class="el-calendar-detail__title">{{ eventDetail.title }}</div>
#>       <div class="el-calendar-detail__when">{{ eventWhen(eventDetail) }}</div>
#>       <div v-if="eventCalendar(eventDetail)" class="el-calendar-detail__calendar">{{ eventCalendar(eventDetail).name || eventCalendar(eventDetail).id }}</div>
#>       <div v-if="eventDetail.body" class="el-calendar-detail__body">{{ eventDetail.body }}</div>
#>     </div>
#>   </el-popover>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="460px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="72px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.allday">
#>         <el-switch :model-value="isAllday(eventForm)" @update:model-value="setAllday"></el-switch>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%" :clearable="false"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.calendar" v-if="calendars.length">
#>         <el-select v-model="eventForm.calendarId">
#>           <el-option v-for="c in calendars" :key="c.id" :label="c.name || c.id" :value="c.id"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type" :placeholder="eventType(eventForm)">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.body">
#>         <el-input v-model="eventForm.body" type="textarea" :rows="2"></el-input>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.date">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-08","range":null,"events":[],"editable":false,"calendars":[],"visibleEventCount":null,"useDetailPopup":false,"firstDayOfWeek":null,"workweek":false,"eventForm":null,"eventDragged":null,"eventDetail":null,"eventMore":null,"eventAnchor":null,"eventSelect":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","allday":"All day","date":"Date","end":"Until","calendar":"Calendar","type":"Type","body":"Details","save":"Save","delete":"Delete","cancel":"Cancel","more":"+{n} more"},"controllerType":null,"formatter":null},"methods":{"eventCalendar":"function(ev) { if (!ev || ev.calendarId === undefined || ev.calendarId === null) return null; var id = String(ev.calendarId); return (this.calendars || []).filter(function(c) { return String(c.id) === id; })[0] || null; }","eventType":"function(ev) { var c = this.eventCalendar(ev); return ev.type || (c && c.type) || 'primary'; }","eventColor":"function(ev) { var c = this.eventCalendar(ev); return ev.color || (c && c.color) || undefined; }","eventStyle":"function(ev) { var col = this.eventColor(ev); return col ? {borderColor: col, color: 'var(--el-text-color-primary)'} : null; }","eventLabel":"function(ev, day) { var d = String(ev.date); return (d.length > 10 && d.slice(0, 10) === day ? d.slice(11, 16) + ' ' : '') + (ev.title || ''); }","eventWhen":"function(ev) { if (!ev) return ''; var d = String(ev.date), e = ev.end ? String(ev.end) : ''; if (!e) return d; return d + ' – ' + (e.slice(0, 10) === d.slice(0, 10) ? e.slice(11) : e); }","eventsOn":"function(day) { var self = this; var on = (self.events || []).filter(function(e) { if (e.isVisible === false) return false; var c = self.eventCalendar(e); if (c && c.isVisible === false) return false; var start = String(e.date).slice(0, 10), end = e.end ? String(e.end).slice(0, 10) : start; return start <= day && day <= end; }); var key = function(e) { var d = String(e.date); return d.length > 10 && d.slice(0, 10) === day ? d.slice(11) : ''; }; return on.map(function(e, i) { return [e, i]; }).sort(function(a, b) { var ka = key(a[0]), kb = key(b[0]); return ka < kb ? -1 : ka > kb ? 1 : a[1] - b[1]; }).map(function(p) { return p[0]; }); }","eventsShown":"function(day) { var all = this.eventsOn(day), n = this.visibleEventCount; return n && all.length > n ? all.slice(0, n) : all; }","eventsHidden":"function(day) { var n = this.visibleEventCount; if (!n) return 0; return Math.max(0, this.eventsOn(day).length - n); }","moreLabel":"function(day) { return String(this.eventLabels.more).replace('{n}', this.eventsHidden(day)); }","canEdit":"function(ev) { return !!this.editable && !ev.isReadOnly; }","isAllday":"function(f) { return !f || !f.date || String(f.date).length <= 10; }","setAllday":"function(on) { var f = this.eventForm; if (!f || !f.date) return; var day = function(s) { return String(s).slice(0, 10); }; if (on) { f.date = day(f.date); if (f.end) f.end = day(f.end); } else { f.date = day(f.date) + ' 09:00'; if (f.end) f.end = day(f.end) + ' 10:00'; } }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('cal_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev, e, fromMore) { var self = this; self.eventRequest('click', ev); var anchor = fromMore ? self.eventAnchor : (e && e.currentTarget) || null; self.closePopovers(); if (self.canEdit(ev)) { self.eventForm = Object.assign({}, ev, {end: ev.end || null}); return; } if (self.useDetailPopup && anchor) { self.eventAnchor = anchor; self.eventDetail = ev; self.listenOutside(); } }","openMore":"function(day, e) { this.closePopovers(); this.eventAnchor = e.currentTarget; this.eventMore = day; this.listenOutside(); }","closePopovers":"function() { this.eventMore = null; this.eventDetail = null; }","listenOutside":"function() { var self = this; if (self._outside) return; var off = function() { document.removeEventListener('mousedown', down, true); document.removeEventListener('keydown', key, true); self._outside = null; }; var down = function(e) { var t = e.target; if (t.closest && (t.closest('.el-calendar-popover') || t === self.eventAnchor)) return; self.closePopovers(); off(); }; var key = function(e) { if (e.key === 'Escape') { self.closePopovers(); off(); } }; self._outside = off; document.addEventListener('mousedown', down, true); document.addEventListener('keydown', key, true); }","openAdd":"function(day, end) { if (!this.editable) return; this.closePopovers(); var f = {date: day, end: end && end !== day ? end : null, title: '', type: 'primary', body: ''}; if (this.calendars && this.calendars.length) f.calendarId = this.calendars[0].id; this.eventForm = f; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.date) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.canEdit(ev)) { e.preventDefault(); return; } this.closePopovers(); this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || String(old.date).slice(0, 10) === day) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day + String(old.date).slice(10)}; if (old.end) changes.end = fmt(parse(old.end) + shift) + String(old.end).slice(10); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","selectStart":"function(day, e) { var self = this; if (!self.editable || e.button !== 0) return; self.eventSelect = {from: day, to: day}; var up = function() { document.removeEventListener('mouseup', up, true); self.selectEnd(); }; document.addEventListener('mouseup', up, true); }","selectMove":"function(day) { if (this.eventSelect) this.eventSelect.to = day; }","selectEnd":"function() { var s = this.eventSelect; this.eventSelect = null; if (!s || s.from === s.to) return; this.openAdd(s.from < s.to ? s.from : s.to, s.from < s.to ? s.to : s.from); }","inSelection":"function(day) { var s = this.eventSelect; if (!s || s.from === s.to) return false; var a = s.from < s.to ? s.from : s.to, b = s.from < s.to ? s.to : s.from; return a <= day && day <= b; }","weekStart":"function() { var dj = window.ElementPlus && ElementPlus.dayjs; var fdw = this.firstDayOfWeek; if (!dj) return fdw === null || fdw === undefined ? 0 : fdw; var loc = dj.Ls && dj.Ls[dj.locale()]; if (fdw === null || fdw === undefined || !loc) return dj.localeData ? dj.localeData().firstDayOfWeek() : 0; var had = Object.prototype.hasOwnProperty.call(loc, 'weekStart'), old = loc.weekStart; loc.weekStart = fdw; Promise.resolve().then(function() { if (had) loc.weekStart = old; else delete loc.weekStart; }); return fdw; }","calendarClass":"function() { var out = ['el-calendar--events']; if (!this.workweek) return out; var s = this.firstDayOfWeek; if (s === null || s === undefined) { var dj = window.ElementPlus && ElementPlus.dayjs; s = dj && dj.localeData ? dj.localeData().firstDayOfWeek() : 0; } [0, 6].forEach(function(w) { out.push('is-hide-col-' + (((w - s + 7) % 7) + 1)); }); return out; }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('cal_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"},"firstDayOfWeek":"function() { this.reportDates(); }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventCalendar","options.methods.eventType","options.methods.eventColor","options.methods.eventStyle","options.methods.eventLabel","options.methods.eventWhen","options.methods.eventsOn","options.methods.eventsShown","options.methods.eventsHidden","options.methods.moreLabel","options.methods.canEdit","options.methods.isAllday","options.methods.setAllday","options.methods.eventRequest","options.methods.clickEvent","options.methods.openMore","options.methods.closePopovers","options.methods.listenOutside","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.selectStart","options.methods.selectMove","options.methods.selectEnd","options.methods.inSelection","options.methods.weekStart","options.methods.calendarClass","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler","options.watch.firstDayOfWeek"]}</script>
#> </div>
# Basic usage
el_calendar(id = "calendar1", value = Sys.Date())
#> <div id="calendar1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="calendar1_container" style="display: contents">
#>   <el-calendar ref="calendar" :key="&#39;week-&#39; + weekStart()" :model-value="elDate(value)" @update:model-value="elPick" :class="calendarClass()" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{ data }"><div class="el-calendar-cell" :class="{ &#39;is-selecting&#39;: inSelection(data.day) }" @dblclick="openAdd(data.day)" @mousedown="selectStart(data.day, $event)" @mouseenter="selectMove(data.day)" @dragover.prevent @drop.prevent="dropOn(data.day)">
#>   <div class="el-calendar-cell__head">
#>     <span class="el-calendar-cell__day">{{ Number(data.day.slice(8)) }}</span>
#>     <span v-if="eventsHidden(data.day) &gt; 0" class="el-calendar-more" role="button" tabindex="0" @mousedown.stop @dblclick.stop @click.stop="openMore(data.day, $event)" @keydown.enter.stop="openMore(data.day, $event)">{{ moreLabel(data.day) }}</span>
#>   </div>
#>   <div class="el-calendar-cell__events" :class="{ &#39;is-scrolling&#39;: visibleEventCount === null }">
#>     <el-tag v-for="ev in eventsShown(data.day)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" :draggable="canEdit(ev)" @dragstart="dragStart(ev, $event)" @mousedown.stop @dblclick.stop @click.stop="clickEvent(ev, $event)">{{ eventLabel(ev, data.day) }}</el-tag>
#>   </div>
#> </div></template></el-calendar>
#>   <el-popover :visible="eventMore !== null" :virtual-ref="eventAnchor" virtual-triggering placement="bottom" :width="220" popper-class="el-calendar-popover">
#>     <div v-if="eventMore !== null" class="el-calendar-more__list">
#>       <div class="el-calendar-more__day">{{ eventMore }}</div>
#>       <el-tag v-for="ev in eventsOn(eventMore)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" @click.stop="clickEvent(ev, $event, true)">{{ eventLabel(ev, eventMore) }}</el-tag>
#>     </div>
#>   </el-popover>
#>   <el-popover :visible="eventDetail !== null" :virtual-ref="eventAnchor" virtual-triggering placement="right" :width="260" popper-class="el-calendar-popover">
#>     <div v-if="eventDetail !== null" class="el-calendar-detail">
#>       <div class="el-calendar-detail__title">{{ eventDetail.title }}</div>
#>       <div class="el-calendar-detail__when">{{ eventWhen(eventDetail) }}</div>
#>       <div v-if="eventCalendar(eventDetail)" class="el-calendar-detail__calendar">{{ eventCalendar(eventDetail).name || eventCalendar(eventDetail).id }}</div>
#>       <div v-if="eventDetail.body" class="el-calendar-detail__body">{{ eventDetail.body }}</div>
#>     </div>
#>   </el-popover>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="460px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="72px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.allday">
#>         <el-switch :model-value="isAllday(eventForm)" @update:model-value="setAllday"></el-switch>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%" :clearable="false"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.calendar" v-if="calendars.length">
#>         <el-select v-model="eventForm.calendarId">
#>           <el-option v-for="c in calendars" :key="c.id" :label="c.name || c.id" :value="c.id"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type" :placeholder="eventType(eventForm)">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.body">
#>         <el-input v-model="eventForm.body" type="textarea" :rows="2"></el-input>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.date">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-08","range":null,"events":[],"editable":false,"calendars":[],"visibleEventCount":null,"useDetailPopup":false,"firstDayOfWeek":null,"workweek":false,"eventForm":null,"eventDragged":null,"eventDetail":null,"eventMore":null,"eventAnchor":null,"eventSelect":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","allday":"All day","date":"Date","end":"Until","calendar":"Calendar","type":"Type","body":"Details","save":"Save","delete":"Delete","cancel":"Cancel","more":"+{n} more"},"controllerType":null,"formatter":null},"methods":{"eventCalendar":"function(ev) { if (!ev || ev.calendarId === undefined || ev.calendarId === null) return null; var id = String(ev.calendarId); return (this.calendars || []).filter(function(c) { return String(c.id) === id; })[0] || null; }","eventType":"function(ev) { var c = this.eventCalendar(ev); return ev.type || (c && c.type) || 'primary'; }","eventColor":"function(ev) { var c = this.eventCalendar(ev); return ev.color || (c && c.color) || undefined; }","eventStyle":"function(ev) { var col = this.eventColor(ev); return col ? {borderColor: col, color: 'var(--el-text-color-primary)'} : null; }","eventLabel":"function(ev, day) { var d = String(ev.date); return (d.length > 10 && d.slice(0, 10) === day ? d.slice(11, 16) + ' ' : '') + (ev.title || ''); }","eventWhen":"function(ev) { if (!ev) return ''; var d = String(ev.date), e = ev.end ? String(ev.end) : ''; if (!e) return d; return d + ' – ' + (e.slice(0, 10) === d.slice(0, 10) ? e.slice(11) : e); }","eventsOn":"function(day) { var self = this; var on = (self.events || []).filter(function(e) { if (e.isVisible === false) return false; var c = self.eventCalendar(e); if (c && c.isVisible === false) return false; var start = String(e.date).slice(0, 10), end = e.end ? String(e.end).slice(0, 10) : start; return start <= day && day <= end; }); var key = function(e) { var d = String(e.date); return d.length > 10 && d.slice(0, 10) === day ? d.slice(11) : ''; }; return on.map(function(e, i) { return [e, i]; }).sort(function(a, b) { var ka = key(a[0]), kb = key(b[0]); return ka < kb ? -1 : ka > kb ? 1 : a[1] - b[1]; }).map(function(p) { return p[0]; }); }","eventsShown":"function(day) { var all = this.eventsOn(day), n = this.visibleEventCount; return n && all.length > n ? all.slice(0, n) : all; }","eventsHidden":"function(day) { var n = this.visibleEventCount; if (!n) return 0; return Math.max(0, this.eventsOn(day).length - n); }","moreLabel":"function(day) { return String(this.eventLabels.more).replace('{n}', this.eventsHidden(day)); }","canEdit":"function(ev) { return !!this.editable && !ev.isReadOnly; }","isAllday":"function(f) { return !f || !f.date || String(f.date).length <= 10; }","setAllday":"function(on) { var f = this.eventForm; if (!f || !f.date) return; var day = function(s) { return String(s).slice(0, 10); }; if (on) { f.date = day(f.date); if (f.end) f.end = day(f.end); } else { f.date = day(f.date) + ' 09:00'; if (f.end) f.end = day(f.end) + ' 10:00'; } }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('calendar1_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev, e, fromMore) { var self = this; self.eventRequest('click', ev); var anchor = fromMore ? self.eventAnchor : (e && e.currentTarget) || null; self.closePopovers(); if (self.canEdit(ev)) { self.eventForm = Object.assign({}, ev, {end: ev.end || null}); return; } if (self.useDetailPopup && anchor) { self.eventAnchor = anchor; self.eventDetail = ev; self.listenOutside(); } }","openMore":"function(day, e) { this.closePopovers(); this.eventAnchor = e.currentTarget; this.eventMore = day; this.listenOutside(); }","closePopovers":"function() { this.eventMore = null; this.eventDetail = null; }","listenOutside":"function() { var self = this; if (self._outside) return; var off = function() { document.removeEventListener('mousedown', down, true); document.removeEventListener('keydown', key, true); self._outside = null; }; var down = function(e) { var t = e.target; if (t.closest && (t.closest('.el-calendar-popover') || t === self.eventAnchor)) return; self.closePopovers(); off(); }; var key = function(e) { if (e.key === 'Escape') { self.closePopovers(); off(); } }; self._outside = off; document.addEventListener('mousedown', down, true); document.addEventListener('keydown', key, true); }","openAdd":"function(day, end) { if (!this.editable) return; this.closePopovers(); var f = {date: day, end: end && end !== day ? end : null, title: '', type: 'primary', body: ''}; if (this.calendars && this.calendars.length) f.calendarId = this.calendars[0].id; this.eventForm = f; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.date) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.canEdit(ev)) { e.preventDefault(); return; } this.closePopovers(); this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || String(old.date).slice(0, 10) === day) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day + String(old.date).slice(10)}; if (old.end) changes.end = fmt(parse(old.end) + shift) + String(old.end).slice(10); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","selectStart":"function(day, e) { var self = this; if (!self.editable || e.button !== 0) return; self.eventSelect = {from: day, to: day}; var up = function() { document.removeEventListener('mouseup', up, true); self.selectEnd(); }; document.addEventListener('mouseup', up, true); }","selectMove":"function(day) { if (this.eventSelect) this.eventSelect.to = day; }","selectEnd":"function() { var s = this.eventSelect; this.eventSelect = null; if (!s || s.from === s.to) return; this.openAdd(s.from < s.to ? s.from : s.to, s.from < s.to ? s.to : s.from); }","inSelection":"function(day) { var s = this.eventSelect; if (!s || s.from === s.to) return false; var a = s.from < s.to ? s.from : s.to, b = s.from < s.to ? s.to : s.from; return a <= day && day <= b; }","weekStart":"function() { var dj = window.ElementPlus && ElementPlus.dayjs; var fdw = this.firstDayOfWeek; if (!dj) return fdw === null || fdw === undefined ? 0 : fdw; var loc = dj.Ls && dj.Ls[dj.locale()]; if (fdw === null || fdw === undefined || !loc) return dj.localeData ? dj.localeData().firstDayOfWeek() : 0; var had = Object.prototype.hasOwnProperty.call(loc, 'weekStart'), old = loc.weekStart; loc.weekStart = fdw; Promise.resolve().then(function() { if (had) loc.weekStart = old; else delete loc.weekStart; }); return fdw; }","calendarClass":"function() { var out = ['el-calendar--events']; if (!this.workweek) return out; var s = this.firstDayOfWeek; if (s === null || s === undefined) { var dj = window.ElementPlus && ElementPlus.dayjs; s = dj && dj.localeData ? dj.localeData().firstDayOfWeek() : 0; } [0, 6].forEach(function(w) { out.push('is-hide-col-' + (((w - s + 7) % 7) + 1)); }); return out; }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('calendar1_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"},"firstDayOfWeek":"function() { this.reportDates(); }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventCalendar","options.methods.eventType","options.methods.eventColor","options.methods.eventStyle","options.methods.eventLabel","options.methods.eventWhen","options.methods.eventsOn","options.methods.eventsShown","options.methods.eventsHidden","options.methods.moreLabel","options.methods.canEdit","options.methods.isAllday","options.methods.setAllday","options.methods.eventRequest","options.methods.clickEvent","options.methods.openMore","options.methods.closePopovers","options.methods.listenOutside","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.selectStart","options.methods.selectMove","options.methods.selectEnd","options.methods.inSelection","options.methods.weekStart","options.methods.calendarClass","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler","options.watch.firstDayOfWeek"]}</script>
#> </div>

# With date range
el_calendar(id = "calendar2", range = c("2025-01-01", "2025-01-31"))
#> <div id="calendar2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="calendar2_container" style="display: contents">
#>   <el-calendar ref="calendar" :key="&#39;week-&#39; + weekStart()" :model-value="elDate(value)" @update:model-value="elPick" :class="calendarClass()" :range="range === null ? undefined : range.map(elDate)" :controller-type="controllerType === null ? undefined : controllerType" :formatter="formatter === null ? undefined : formatter"><template v-slot:date-cell="{ data }"><div class="el-calendar-cell" :class="{ &#39;is-selecting&#39;: inSelection(data.day) }" @dblclick="openAdd(data.day)" @mousedown="selectStart(data.day, $event)" @mouseenter="selectMove(data.day)" @dragover.prevent @drop.prevent="dropOn(data.day)">
#>   <div class="el-calendar-cell__head">
#>     <span class="el-calendar-cell__day">{{ Number(data.day.slice(8)) }}</span>
#>     <span v-if="eventsHidden(data.day) &gt; 0" class="el-calendar-more" role="button" tabindex="0" @mousedown.stop @dblclick.stop @click.stop="openMore(data.day, $event)" @keydown.enter.stop="openMore(data.day, $event)">{{ moreLabel(data.day) }}</span>
#>   </div>
#>   <div class="el-calendar-cell__events" :class="{ &#39;is-scrolling&#39;: visibleEventCount === null }">
#>     <el-tag v-for="ev in eventsShown(data.day)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" :draggable="canEdit(ev)" @dragstart="dragStart(ev, $event)" @mousedown.stop @dblclick.stop @click.stop="clickEvent(ev, $event)">{{ eventLabel(ev, data.day) }}</el-tag>
#>   </div>
#> </div></template></el-calendar>
#>   <el-popover :visible="eventMore !== null" :virtual-ref="eventAnchor" virtual-triggering placement="bottom" :width="220" popper-class="el-calendar-popover">
#>     <div v-if="eventMore !== null" class="el-calendar-more__list">
#>       <div class="el-calendar-more__day">{{ eventMore }}</div>
#>       <el-tag v-for="ev in eventsOn(eventMore)" :key="ev.id" :type="eventType(ev)" size="small" class="el-calendar-event" :title="ev.body || ev.title" :aria-label="ev.title || ev.body || ev.date" :color="eventColor(ev)" :style="eventStyle(ev)" @click.stop="clickEvent(ev, $event, true)">{{ eventLabel(ev, eventMore) }}</el-tag>
#>     </div>
#>   </el-popover>
#>   <el-popover :visible="eventDetail !== null" :virtual-ref="eventAnchor" virtual-triggering placement="right" :width="260" popper-class="el-calendar-popover">
#>     <div v-if="eventDetail !== null" class="el-calendar-detail">
#>       <div class="el-calendar-detail__title">{{ eventDetail.title }}</div>
#>       <div class="el-calendar-detail__when">{{ eventWhen(eventDetail) }}</div>
#>       <div v-if="eventCalendar(eventDetail)" class="el-calendar-detail__calendar">{{ eventCalendar(eventDetail).name || eventCalendar(eventDetail).id }}</div>
#>       <div v-if="eventDetail.body" class="el-calendar-detail__body">{{ eventDetail.body }}</div>
#>     </div>
#>   </el-popover>
#>   <el-dialog :model-value="eventForm !== null" @update:model-value="$event || cancelEvent()" :title="eventForm &amp;&amp; eventForm.id !== undefined ? eventLabels.edit : eventLabels.add" width="460px" append-to-body class="el-calendar-dialog">
#>     <el-form v-if="eventForm" label-width="72px" @submit.prevent>
#>       <el-form-item :label="eventLabels.title">
#>         <el-input v-model="eventForm.title"></el-input>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.allday">
#>         <el-switch :model-value="isAllday(eventForm)" @update:model-value="setAllday"></el-switch>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.date">
#>         <el-date-picker v-model="eventForm.date" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%" :clearable="false"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.end">
#>         <el-date-picker v-model="eventForm.end" :type="isAllday(eventForm) ? &#39;date&#39; : &#39;datetime&#39;" :value-format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" :format="isAllday(eventForm) ? &#39;YYYY-MM-DD&#39; : &#39;YYYY-MM-DD HH:mm&#39;" style="width: 100%"></el-date-picker>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.calendar" v-if="calendars.length">
#>         <el-select v-model="eventForm.calendarId">
#>           <el-option v-for="c in calendars" :key="c.id" :label="c.name || c.id" :value="c.id"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.type">
#>         <el-select v-model="eventForm.type" :placeholder="eventType(eventForm)">
#>           <el-option v-for="t in [&#39;primary&#39;, &#39;success&#39;, &#39;info&#39;, &#39;warning&#39;, &#39;danger&#39;]" :key="t" :label="t" :value="t"></el-option>
#>         </el-select>
#>       </el-form-item>
#>       <el-form-item :label="eventLabels.body">
#>         <el-input v-model="eventForm.body" type="textarea" :rows="2"></el-input>
#>       </el-form-item>
#>     </el-form>
#>     <template v-slot:footer><el-button v-if="eventForm &amp;&amp; eventForm.id !== undefined" type="danger" plain @click="deleteEvent">{{ eventLabels.delete }}</el-button><el-button @click="cancelEvent">{{ eventLabels.cancel }}</el-button><el-button type="primary" @click="saveEvent" :disabled="!eventForm || !eventForm.date">{{ eventLabels.save }}</el-button></template>
#>   </el-dialog>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-08","range":["2025-01-01","2025-01-31"],"events":[],"editable":false,"calendars":[],"visibleEventCount":null,"useDetailPopup":false,"firstDayOfWeek":null,"workweek":false,"eventForm":null,"eventDragged":null,"eventDetail":null,"eventMore":null,"eventAnchor":null,"eventSelect":null,"eventLabels":{"add":"New event","edit":"Edit event","title":"Title","allday":"All day","date":"Date","end":"Until","calendar":"Calendar","type":"Type","body":"Details","save":"Save","delete":"Delete","cancel":"Cancel","more":"+{n} more"},"controllerType":null,"formatter":null},"methods":{"eventCalendar":"function(ev) { if (!ev || ev.calendarId === undefined || ev.calendarId === null) return null; var id = String(ev.calendarId); return (this.calendars || []).filter(function(c) { return String(c.id) === id; })[0] || null; }","eventType":"function(ev) { var c = this.eventCalendar(ev); return ev.type || (c && c.type) || 'primary'; }","eventColor":"function(ev) { var c = this.eventCalendar(ev); return ev.color || (c && c.color) || undefined; }","eventStyle":"function(ev) { var col = this.eventColor(ev); return col ? {borderColor: col, color: 'var(--el-text-color-primary)'} : null; }","eventLabel":"function(ev, day) { var d = String(ev.date); return (d.length > 10 && d.slice(0, 10) === day ? d.slice(11, 16) + ' ' : '') + (ev.title || ''); }","eventWhen":"function(ev) { if (!ev) return ''; var d = String(ev.date), e = ev.end ? String(ev.end) : ''; if (!e) return d; return d + ' – ' + (e.slice(0, 10) === d.slice(0, 10) ? e.slice(11) : e); }","eventsOn":"function(day) { var self = this; var on = (self.events || []).filter(function(e) { if (e.isVisible === false) return false; var c = self.eventCalendar(e); if (c && c.isVisible === false) return false; var start = String(e.date).slice(0, 10), end = e.end ? String(e.end).slice(0, 10) : start; return start <= day && day <= end; }); var key = function(e) { var d = String(e.date); return d.length > 10 && d.slice(0, 10) === day ? d.slice(11) : ''; }; return on.map(function(e, i) { return [e, i]; }).sort(function(a, b) { var ka = key(a[0]), kb = key(b[0]); return ka < kb ? -1 : ka > kb ? 1 : a[1] - b[1]; }).map(function(p) { return p[0]; }); }","eventsShown":"function(day) { var all = this.eventsOn(day), n = this.visibleEventCount; return n && all.length > n ? all.slice(0, n) : all; }","eventsHidden":"function(day) { var n = this.visibleEventCount; if (!n) return 0; return Math.max(0, this.eventsOn(day).length - n); }","moreLabel":"function(day) { return String(this.eventLabels.more).replace('{n}', this.eventsHidden(day)); }","canEdit":"function(ev) { return !!this.editable && !ev.isReadOnly; }","isAllday":"function(f) { return !f || !f.date || String(f.date).length <= 10; }","setAllday":"function(on) { var f = this.eventForm; if (!f || !f.date) return; var day = function(s) { return String(s).slice(0, 10); }; if (on) { f.date = day(f.date); if (f.end) f.end = day(f.end); } else { f.date = day(f.date) + ' 09:00'; if (f.end) f.end = day(f.end) + ' 10:00'; } }","eventRequest":"function(kind, value, apply) { if (window.Shiny && Shiny.setInputValue) { Shiny.setInputValue('calendar2_' + kind + ':shiny.element.cal_event', window.shinyVue.plain(value), {priority: 'event'}); } else if (apply) { apply.call(this); } }","clickEvent":"function(ev, e, fromMore) { var self = this; self.eventRequest('click', ev); var anchor = fromMore ? self.eventAnchor : (e && e.currentTarget) || null; self.closePopovers(); if (self.canEdit(ev)) { self.eventForm = Object.assign({}, ev, {end: ev.end || null}); return; } if (self.useDetailPopup && anchor) { self.eventAnchor = anchor; self.eventDetail = ev; self.listenOutside(); } }","openMore":"function(day, e) { this.closePopovers(); this.eventAnchor = e.currentTarget; this.eventMore = day; this.listenOutside(); }","closePopovers":"function() { this.eventMore = null; this.eventDetail = null; }","listenOutside":"function() { var self = this; if (self._outside) return; var off = function() { document.removeEventListener('mousedown', down, true); document.removeEventListener('keydown', key, true); self._outside = null; }; var down = function(e) { var t = e.target; if (t.closest && (t.closest('.el-calendar-popover') || t === self.eventAnchor)) return; self.closePopovers(); off(); }; var key = function(e) { if (e.key === 'Escape') { self.closePopovers(); off(); } }; self._outside = off; document.addEventListener('mousedown', down, true); document.addEventListener('keydown', key, true); }","openAdd":"function(day, end) { if (!this.editable) return; this.closePopovers(); var f = {date: day, end: end && end !== day ? end : null, title: '', type: 'primary', body: ''}; if (this.calendars && this.calendars.length) f.calendarId = this.calendars[0].id; this.eventForm = f; }","cancelEvent":"function() { this.eventForm = null; }","saveEvent":"function() { var self = this, f = self.eventForm; if (!f || !f.date) return; var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; if (ev.id === undefined) { self.eventRequest('add', ev, function() { ev.id = 'local-' + Date.now(); self.events.push(ev); }); } else { var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; var changes = {}; Object.keys(ev).forEach(function(k) { if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); self.eventRequest('update', {event: old, changes: changes}, function() { var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } self.eventForm = null; }","deleteEvent":"function() { var self = this, f = self.eventForm; if (!f) return; var old = self.events.filter(function(e) { return e.id === f.id; })[0]; if (old) self.eventRequest('delete', old, function() { self.events.splice(self.events.indexOf(old), 1); }); self.eventForm = null; }","dragStart":"function(ev, e) { if (!this.canEdit(ev)) { e.preventDefault(); return; } this.closePopovers(); this.eventDragged = ev.id; if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; e.dataTransfer.setData('text/plain', String(ev.id)); } }","dropOn":"function(day) { var self = this, id = self.eventDragged; self.eventDragged = null; if (!self.editable || id === null) return; var old = self.events.filter(function(e) { return e.id === id; })[0]; if (!old || String(old.date).slice(0, 10) === day) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var shift = parse(day) - parse(old.date); var changes = {date: day + String(old.date).slice(10)}; if (old.end) changes.end = fmt(parse(old.end) + shift) + String(old.end).slice(10); var ev = Object.assign({}, old, changes); self.eventRequest('update', {event: old, changes: changes}, function() { self.events.splice(self.events.indexOf(old), 1, ev); }); }","selectStart":"function(day, e) { var self = this; if (!self.editable || e.button !== 0) return; self.eventSelect = {from: day, to: day}; var up = function() { document.removeEventListener('mouseup', up, true); self.selectEnd(); }; document.addEventListener('mouseup', up, true); }","selectMove":"function(day) { if (this.eventSelect) this.eventSelect.to = day; }","selectEnd":"function() { var s = this.eventSelect; this.eventSelect = null; if (!s || s.from === s.to) return; this.openAdd(s.from < s.to ? s.from : s.to, s.from < s.to ? s.to : s.from); }","inSelection":"function(day) { var s = this.eventSelect; if (!s || s.from === s.to) return false; var a = s.from < s.to ? s.from : s.to, b = s.from < s.to ? s.to : s.from; return a <= day && day <= b; }","weekStart":"function() { var dj = window.ElementPlus && ElementPlus.dayjs; var fdw = this.firstDayOfWeek; if (!dj) return fdw === null || fdw === undefined ? 0 : fdw; var loc = dj.Ls && dj.Ls[dj.locale()]; if (fdw === null || fdw === undefined || !loc) return dj.localeData ? dj.localeData().firstDayOfWeek() : 0; var had = Object.prototype.hasOwnProperty.call(loc, 'weekStart'), old = loc.weekStart; loc.weekStart = fdw; Promise.resolve().then(function() { if (had) loc.weekStart = old; else delete loc.weekStart; }); return fdw; }","calendarClass":"function() { var out = ['el-calendar--events']; if (!this.workweek) return out; var s = this.firstDayOfWeek; if (s === null || s === undefined) { var dj = window.ElementPlus && ElementPlus.dayjs; s = dj && dj.localeData ? dj.localeData().firstDayOfWeek() : 0; } [0, 6].forEach(function(w) { out.push('is-hide-col-' + (((w - s + 7) % 7) + 1)); }); return out; }","reportDates":"function() { var self = this; self.$nextTick(function() { var root = self.$el && self.$el.querySelectorAll ? self.$el : null; if (!root || !window.Shiny || !Shiny.setInputValue) return; var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; var parse = function(s) { var p = String(s).slice(0, 10).split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; var start, end; if (self.range && self.range.length) { start = parse(self.range[0]); end = start + (cells.length - 1) * 864e5; } else { var v = String(self.value).slice(0, 10).split('-'); var first = Date.UTC(+v[0], +v[1] - 1, 1); var prev = root.querySelectorAll('.el-calendar-table td.prev').length; start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } Shiny.setInputValue('calendar2_dates:shiny.element.cal_event', {current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }","shinyVueReceive":"function(d) { if (!('calendarEdit' in d)) return d; var e = d.calendarEdit, events = this.events, rows = e.rows || []; delete d.calendarEdit; var at = function(id) { for (var i = 0; i < events.length; i++) if (String(events[i].id) === String(id)) return i; return -1; }; if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); if (i >= 0) events.splice(i, 1, r); else events.push(r); }); else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { var i = at(id); if (i >= 0) events.splice(i, 1); }); return d; }","elPick":"function(d) { this.value = this.elDay(d); }","elDate":"function(s) { if (!s || typeof s !== 'string') return s; var p = s.slice(0, 10).split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }","elDay":"function(d) { if (!(d instanceof Date)) return d; var pad = function(n) { return (n < 10 ? '0' : '') + n; }; return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"},"watch":{"value":"function(newVal, oldVal) { if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) this.reportDates(); }","range":{"immediate":true,"handler":"function() { this.reportDates(); }"},"firstDayOfWeek":"function() { this.reportDates(); }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.eventCalendar","options.methods.eventType","options.methods.eventColor","options.methods.eventStyle","options.methods.eventLabel","options.methods.eventWhen","options.methods.eventsOn","options.methods.eventsShown","options.methods.eventsHidden","options.methods.moreLabel","options.methods.canEdit","options.methods.isAllday","options.methods.setAllday","options.methods.eventRequest","options.methods.clickEvent","options.methods.openMore","options.methods.closePopovers","options.methods.listenOutside","options.methods.openAdd","options.methods.cancelEvent","options.methods.saveEvent","options.methods.deleteEvent","options.methods.dragStart","options.methods.dropOn","options.methods.selectStart","options.methods.selectMove","options.methods.selectEnd","options.methods.inSelection","options.methods.weekStart","options.methods.calendarClass","options.methods.reportDates","options.methods.shinyVueReceive","options.methods.elPick","options.methods.elDate","options.methods.elDay","options.watch.value","options.watch.range.handler","options.watch.firstDayOfWeek"]}</script>
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
