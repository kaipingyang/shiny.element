## Test environments

* local Linux (container), R 4.4.3: `R CMD check --no-manual`, vignettes
  built
* win-builder (devel and release): to be run before submission

## R CMD check results

On a tmpfs build directory (block allocation as on ext4):

0 errors | 0 warnings | 0 notes

* This is a new release.
* The same check run in our development container's overlay filesystem
  gives 0 errors | 0 warnings | 1 note, "installed size is 5.2Mb": `du`
  there counts the same files as 5.2 MB that tmpfs counts as 4.6 MB
  (4612 KB). We expect the note on check machines with large filesystem
  blocks and not elsewhere.
  Most of it is the bundled Element Plus (2.2 MB) and Vue (0.4 MB, the
  production build and the development build that `el_page(dev = TRUE)`
  loads for debugging), bundled so apps work offline.

## Bundled third-party code

`inst/element-plus/` contains the Element Plus JavaScript/CSS distribution
and its icons (Element Plus team, MIT licence), and `inst/vue3/` Vue's
global builds (Evan You and Vue contributors, MIT licence). The copyright
holders are listed in `Authors@R` with role `cph`, and the licence texts are
reproduced in `LICENSE.note` and `inst/COPYRIGHTS`.
