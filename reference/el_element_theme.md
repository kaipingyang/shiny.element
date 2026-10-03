# Element Plus's look, themed

Element Plus draws from CSS variables – `--el-color-primary`,
`--el-border-radius-base`, `--el-font-size-base` and some three hundred
more, listed in its stylesheet's `:root`. A page whose theme changes any
of them gets a `<style>` setting them, after Element's own stylesheet:
no build, no recompiling, as Element Plus's own theming guide does it.

## Details

A brand colour also sets the tints and the shade Element's Sass mixes
from it – `--el-color-primary-light-3` to `-light-9`, `-dark-2` – for
the light page and, mixed against the dark background, for `html.dark`.
