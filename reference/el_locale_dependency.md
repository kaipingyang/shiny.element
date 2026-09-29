# Element UI Locale Dependency

Element UI's bundled build ships Simplified Chinese, and that is what
every component's built-in text uses — a pagination control reads "共
200 条" and a date picker's buttons are "清空" and "确定". Loading a
locale file and calling `ELEMENT.locale()` switches all of it.

## Usage

``` r
el_locale_dependency(locale = NULL)
```

## Arguments

- locale:

  Language to switch to. `NULL` (the default) keeps Element UI's
  built-in Simplified Chinese. `"en"` is bundled with this package. Any
  other value loads `locale/<locale>.js` from the package, which you
  would have to add yourself.

## Value

A list of htmlDependency objects, or `NULL` for the built-in locale.

## Examples

``` r
# English built-in text
el_page(locale = "en")
#> <div class="container-fluid"></div>
```
