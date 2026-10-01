# One tab's pane

A `lazy` tab that is not showing keeps its content in a `<template>`,
which the browser leaves inert: nothing in it renders, binds or runs
until the binding instantiates it the first time the tab is selected.

## Usage

``` r
.el_tab_pane(ns_id, t, active)
```

## Arguments

- ns_id:

  The tabs' namespaced id.

- t:

  The tab description.

- active:

  Whether it is selected.

## Value

A tag.
