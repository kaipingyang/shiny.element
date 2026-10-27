# Optional props as a group: their fields and the map the bridge reads

The props a component library defaults when they are not given, bound
together on one tag with `v-bind="$optional('<group>')"` (see
[`.vue_bind_optional()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_bind_optional.md)).
Each prop has a field in the component's data, named in camelCase, so an
update sets it as any other; unset (`NULL`) is `NA`, sent as `null` and
made `undefined` in the browser, where Vue applies the prop's default. A
deliberate `null` is `JS("null")`.

## Usage

``` r
.vue_optional_props(
  values,
  group,
  prefix = NULL,
  rename = NULL,
  wrap = NULL,
  fields = NULL
)
```

## Arguments

- values:

  Named list of the props' values, names in snake_case as the R
  arguments are; `NULL` for unset.

- group:

  The group's name, as the template reads it: usually the tag's,
  `"select"`.

- prefix:

  A prefix for the fields' names, keeping a folded component's fields
  apart from its host's (`tipPlacement`), or `NULL`.

- rename:

  `c(<argument> = "<prop-kebab>")` for an argument named apart from the
  prop it stands for.

- wrap:

  `c(<argument> = "<wrap>")`: the value goes through
  `sv.optionalWraps[<wrap>]` in the browser, a function a component
  library registers.

- fields:

  `c(<argument> = "<field>")` for a field named otherwise than the prop
  – one an update function already sets by that name. Taken as it is: no
  prefix is added.

## Value

`list(map =, data =)`: `map` for the spec's `optional`, one group of
`<prop-kebab> = <field>` (or `list(field =, wrap =)`); `data` the
fields, by name.
