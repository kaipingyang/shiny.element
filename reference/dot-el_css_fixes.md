# Corrections to Element's own stylesheet

Carried in the dependency's `head`, so they apply whether Element is
served from the package or from the CDN.

## Usage

``` r
.el_css_fixes()
```

## Value

A `<style>` element, as text.

## Details

- 2.15 gave every table cell
  `.el-table .el-table__cell { padding: 12px 0 }`. It outranks the
  expanded row's
  `.el-table__expanded-cell[class*=cell] { padding: 20px 50px }` – the
  same specificity, later in the file – so an expanded row's content sat
  flush against the table's edge.
