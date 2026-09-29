# JavaScript that pushes a batch of files through Shiny's upload channel

Element calls `http-request` once per file, but Shiny's protocol is
per-batch: `uploadInit` opens a job for a set of files, each is POSTed
to the job's URL, and `uploadEnd` sets the input to that job's files.
Running the protocol per file therefore makes each upload overwrite the
last, so a three-file selection arrives as a single row.

## Usage

``` r
.el_upload_js(ns_id)
```

## Arguments

- ns_id:

  The namespaced input id.

## Value

An [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
object for the `http-request` prop.

## Details

Element's `uploadFiles()` starts and uploads each file in one
synchronous loop, so the calls are collected in a queue and flushed from
a microtask, by which point the whole batch is present. Replacing only
the transport this way leaves Element's file list, progress bars and its
`on-success`, `on-progress` and `on-error` hooks working as they
normally do.
