# The arguments a component drawn as markup binds

Its arguments but its frame (`skip`) and those whose kind is not a prop:
the fields its binding follows, as its update sets them.

## Usage

``` r
.vue_bindable(args, kinds, skip)
```

## Arguments

- args:

  The function's arguments' names.

- kinds:

  Their kinds.

- skip:

  Arguments of the component's frame (id, session, ...).

## Value

The names.
