# What an output sends: its markup, or the data that changed

What an output sends: its markup, or the data that changed

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
each changed field as JSON text.
