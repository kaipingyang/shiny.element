# Every example in the articles is a chunk marked shot = TRUE, and has the
# screenshot tools/article-shots.R takes of it. The picture comes from the
# chunk's own code, so the two cannot drift -- but a new example written as a
# plain ```r block, or never run through the script, would have no picture.
#
# The articles and the screenshots are not in the built package, so this only
# runs from a source checkout.

vignette_dir <- testthat::test_path("..", "..", "vignettes")
shots_dir <- testthat::test_path("..", "..", "pkgdown", "assets", "shots")

test_that("every code example in the articles is a screenshot chunk", {
  skip_if_not(dir.exists(vignette_dir), "not a source checkout")

  plain <- character(0)
  for (f in list.files(
    vignette_dir,
    pattern = "[.]Rmd$",
    full.names = TRUE,
    recursive = TRUE
  )) {
    lines <- readLines(f, warn = FALSE)
    hits <- grep("^```r\\s*$", lines)
    if (length(hits)) plain <- c(plain, paste0(basename(f), ":", hits))
  }
  expect_equal(plain, character(0))
})

test_that("every screenshot chunk has its screenshot", {
  skip_if_not(dir.exists(vignette_dir), "not a source checkout")
  skip_if_not(dir.exists(shots_dir), "screenshots not generated")

  missing <- character(0)
  for (f in list.files(
    vignette_dir,
    pattern = "[.]Rmd$",
    full.names = TRUE,
    recursive = TRUE
  )) {
    article <- sub("[.]Rmd$", "", basename(f))
    headers <- grep(
      "^```\\{r [^}]*shot = TRUE",
      readLines(f, warn = FALSE),
      value = TRUE
    )
    # paste0() with no labels would still give "<article>-"
    if (!length(headers)) {
      next
    }
    labels <- sub("^```\\{r ([A-Za-z0-9_-]+).*$", "\\1", headers)
    png <- file.path(shots_dir, paste0(article, "-", labels, ".png"))
    missing <- c(missing, basename(png)[!file.exists(png)])
  }
  expect_equal(missing, character(0))
})
