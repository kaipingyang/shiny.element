# Send an update to a component

One message type for every component, handled by shiny-vue.js: the
fields a component declares are assigned, one it does not is refused
with a warning, and a component with more to do – move a carousel,
validate a form – does it in its `shinyVueReceive` method. `.action`
names such an operation.

## Usage

``` r
.el_send_update(session, msg)
```

## Arguments

- session:

  A Shiny session.

- msg:

  The message: `id`, namespaced, and the fields to set.

## Value

`NULL`, invisibly.
