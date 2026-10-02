# Element's global config

Element reads `Vue.prototype.$ELEMENT` for the size a component takes
when it is given none, and for the z-index its popups start from.
Element sets it when it installs itself; this runs after and overrides
it.

## Usage

``` r
.el_config_dependency(size = NULL, z_index = NULL)
```

## Arguments

- size:

  `"medium"`, `"small"`, `"mini"`, or `NULL`.

- z_index:

  A number, or `NULL`.

## Value

A list holding one htmlDependency, or `NULL` when there is nothing to
set.
