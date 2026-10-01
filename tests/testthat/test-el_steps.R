render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# Capture the custom message a server-side function sends. Named to avoid
# shadowing testthat::capture_message(), which catches conditions instead.
sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

three_steps <- list(
  list(title = "S1"),
  list(title = "S2"),
  list(title = "S3")
)

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_steps: returns a tagList with the container id", {
  st <- el_steps(id = "s1", steps = three_steps)
  expect_true(inherits(st, "shiny.tag.list"))
  expect_match(render_html(st), 'id="s1_container"')
})

test_that("el_steps: one el-step tag per step", {
  html <- render_html(el_steps(id = "s1", steps = three_steps))
  expect_equal(lengths(regmatches(html, gregexpr("<el-step ", html, fixed = TRUE)))[[1]], 3L)
})

test_that("el_steps: attaches its own handler dependency", {
  deps <- htmltools::findDependencies(el_steps(id = "s1", steps = three_steps))
  expect_true("el-steps-handler" %in% vapply(deps, function(d) d$name, character(1)))
})

# ── step attributes ───────────────────────────────────────────────────────────

test_that("el_steps: step fields are static attributes, not Vue bindings", {
  # A bound :title would be evaluated as an expression against the Vue data.
  html <- render_html(el_steps(id = "s1", steps = list(
    list(title = "S1", description = "D1", icon = "el-icon-edit", status = "finish")
  )))
  expect_match(html, 'title="S1"')
  expect_match(html, 'description="D1"')
  expect_match(html, 'icon="el-icon-edit"')
  expect_match(html, 'status="finish"')
  expect_false(grepl(':title=', html, fixed = TRUE))
})

test_that("el_steps: absent step fields emit no attribute", {
  html <- render_html(el_steps(id = "s1", steps = list(list(title = "only"))))
  # Scope to the step tag: the surrounding el-steps carries :process-status
  # and :finish-status, which a whole-document grep would match.
  step <- regmatches(html, regexpr("<el-step [^>]*>", html))
  expect_match(step, 'title="only"')
  expect_false(grepl("description=", step, fixed = TRUE))
  expect_false(grepl("icon=", step, fixed = TRUE))
  expect_false(grepl("status=", step, fixed = TRUE))
})

test_that("el_steps: an empty step list still renders the container", {
  html <- render_html(el_steps(id = "s1"))
  expect_match(html, "<el-steps")
  expect_false(grepl("<el-step ", html, fixed = TRUE))
})

# ── steps attributes ──────────────────────────────────────────────────────────

test_that("el_steps: active and statuses are bound to the Vue data", {
  html <- render_html(el_steps(id = "s1", steps = three_steps, active = 1,
                               finish_status = "success"))
  expect_match(html, ':active="active"')
  expect_match(html, ':finish-status="finishStatus"')
  expect_match(html, ':process-status="processStatus"')
  expect_match(html, '"active":1')
  expect_match(html, '"finishStatus":"success"')
})

test_that("el_steps: layout flags reach the data", {
  html <- render_html(el_steps(id = "s1", steps = three_steps,
                               direction = "vertical", align_center = TRUE,
                               simple = TRUE))
  expect_match(html, '"direction":"vertical"')
  expect_match(html, '"alignCenter":true')
  expect_match(html, '"simple":true')
})

test_that("el_steps: space stays reachable by update even when not supplied", {
  # Bound either way, so the field exists in the Vue data and
  # update_el_steps() can set it later; unset, it reads back as null and the
  # binding hands Element undefined, which falls back to its own default.
  plain <- el_steps(id = "s1", steps = three_steps)
  expect_true(binds_attr(plain, "space"))
  expect_null(vue_data_of(plain)$space)

  expect_equal(vue_data_of(el_steps(id = "s1", steps = three_steps, space = 200))$space, 200)
})

# ── reporting to Shiny ────────────────────────────────────────────────────────

test_that("el_steps: reports active on mount as well as on change", {
  # watch alone never fires on mount, so input$s1 stayed NULL until the first
  # update -- which broke any handler reading it to compute the next step.
  # The binding reads it on load.
  expect_equal(vue_spec_of(el_steps(id = "s1", steps = three_steps, active = 2))$input,
               "active")
})

# ── update_el_steps ───────────────────────────────────────────────────────────

test_that("update_el_steps: sends under the right message type", {
  out <- sent_message(function(s) update_el_steps(s, "s1", active = 2))
  expect_equal(out$type, "updateElSteps")
  expect_equal(out$msg$id, "s1")
  expect_equal(out$msg$active, 2)
})

test_that("update_el_steps: active 0 is sent, not treated as absent", {
  # Resetting to the first step is a real instruction.
  out <- sent_message(function(s) update_el_steps(s, "s1", active = 0))
  expect_equal(out$msg$active, 0)
})

test_that("update_el_steps: statuses use camelCase keys", {
  out <- sent_message(function(s) {
    update_el_steps(s, "s1", process_status = "error", finish_status = "success")
  })
  expect_equal(out$msg$processStatus, "error")
  expect_equal(out$msg$finishStatus, "success")
})

test_that("update_el_steps: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_steps(s, "s1", active = 1))
  expect_equal(out$msg$active, 1)
  expect_null(out$msg$processStatus)
  expect_null(out$msg$finishStatus)
})
