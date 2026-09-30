# Refuse markup that contains a mounted component

A component that wraps its trigger – tooltip, popover, popconfirm –
compiles that markup as part of its own Vue instance. Vue creates fresh
DOM nodes when it compiles, and an htmlwidget's instance does not travel
with the copy: the inner component disappears and its inputs never
report. The mount point does get cloned, so nothing errors and nothing
is logged.

## Usage

``` r
.el_reject_widgets(ui, arg, component)
```

## Arguments

- ui:

  The markup to check.

- arg:

  Name of the argument it came from, for the message.

- component:

  Name of the component doing the wrapping.

## Value

`ui`, unchanged, when it holds no widget.

## Details

Raw Element tags from
[el](https://kaipingyang.github.io/shiny.element/reference/el.md) and
ordinary Shiny UI are fine, because they are only markup. This turns the
silent case into an error naming the way out.
