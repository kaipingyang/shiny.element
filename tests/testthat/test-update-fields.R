# Every update_*() message field has to name a field that really exists in the
# component's Vue data.
#
# The shared updater in el-update.js assigns by key, so a mismatch is refused
# and warned about rather than silently doing nothing -- but it is better to
# catch it here. Two mismatches were shipped before this check existed:
# update_el_table() sent `data` while the Vue field is `tableData`, and nine
# fields across six components were only added to the Vue data when the user
# passed them at construction time, leaving the corresponding update argument
# inert for everyone else.

vue_data_keys <- function(tag) {
  html <- paste(as.character(htmltools::renderTags(tag)$html), collapse = "")
  m <- regmatches(html, regexpr('application/json"[^>]*>.*?</script>', html, perl = TRUE))
  if (!length(m)) return(character(0))
  json <- sub("</script>$", "", sub('^application/json"[^>]*>', "", m))
  names(jsonlite::fromJSON(json, simplifyVector = FALSE)$x$data)
}

capture_update <- function(fn, args) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- msg
  )
  do.call(fn, c(list(session = session, id = "x"), args))
  setdiff(names(captured), "id")
}

# Each entry: the update function, a UI call, and the arguments to fill in.
# NULL args means "pass 1 for every optional argument".
cases <- list(
  list("update_el_input",          quote(el_input("x"))),
  list("update_el_select",         quote(el_select("x", choices = c(A = "a")))),
  list("update_el_switch",         quote(el_switch("x"))),
  list("update_el_slider",         quote(el_slider("x"))),
  list("update_el_rate",           quote(el_rate("x"))),
  list("update_el_radio_group",    quote(el_radio_group("x", choices = c(A = "a")))),
  list("update_el_checkbox_group", quote(el_checkbox_group("x", choices = c(A = "a")))),
  list("update_el_input_number",   quote(el_input_number("x"))),
  list("update_el_date_picker",    quote(el_date_picker("x"))),
  list("update_el_color_picker",   quote(el_color_picker("x"))),
  list("update_el_cascader",       quote(el_cascader("x"))),
  list("update_el_collapse",       quote(el_collapse("x", items = list(list(name = "i", title = "T", content = "C"))))),
  list("update_el_tabs",           quote(el_tabs("x", tabs = list(list(name = "t", label = "L", content = "C"))))),
  list("update_el_pagination",     quote(el_pagination("x", total = 10))),
  list("update_el_dialog",         quote(el_dialog("x"))),
  list("update_el_drawer",         quote(el_drawer("x"))),
  list("update_el_steps",          quote(el_steps("x", steps = list(list(title = "S"))))),
  list("update_el_calendar",       quote(el_calendar("x"))),
  list("update_el_alert",          quote(el_alert("x"))),
  list("update_el_button",         quote(el_button("x"))),
  list("update_el_tag",            quote(el_tag("x"))),
  list("update_el_progress",       quote(el_progress("x"))),
  list("update_el_dropdown",       quote(el_dropdown("x", items = list(list(command = "c", label = "L"))))),
  list("update_el_table",          quote(el_table(id = "x", data = head(iris, 2))),
       list(data = head(iris, 3), border = FALSE, selection = TRUE))
)

for (case in cases) {
  local({
    fn_name <- case[[1]]
    ui_call <- case[[2]]
    args    <- if (length(case) > 2) case[[3]] else NULL

    test_that(paste(fn_name, "only sends fields the component declares"), {
      fn   <- get(fn_name, envir = asNamespace("shiny.element"))
      keys <- vue_data_keys(eval(ui_call))
      expect_gt(length(keys), 0)

      if (is.null(args)) {
        args <- stats::setNames(
          as.list(rep(1, length(setdiff(names(formals(fn)), c("session", "id", "..."))))),
          setdiff(names(formals(fn)), c("session", "id", "..."))
        )
      }
      sent <- capture_update(fn, args)
      expect_gt(length(sent), 0)
      expect_equal(setdiff(sent, keys), character(0),
                   info = paste(fn_name, "sends fields absent from the Vue data"))
    })
  })
}

test_that("fields that can be updated are declared even when not supplied", {
  # These were conditional: absent from the Vue data unless the user passed
  # them at construction, which made their update argument a no-op.
  expect_true(all(c("size", "placeholder") %in% vue_data_keys(el_input("x"))))
  expect_true("placeholder" %in% vue_data_keys(el_select("x", choices = c(A = "a"))))
  expect_true("placeholder" %in% vue_data_keys(el_date_picker("x")))
  expect_true(all(c("min", "max") %in% vue_data_keys(el_checkbox_group("x", choices = c(A = "a")))))
  expect_true(all(c("status", "color") %in% vue_data_keys(el_progress("x"))))
  expect_true("description" %in% vue_data_keys(el_alert("x")))
  expect_true("range" %in% vue_data_keys(el_calendar("x")))
})

test_that("an unsupplied field serialises as JSON null, which Element treats as unset", {
  html <- paste(as.character(el_input("x")), collapse = "")
  expect_match(html, '"placeholder":null', fixed = TRUE)
  expect_match(html, '"size":null', fixed = TRUE)
})

# ── widget mount points take up no room before JS runs ────────────────────────

test_that("the htmlwidget container is declared with zero size", {
  # vueR::vue() defaults to 960x500 and only hides the container once
  # renderValue runs, so until then every component holds open an empty box.
  # Measured on the showcase app with script execution disabled: the page was
  # 3215px tall against 1462px once mounted, from 12 placeholders of 960x500.
  for (tag in list(el_input("x"), el_select("x", choices = c(A = "a")),
                   el_button("x"), el_table(id = "x", data = head(iris, 2)),
                   el_form(id = "x"))) {
    html <- paste(as.character(htmltools::renderTags(tag)$html), collapse = "")
    box  <- regmatches(html, regexpr('<div[^>]*html-widget[^>]*>', html))
    expect_match(box, "width:0px", fixed = TRUE)
    expect_match(box, "height:0px", fixed = TRUE)
  }
})
