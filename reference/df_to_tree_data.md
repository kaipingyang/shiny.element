# Build tree data from a data frame

Turns hierarchical columns into the nested node lists
[`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md)
expects, one level per column. Keys are built by joining a row's values
down to that level, so a label repeated under different parents still
gets a unique key.

## Usage

``` r
df_to_tree_data(df, cols, sep = "/")
```

## Arguments

- df:

  A data frame.

- cols:

  Column names, outermost level first.

- sep:

  Separator used when joining values into a key.

## Value

A list of nodes.

## Examples

``` r
df <- data.frame(
  region  = c("North", "North", "South"),
  city    = c("Leeds", "York", "Bath"),
  stringsAsFactors = FALSE
)
df_to_tree_data(df, c("region", "city"))
#> [[1]]
#> [[1]]$id
#> [1] "North"
#> 
#> [[1]]$label
#> [1] "North"
#> 
#> [[1]]$children
#> [[1]]$children[[1]]
#> [[1]]$children[[1]]$id
#> [1] "North/Leeds"
#> 
#> [[1]]$children[[1]]$label
#> [1] "Leeds"
#> 
#> 
#> [[1]]$children[[2]]
#> [[1]]$children[[2]]$id
#> [1] "North/York"
#> 
#> [[1]]$children[[2]]$label
#> [1] "York"
#> 
#> 
#> 
#> 
#> [[2]]
#> [[2]]$id
#> [1] "South"
#> 
#> [[2]]$label
#> [1] "South"
#> 
#> [[2]]$children
#> [[2]]$children[[1]]
#> [[2]]$children[[1]]$id
#> [1] "South/Bath"
#> 
#> [[2]]$children[[1]]$label
#> [1] "Bath"
#> 
#> 
#> 
#> 
```
