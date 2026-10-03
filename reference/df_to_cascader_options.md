# Convert a data.frame with custom value/label columns to Element-UI Cascader options list

Convert a data.frame with custom value/label columns to Element-UI
Cascader options list

## Usage

``` r
df_to_cascader_options(df, value_cols, label_cols = NULL)
```

## Arguments

- df:

  Data frame with hierarchical columns

- value_cols:

  Character vector of value column names (e.g. c("value1", "value2",
  ...))

- label_cols:

  Character vector of label column names (e.g. c("label1", "label2",
  ...)), can be NULL or contain NA for levels without label

## Value

Nested list for cascader options

## Examples

``` r
df <- data.frame(
  province = c("Zhejiang", "Zhejiang", "Jiangsu"),
  city = c("Hangzhou", "Ningbo", "Nanjing"),
  stringsAsFactors = FALSE
)
df_to_cascader_options(df, c("province", "city"))
#> [[1]]
#> [[1]]$value
#> [1] "Jiangsu"
#> 
#> [[1]]$label
#> [1] "Jiangsu"
#> 
#> [[1]]$children
#> [[1]]$children[[1]]
#> [[1]]$children[[1]]$value
#> [1] "Nanjing"
#> 
#> [[1]]$children[[1]]$label
#> [1] "Nanjing"
#> 
#> 
#> 
#> 
#> [[2]]
#> [[2]]$value
#> [1] "Zhejiang"
#> 
#> [[2]]$label
#> [1] "Zhejiang"
#> 
#> [[2]]$children
#> [[2]]$children[[1]]
#> [[2]]$children[[1]]$value
#> [1] "Hangzhou"
#> 
#> [[2]]$children[[1]]$label
#> [1] "Hangzhou"
#> 
#> 
#> [[2]]$children[[2]]
#> [[2]]$children[[2]]$value
#> [1] "Ningbo"
#> 
#> [[2]]$children[[2]]$label
#> [1] "Ningbo"
#> 
#> 
#> 
#> 

# Separate value and label columns
df$province_label <- paste(df$province, "Province")
df_to_cascader_options(df, c("province", "city"), c("province_label", NA))
#> [[1]]
#> [[1]]$value
#> [1] "Jiangsu"
#> 
#> [[1]]$label
#> [1] "Jiangsu Province"
#> 
#> [[1]]$children
#> [[1]]$children[[1]]
#> [[1]]$children[[1]]$value
#> [1] "Nanjing"
#> 
#> [[1]]$children[[1]]$label
#> [1] "Nanjing"
#> 
#> 
#> 
#> 
#> [[2]]
#> [[2]]$value
#> [1] "Zhejiang"
#> 
#> [[2]]$label
#> [1] "Zhejiang Province"
#> 
#> [[2]]$children
#> [[2]]$children[[1]]
#> [[2]]$children[[1]]$value
#> [1] "Hangzhou"
#> 
#> [[2]]$children[[1]]$label
#> [1] "Hangzhou"
#> 
#> 
#> [[2]]$children[[2]]
#> [[2]]$children[[2]]$value
#> [1] "Ningbo"
#> 
#> [[2]]$children[[2]]$label
#> [1] "Ningbo"
#> 
#> 
#> 
#> 
```
