# What an output sends: its markup, or the data that changed

A render is made in two steps. `.vue_output_whole()` is the output as it
stands, the same for every session – what
[`bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html) keeps;
`.vue_output_send()` compares it with what this session's page last got
and sends the markup or the changed fields. A cached render runs only
the second step (`cacheReadHook`), so caching and sending only what
changed go together.

## Usage

``` r
.vue_output_value(session, name, tags)
```

## Arguments

- session:

  The session.

- name:

  The output's id.

- tags:

  The component's tags, its host carrying `vue_host`.

## Value

`list(html =, deps =)`, or `list(patch = list(host =, fields =))` with
each changed field as JSON text; carrying the whole as attribute
`vue_whole`, for the cache.
