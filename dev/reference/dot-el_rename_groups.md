# Rename optional props' groups in markup

A folded component binds its optional props with
`v-bind="$optional('<group>')"`; when its fields take a prefix its
groups do too, and the binding is rewritten to match.

## Usage

``` r
.el_rename_groups(markup, rename)
```

## Arguments

- markup:

  A tag, tag list or list of them.

- rename:

  Named character vector: old group -\> new.

## Value

The markup.
