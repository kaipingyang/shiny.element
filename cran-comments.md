## Test environments

* local Linux (container), R 4.4.3: `R CMD check --as-cran`, vignettes
  built
* GitHub Actions (R-CMD-check.yaml): macOS and Windows (R release), Ubuntu
  (R devel, release and oldrel-1)
* win-builder: R-release (R 4.6.1 ucrt) and R-devel (2026-09-30 r90605 ucrt)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

The note is "New submission", on win-builder and in our own checks alike.

* Installed size: 4.6 MB on a tmpfs build directory (block allocation as
  on ext4), under the 5 MB threshold; on filesystems with larger blocks
  `du` counts the same files larger and a size note may appear. Most of it
  is the bundled Element Plus (2.1 MB) and Vue (0.4 MB, the production
  build and the development build that `el_page(dev = TRUE)` loads for
  debugging), bundled so apps work offline.
* The browser tests (headless Chromium) skip on CRAN; they run on every
  push in GitHub Actions (browser.yaml).

## Bundled third-party code

`inst/element-plus/` contains the Element Plus JavaScript/CSS distribution
and its icons (Element Plus team, MIT licence), and `inst/vue3/` Vue's
global builds (Evan You and Vue contributors, MIT licence). The copyright
holders are listed in `Authors@R` with role `cph`, and the licence texts are
reproduced in `LICENSE.note` and `inst/COPYRIGHTS`.
