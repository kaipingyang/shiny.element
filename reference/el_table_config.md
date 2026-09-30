# Prepare Data for Element Table

Prepare Data for Element Table

## Usage

``` r
el_table_config(df, max_rows = NULL, add_name = TRUE)
```

## Arguments

- df:

  Data frame

- max_rows:

  Max rows to show

- add_name:

  Add row names

## Value

List with data and columns

## Details

Superseded:
[`el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table.md)
now accepts a data.frame directly and infers its columns, so this helper
is only needed for its extra behaviour (dropping incomplete rows,
capping row count, prepending a row-name column).

Note it drops rows with any `NA` via
[`stats::na.omit()`](https://rdrr.io/r/stats/na.fail.html) and
overwrites a column literally named `name` when `add_name = TRUE`.

## Examples

``` r
cfg <- el_table_config(head(iris, 3))
str(cfg$columns, max.level = 2)
#> List of 6
#>  $ :List of 3
#>   ..$ prop : chr "name"
#>   ..$ label: chr "row_name"
#>   ..$ width: chr "150"
#>  $ :List of 3
#>   ..$ prop : chr "Sepal_Length"
#>   ..$ label: chr "Sepal.Length (numeric)"
#>   ..$ width: chr "100"
#>  $ :List of 3
#>   ..$ prop : chr "Sepal_Width"
#>   ..$ label: chr "Sepal.Width (numeric)"
#>   ..$ width: chr "100"
#>  $ :List of 3
#>   ..$ prop : chr "Petal_Length"
#>   ..$ label: chr "Petal.Length (numeric)"
#>   ..$ width: chr "100"
#>  $ :List of 3
#>   ..$ prop : chr "Petal_Width"
#>   ..$ label: chr "Petal.Width (numeric)"
#>   ..$ width: chr "100"
#>  $ :List of 3
#>   ..$ prop : chr "Species"
#>   ..$ label: chr "Species (factor)"
#>   ..$ width: chr "120"

# Cap the rows and leave out the row-name column
el_table_config(iris, max_rows = 5, add_name = FALSE)
#> $data
#> $data[[1]]
#> $data[[1]]$Sepal_Length
#> [1] 5.1
#> 
#> $data[[1]]$Sepal_Width
#> [1] 3.5
#> 
#> $data[[1]]$Petal_Length
#> [1] 1.4
#> 
#> $data[[1]]$Petal_Width
#> [1] 0.2
#> 
#> $data[[1]]$Species
#> [1] "setosa"
#> 
#> 
#> $data[[2]]
#> $data[[2]]$Sepal_Length
#> [1] 4.9
#> 
#> $data[[2]]$Sepal_Width
#> [1] 3
#> 
#> $data[[2]]$Petal_Length
#> [1] 1.4
#> 
#> $data[[2]]$Petal_Width
#> [1] 0.2
#> 
#> $data[[2]]$Species
#> [1] "setosa"
#> 
#> 
#> $data[[3]]
#> $data[[3]]$Sepal_Length
#> [1] 4.7
#> 
#> $data[[3]]$Sepal_Width
#> [1] 3.2
#> 
#> $data[[3]]$Petal_Length
#> [1] 1.3
#> 
#> $data[[3]]$Petal_Width
#> [1] 0.2
#> 
#> $data[[3]]$Species
#> [1] "setosa"
#> 
#> 
#> $data[[4]]
#> $data[[4]]$Sepal_Length
#> [1] 4.6
#> 
#> $data[[4]]$Sepal_Width
#> [1] 3.1
#> 
#> $data[[4]]$Petal_Length
#> [1] 1.5
#> 
#> $data[[4]]$Petal_Width
#> [1] 0.2
#> 
#> $data[[4]]$Species
#> [1] "setosa"
#> 
#> 
#> $data[[5]]
#> $data[[5]]$Sepal_Length
#> [1] 5
#> 
#> $data[[5]]$Sepal_Width
#> [1] 3.6
#> 
#> $data[[5]]$Petal_Length
#> [1] 1.4
#> 
#> $data[[5]]$Petal_Width
#> [1] 0.2
#> 
#> $data[[5]]$Species
#> [1] "setosa"
#> 
#> 
#> 
#> $columns
#> $columns[[1]]
#> $columns[[1]]$prop
#> [1] "name"
#> 
#> $columns[[1]]$label
#> [1] "row_name"
#> 
#> $columns[[1]]$width
#> [1] "150"
#> 
#> 
#> $columns[[2]]
#> $columns[[2]]$prop
#> [1] "Sepal_Length"
#> 
#> $columns[[2]]$label
#> [1] "Sepal.Length (numeric)"
#> 
#> $columns[[2]]$width
#> [1] "100"
#> 
#> 
#> $columns[[3]]
#> $columns[[3]]$prop
#> [1] "Sepal_Width"
#> 
#> $columns[[3]]$label
#> [1] "Sepal.Width (numeric)"
#> 
#> $columns[[3]]$width
#> [1] "100"
#> 
#> 
#> $columns[[4]]
#> $columns[[4]]$prop
#> [1] "Petal_Length"
#> 
#> $columns[[4]]$label
#> [1] "Petal.Length (numeric)"
#> 
#> $columns[[4]]$width
#> [1] "100"
#> 
#> 
#> $columns[[5]]
#> $columns[[5]]$prop
#> [1] "Petal_Width"
#> 
#> $columns[[5]]$label
#> [1] "Petal.Width (numeric)"
#> 
#> $columns[[5]]$width
#> [1] "100"
#> 
#> 
#> $columns[[6]]
#> $columns[[6]]$prop
#> [1] "Species"
#> 
#> $columns[[6]]$label
#> [1] "Species (factor)"
#> 
#> $columns[[6]]$width
#> [1] "120"
#> 
#> 
#> 
```
