# The default el_theme() compiled, shipped so that a machine with no sass
# cache yet draws el_page() without compiling it (R/el_theme_cache.R).
#
#   Rscript tools/el-theme-css.R             # against CRAN's bslib and sass
#   Rscript tools/el-theme-css.R --installed # against the ones installed
#
# The CSS is used only where the installed bslib and sass are the versions
# it was compiled with (inst/el-theme/versions.json): another Bootstrap
# would not match bslib's own JavaScript. Run it before a release, against
# the bslib and sass on CRAN then -- the ones users will have.

args <- commandArgs(TRUE)
pkg <- normalizePath(".")
lib <- NULL
if (!"--installed" %in% args) {
  lib <- file.path(tempdir(), "el-theme-lib")
  dir.create(lib, showWarnings = FALSE)
  # bslib and sass as CRAN has them, with what they need
  utils::install.packages(
    c("bslib", "sass"),
    lib = lib,
    repos = "https://cloud.r-project.org",
    quiet = TRUE
  )
}
out <- callr::r(
  function(pkg, lib) {
    if (!is.null(lib)) {
      .libPaths(c(lib, .libPaths()))
    }
    pkgload::load_all(pkg, quiet = TRUE, helpers = FALSE)
    deps <- bslib::bs_theme_dependencies(el_theme(), cache = FALSE)
    boot <- Filter(function(d) d$name == "bootstrap", deps)[[1]]
    list(
      css = readBin(
        file.path(boot$src$file, "bootstrap.min.css"),
        "raw",
        1e8
      ),
      bslib = as.character(utils::packageVersion("bslib")),
      sass = as.character(utils::packageVersion("sass"))
    )
  },
  args = list(pkg = pkg, lib = lib)
)
dir <- file.path(pkg, "inst", "el-theme")
dir.create(dir, showWarnings = FALSE)
con <- gzfile(file.path(dir, "bootstrap.min.css.gz"), "wb", compression = 9)
writeBin(out$css, con)
close(con)
writeLines(
  jsonlite::toJSON(
    list(bslib = out$bslib, sass = out$sass),
    auto_unbox = TRUE,
    pretty = TRUE
  ),
  file.path(dir, "versions.json")
)
message(sprintf(
  "inst/el-theme: %d bytes of CSS (%d gzipped), bslib %s, sass %s",
  length(out$css),
  file.size(file.path(dir, "bootstrap.min.css.gz")),
  out$bslib,
  out$sass
))
