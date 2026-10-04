# A host: the element a component mounts on, carrying its template and spec

A host: the element a component mounts on, carrying its template and
spec

## Usage

``` r
.vue_host(id, template, spec, dependencies = list())
```

## Arguments

- id:

  The host's id.

- template:

  The template, as HTML.

- spec:

  What the bridge reads: `options`, `input`, `use`, ...

- dependencies:

  htmlDependencies to attach beside the Vue layer's.

## Value

A tag with its dependencies.
