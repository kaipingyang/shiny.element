# Element UI Tags (auto-generated, pure tag generators)

Provides a list of functions for generating Element UI tags (el-\*),
similar to `tags$p`. These functions do not create Vue instances or
Shiny bindings.

## Usage

``` r
el
```

## Format

An object of class `list` of length 82.

## Details

Categories:

- Basic: button, link, icon

- Layout: container, header, aside, main, footer, row, col

- Form: form, form-item, input, input-number, radio, radio-group,
  radio-button, checkbox, checkbox-group, switch, select, option,
  option-group, cascader, cascader-panel, slider, time-picker,
  time-select, date-picker, upload, rate, color-picker, transfer,
  autocomplete

- Data: table, table-column, tag, progress, tree, pagination, badge,
  avatar, calendar, card, carousel, carousel-item, collapse,
  collapse-item, timeline, timeline-item, divider, image, empty,
  skeleton, result, statistic, descriptions, descriptions-item

- Navigation: menu, submenu, menu-item, menu-item-group, tabs, tab-pane,
  breadcrumb, breadcrumb-item, dropdown, dropdown-menu, dropdown-item,
  steps, step, page-header, backtop, anchor, anchor-link

- Feedback: dialog, alert, drawer, popover, tooltip, popconfirm, loading

## Examples

``` r
# List all available Element UI tag generators
names(el)
#>  [1] "button"            "link"              "icon"             
#>  [4] "container"         "header"            "aside"            
#>  [7] "main"              "footer"            "row"              
#> [10] "col"               "form"              "form_item"        
#> [13] "input"             "input_number"      "radio"            
#> [16] "radio_group"       "radio_button"      "checkbox"         
#> [19] "checkbox_group"    "switch"            "select"           
#> [22] "option"            "option_group"      "cascader"         
#> [25] "cascader_panel"    "slider"            "time_picker"      
#> [28] "time_select"       "date_picker"       "upload"           
#> [31] "rate"              "color_picker"      "transfer"         
#> [34] "autocomplete"      "table"             "table_column"     
#> [37] "tag"               "progress"          "tree"             
#> [40] "pagination"        "badge"             "avatar"           
#> [43] "calendar"          "card"              "carousel"         
#> [46] "carousel_item"     "collapse"          "collapse_item"    
#> [49] "timeline"          "timeline_item"     "divider"          
#> [52] "image"             "empty"             "skeleton"         
#> [55] "result"            "statistic"         "descriptions"     
#> [58] "descriptions_item" "menu"              "submenu"          
#> [61] "menu_item"         "menu_item_group"   "tabs"             
#> [64] "tab_pane"          "breadcrumb"        "breadcrumb_item"  
#> [67] "dropdown"          "dropdown_menu"     "dropdown_item"    
#> [70] "steps"             "step"              "page_header"      
#> [73] "backtop"           "anchor"            "anchor_link"      
#> [76] "dialog"            "alert"             "drawer"           
#> [79] "popover"           "tooltip"           "popconfirm"       
#> [82] "loading"          

# Use with auto-generated tag functions
el$button("Submit", type = "primary")
#> <el-button type="primary">Submit</el-button>
el$table(
  el$table_column(prop = "name", label = "Name"),
  el$table_column(prop = "age", label = "Age")
)
#> <el-table>
#>   <el-table-column prop="name" label="Name"></el-table-column>
#>   <el-table-column prop="age" label="Age"></el-table-column>
#> </el-table>
el$icon("star")
#> <i class="el-icon-star"></i>
```
