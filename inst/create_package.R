library(devtools)
library(usethis)

Sys.getenv("GITHUB_PAT")

# usethis::use_description()
usethis::use_mit_license("Kaiping Yang")

usethis::use_package("shiny")
usethis::use_package("htmlwidgets")
usethis::use_package("jsonlite")
usethis::use_package("vueR")
usethis::use_package("uuid")
usethis::use_package("bslib")

usethis::use_import_from("shiny", "getDefaultReactiveDomain")
usethis::use_import_from("shiny", "tagList")
usethis::use_import_from("shiny", "tags")
usethis::use_import_from("shiny", "titlePanel")
usethis::use_import_from("htmltools", "tag")
usethis::use_import_from("stats", "na.omit")
usethis::use_import_from("htmlwidgets", "JS")
usethis::use_import_from("jsonlite", "toJSON")

devtools::document()

devtools::check()

devtools::load_all()
