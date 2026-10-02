# JavaScript that pushes a batch of files through Shiny's upload channel

Element calls `http-request` once per file, but Shiny's protocol is
per-batch: `uploadInit` opens a job for a set of files, each is POSTed
to the job's URL, and `uploadEnd` sets the input to that job's files.
Running the protocol per file would make each upload overwrite the last.

## Usage

``` r
.el_upload_js(ns_id)
```

## Arguments

- ns_id:

  The namespaced input id.

## Value

A [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
object for the `http-request` prop.

## Details

Element's `uploadFiles()` starts every file in one synchronous loop, so
the calls are collected and flushed from a microtask, by which point the
whole batch is present. Then, as Shiny's own
[`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) does:

- Files are POSTed **one after another**. Shiny's job takes each POST as
  the next file in its list, so two in flight at once could land under
  each other's names.

- A file is Element's "success" only once `uploadEnd` has accepted the
  batch: until then nothing has reached `input$<id>`.

- A job cannot finish with a file missing – Shiny stops it as "stopped
  prematurely". So when a file fails, or is aborted with Element's
  `abort()`, that file is marked failed (or left, if aborted) and the
  rest of the batch is sent again as a fresh job. If nothing is left,
  the job is abandoned, as
  [`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) abandons
  a failed one; Shiny clears it with the session.

Each call returns an object with `abort()`, which Element keeps per
file: it stops that file's request if it is in flight and drops it from
the batch otherwise.
