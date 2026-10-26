# What every Vue host needs

jQuery, Vue core and the bridge, in load order: the scripts a page needs
for any host on it. Made once per R session and mode.

## Usage

``` r
.vue_host_dependencies()
```

## Value

A list of htmlDependency objects.
