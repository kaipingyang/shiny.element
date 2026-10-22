# Corrections to Element's own stylesheet

Carried in the dependency's `head`, so they apply whether Element is
served from the package or from the CDN. None are needed for Element
Plus 2.14.7; the hook stays for the next one.

## Usage

``` r
.el_css_fixes()
```

## Value

A `<style>` element, as text, or `NULL`.
