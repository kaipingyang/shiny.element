# Element's side of the bridge

The package's own scripts for Element, in one dependency, as
shinyWidgets keeps its bindings in one file and bslib its components'
scripts: `el-events.js` (errors and labels drawn on a form item, table
rows, the raw-`<el-*>`-tag warning) and the input bindings of the
components drawn as markup rather than Vue apps – collapse, tabs, and
the overlays, dialog and drawer – so that what is inside them stays
mounted.

## Usage

``` r
.el_bridge_dependency()
```

## Value

An htmlDependency object.
