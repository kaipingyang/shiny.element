## Test environments

* local Linux (container), R 4.4.3: `R CMD check --no-manual`, vignettes
  built
* win-builder (devel and release): to be run before submission

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.
* Installed size is about 4.6 MB (4612 KB measured with `du -k` on tmpfs).
  On the overlay filesystem of our development container `du` reports
  5.2 MB, and there the check notes the size; the files are the same.
  Most of it is the bundled Element Plus (2.2 MB) and Vue (0.4 MB, the
  production build and the development build that `el_page(dev = TRUE)`
  loads for debugging), bundled so apps work offline.

## Bundled third-party code

`inst/element-plus/` contains the Element Plus JavaScript/CSS distribution
and its icons (Element Plus team, MIT licence), and `inst/vue3/` Vue's
global builds (Evan You and Vue contributors, MIT licence). The copyright
holders are listed in `Authors@R` with role `cph`, and the licence texts are
reproduced in `LICENSE.note` and `inst/COPYRIGHTS`.
