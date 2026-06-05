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
