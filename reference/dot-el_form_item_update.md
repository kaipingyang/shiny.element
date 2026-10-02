# Add a label or error to an update

The form item a labelled input is drawn in has no Vue field of its own:
its label and message are markup around the component. They travel as
the bridge's own keys, `.label` and `.error`, which el-events.js draws.

## Usage

``` r
.el_form_item_update(msg, label = NULL, error = NULL)
```

## Arguments

- msg:

  The update message.

- label:

  New label text, or `NULL`.

- error:

  New error message, `""` to clear it, or `NULL`.

## Value

The message.
