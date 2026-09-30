# Screenshots for the examples in these articles.
#
# An example chunk is marked `shot = TRUE`. Its code is the only source of its
# picture: tools/article-shots.R finds the chunk, runs that code in a live
# Shiny app, and captures the result as pkgdown/assets/shots/<article>-<label>.png.
# The hook below puts the picture under the chunk, so an example cannot lose
# its screenshot, or show a screenshot of code that is no longer there.
#
# The pictures are only placed when pkgdown builds the site. A vignette built
# for CRAN would otherwise embed every one of them, and the package would
# carry megabytes of PNG; there it links to the site instead.

shot_article <- function() {
  sub("[.]Rmd$", "", basename(knitr::current_input(dir = FALSE)))
}

knitr::knit_hooks$set(shot = function(before, options) {
  if (before || !isTRUE(options$shot)) return(NULL)
  file <- sprintf("%s-%s.png", shot_article(), options$label)
  if (identical(Sys.getenv("IN_PKGDOWN"), "true")) {
    sprintf("\n\n![](../shots/%s)\n\n", file)
  } else {
    sprintf("\n\n[Screenshot](https://kaipingyang.github.io/shiny.element/shots/%s)\n\n",
            file)
  }
})
