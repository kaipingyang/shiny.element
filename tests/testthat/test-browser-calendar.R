# The calendar's events layer in a browser: times, groups, "+N more", the
# detail popover, dragging across days, read-only events, the week's first
# day, the workweek and slots of one's own (apps/calendar.R).

test_that("the calendar's events layer works in a browser", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "calendar.R")
  pkg <- normalizePath(testthat::test_path("..", ".."))
  port <- httpuv::randomPort()
  log <- tempfile(fileext = ".log")
  proc <- callr::r_bg(
    function(app, pkg, port, libs) {
      .libPaths(libs)
      pkgload::load_all(
        pkg,
        quiet = TRUE,
        helpers = FALSE,
        attach_testthat = FALSE
      )
      options(shiny.element.dev = TRUE)
      shiny::runApp(
        app,
        host = "127.0.0.1",
        port = port,
        launch.browser = FALSE
      )
    },
    args = list(app = app, pkg = pkg, port = port, libs = .libPaths()),
    stdout = log,
    stderr = "2>&1"
  )
  on.exit(proc$kill(), add = TRUE)
  for (i in seq_len(120)) {
    Sys.sleep(0.5)
    if (any(grepl("Listening on", readLines(log, warn = FALSE)))) break
  }
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 1000, height = 1000)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    "window.__w = []; ['warn', 'error'].forEach(function(k) {
       var o = console[k];
       console[k] = function() { window.__w.push(Array.prototype.join.call(arguments, ' ')); return o.apply(console, arguments); };
     });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  dump <- function() {
    txt <- js("document.getElementById('dump').innerText")
    lines <- trimws(strsplit(txt, "\n")[[1]])
    lines <- lines[grepl("=", lines, fixed = TRUE)]
    stats::setNames(
      trimws(sub("^[^=]*=", "", lines)),
      trimws(sub("=.*", "", lines))
    )
  }
  # a day's cell in a calendar, by its number in the month shown
  cell <- function(cal, n) {
    sprintf(
      "Array.from(document.querySelectorAll('#%s td.current .el-calendar-cell')).find(function(c){ return c.querySelector('.el-calendar-cell__day').innerText.trim() === '%d'; })",
      cal,
      n
    )
  }
  tag <- function(scope, text) {
    sprintf(
      "Array.from(document.querySelectorAll('%s .el-calendar-event')).find(function(t){ return t.innerText.indexOf('%s') >= 0; })",
      scope,
      text
    )
  }
  heads <- function(cal) {
    js(sprintf(
      "Array.from(document.querySelectorAll('#%s .el-calendar-table thead th')).filter(function(t){ return getComputedStyle(t).display !== 'none'; }).map(function(t){ return t.innerText; }).join(',')",
      cal
    ))
  }
  dialog <- "Array.from(document.querySelectorAll('.el-calendar-dialog')).find(function(d){ return d.offsetParent !== null; })"
  shown_popover <- function(cls) {
    js(sprintf(
      "(function(){ var d = Array.from(document.querySelectorAll('%s')).filter(function(x){ return x.offsetParent !== null; }); return d.length ? d[0].innerText.replace(/\\n+/g, ' / ') : ''; })()",
      cls
    ))
  }
  Sys.sleep(6)

  # the week starts on Monday where asked, on Sunday elsewhere: dayjs's
  # global locale is put back
  expect_equal(heads("xplan"), "Mon,Tue,Wed,Thu,Fri,Sat,Sun")
  expect_equal(heads("xsun"), "Sun,Mon,Tue,Wed,Thu,Fri,Sat")
  expect_equal(js("ElementPlus.dayjs.localeData().firstDayOfWeek()"), 0)
  # the workweek
  expect_equal(heads("xro"), "Mon,Tue,Wed,Thu,Fri")
  expect_equal(
    js(
      "JSON.stringify(Shiny.shinyapp.$inputValues['xplan_dates:shiny.element.cal_event'])"
    ),
    '{"current":"2026-10-07","start":"2026-09-28","end":"2026-11-01"}'
  )

  # two shown, all-day first, a "+2 more" for the others, in time order
  shown <- sprintf(
    "Array.from(%s.querySelectorAll('.el-calendar-event')).map(function(t){ return t.innerText; }).join('|')",
    cell("xplan", 5)
  )
  expect_equal(js(shown), "Standup|Lunch")
  expect_equal(
    js(paste0(
      cell("xplan", 5),
      ".querySelector('.el-calendar-more').innerText"
    )),
    "+2 more"
  )
  js(paste0(cell("xplan", 5), ".querySelector('.el-calendar-more').click()"))
  Sys.sleep(1)
  expect_match(
    shown_popover(".el-calendar-more__list"),
    "2026-10-05 / Standup / Lunch / 09:30 Design / 14:00 Review",
    fixed = TRUE
  )
  # an event from the list: the dialog, with its time; the list closed
  js(paste0(tag(".el-calendar-more__list", "Design"), ".click()"))
  Sys.sleep(1)
  expect_equal(shown_popover(".el-calendar-more__list"), "")
  expect_equal(
    js(paste0(dialog, ".querySelectorAll('.el-date-editor input')[0].value")),
    "2026-10-05 09:30"
  )
  js(paste0(
    "Array.from(",
    dialog,
    ".querySelectorAll('.el-button')).find(function(b){ return b.innerText === 'Cancel'; }).click()"
  ))
  Sys.sleep(1)

  # dragged across three days: a new event over them, timed with the switch
  js(paste0(
    cell("xplan", 14),
    ".dispatchEvent(new MouseEvent('mousedown', {bubbles: true, button: 0}))"
  ))
  js(paste0(cell("xplan", 15), ".dispatchEvent(new MouseEvent('mouseenter'))"))
  js(paste0(cell("xplan", 16), ".dispatchEvent(new MouseEvent('mouseenter'))"))
  Sys.sleep(0.3)
  expect_equal(
    js(
      "document.querySelectorAll('#xplan .el-calendar-cell.is-selecting').length"
    ),
    3
  )
  js("document.dispatchEvent(new MouseEvent('mouseup', {bubbles: true}))")
  Sys.sleep(1)
  dates <- paste0(
    "Array.from(",
    dialog,
    ".querySelectorAll('.el-date-editor input')).map(function(i){ return i.value; }).join(',')"
  )
  expect_equal(js(dates), "2026-10-14,2026-10-16")
  js(paste0(dialog, ".querySelector('.el-switch').click()"))
  Sys.sleep(0.5)
  expect_equal(js(dates), "2026-10-14 09:00,2026-10-16 10:00")
  js(paste0(
    "(function(){ var i = ",
    dialog,
    ".querySelector('input'); i.value = 'Trip'; i.dispatchEvent(new Event('input')); })()"
  ))
  js(paste0(
    "Array.from(",
    dialog,
    ".querySelectorAll('.el-button')).find(function(b){ return b.innerText === 'Save'; }).click()"
  ))
  Sys.sleep(2)
  expect_equal(
    dump()[["xplan_add"]],
    "POSIXct 2026-10-14 09:00 2026-10-16 10:00 Trip work"
  )
  # the server's answer, drawn: its time on its first day only
  expect_equal(
    js(sprintf(
      "Array.from(%s.querySelectorAll('.el-calendar-event')).map(function(t){ return t.innerText; }).join('|')",
      cell("xplan", 14)
    )),
    "09:00 Trip"
  )
  expect_equal(
    js(sprintf(
      "Array.from(%s.querySelectorAll('.el-calendar-event')).map(function(t){ return t.innerText; }).join('|')",
      cell("xplan", 15)
    )),
    "Trip"
  )

  # read-only: no dialog, not draggable
  js(paste0(tag("#xplan", "Locked"), ".click()"))
  Sys.sleep(0.8)
  expect_true(js(paste0("!", dialog)))
  expect_equal(
    js(paste0(tag("#xplan", "Locked"), ".getAttribute('draggable')")),
    "false"
  )

  # the detail popover of a calendar the user cannot edit, closed by a
  # press outside
  js(paste0(tag("#xro", "Standup"), ".click()"))
  Sys.sleep(1)
  expect_equal(
    shown_popover(".el-calendar-detail"),
    "Standup / 2026-10-05 / Work / Daily"
  )
  js(
    "document.body.dispatchEvent(new MouseEvent('mousedown', {bubbles: true}))"
  )
  Sys.sleep(1)
  expect_equal(shown_popover(".el-calendar-detail"), "")

  # a calendar hidden from the server
  js("document.getElementById('hide_home').click()")
  Sys.sleep(1.5)
  expect_true(js(paste0("!", tag("#xro", "Lunch"))))
  expect_true(js(paste0("!", tag("#xro", "Holiday"))))
  expect_false(js(paste0("!", tag("#xro", "Standup"))))

  # slots: the tag's content, the dialog's fields, the popover's content
  expect_equal(js("document.querySelectorAll('#xslot .xs-title').length"), 2)
  js(paste0(tag("#xslot", "Visit"), ".click()"))
  Sys.sleep(1)
  expect_equal(
    js(paste0(dialog, ".querySelector('.xs-where input').value")),
    "Lab 2"
  )
  js(paste0(
    "(function(){ var i = ",
    dialog,
    ".querySelector('.xs-where input'); i.value = 'Lab 3'; i.dispatchEvent(new Event('input')); })()"
  ))
  js(paste0(
    "Array.from(",
    dialog,
    ".querySelectorAll('.el-button')).find(function(b){ return b.innerText === 'Save'; }).click()"
  ))
  Sys.sleep(1.5)
  expect_equal(dump()[["xslot_update"]], "Visit Lab 3")
  js(paste0(tag("#xslot", "Audit"), ".click()"))
  Sys.sleep(1)
  expect_equal(shown_popover(".xs-detail"), "Audit @ HQ")

  expect_equal(js("window.__w.length"), 0, info = js("window.__w.join('\\n')"))
})
