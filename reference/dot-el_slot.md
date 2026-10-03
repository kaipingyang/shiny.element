# A slot's content, in Vue 3's syntax

`<template v-slot:name>` – Vue 3 has no `slot="name"` attribute, and an
element carrying one is rendered into the default slot instead.

## Usage

``` r
.el_slot(name, ..., scope = NULL)
```

## Arguments

- name:

  The slot's name.

- ...:

  Its content.

- scope:

  The scope's name or destructuring, for a scoped slot.

## Value

A template tag.
