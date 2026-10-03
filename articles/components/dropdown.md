# Dropdown

Toggleable menu for displaying lists of links and actions.

## Basic usage

Hover on the dropdown menu to unfold it for more actions.

The triggering element is rendered by the default `slot`, and the
dropdown part is rendered by the `slot` named `dropdown`. By default,
dropdown list shows when you hover on the triggering element without
having to click it.

``` r

items <- list(list(command = "a", label = "Action 1"), list(command = "b", label = "Action 2"),
              list(command = "c", label = "Action 3"),
              list(command = "d", label = "Action 4", disabled = TRUE),
              list(command = "e", label = "Action 5", divided = TRUE))
el_dropdown("dd", trigger_label = "Dropdown List", items = items)
```

## Placement

Support 6 placements.

Set `placement` property to make dropdown appear in different locations.

``` r

items <- list(list(command = "1", label = "The Action 1st"), list(command = "2", label = "The Action 2nd"),
              list(command = "3", label = "The Action 3rd"))
tags$div(style = "display: flex; flex-wrap: wrap; gap: 16px",
  lapply(c("top-start", "top", "top-end", "bottom-start", "bottom", "bottom-end"), function(p)
    el_dropdown(paste0("dd_", p), placement = p, items = items,
                trigger_label = el_button(paste0("ddb_", p), p))))
```

The Action 1stThe Action 2ndThe Action 3rd

The Action 1stThe Action 2ndThe Action 3rd
