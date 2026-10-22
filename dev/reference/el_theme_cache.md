# A page's theme, compiled once per machine rather than once per process

Shiny draws a bslib theme with
[`bslib::bs_theme_dependencies()`](https://rstudio.github.io/bslib/reference/bs_theme_dependencies.html),
which compiles it with `sass()` into a file under
[`tempdir()`](https://rdrr.io/r/base/tempfile.html). sass keeps the CSS
in its cache across sessions (`~/.cache/R/sass`), but counts a file
output as cached only when the file is already there – never in a new
process – so every R process compiled the page's theme again: 1.5 to 2
seconds before its first page, for
[`el_theme()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_theme.md)
or any theme but bslib's default (which bslib ships precompiled).

## Details

The page's theme is drawn with a cache standing in for sass's own: asked
whether it holds a key, it answers as sass's cache does and, holding it,
writes the CSS and the theme's files where that output goes. sass then
finds them there and compiles nothing. Should either package change how
it names or checks that output, sass finds nothing there and compiles,
as it always did.

A machine that has never compiled the default
[`el_theme()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_theme.md)
– a new install, a server – has nothing in sass's cache for it: the
package ships it compiled (`inst/el-theme/`, written by
`tools/el-theme-css.R`), used where the bslib and sass installed are the
ones it was compiled with.
