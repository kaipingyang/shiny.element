# Generate a `<template>` tag for Vue/Element UI slot usage

Generate a `<template>` tag for Vue/Element UI slot usage

## Usage

``` r
template(..., slot = NULL, scope = NULL)
```

## Arguments

- ...:

  Content inside the template

- slot:

  Slot name (optional)

- scope:

  Slot scope or v-slot syntax (optional)

## Examples

``` r
# Basic usage with text
template("Hello World")
#> <template >Hello World</template>

# With slot name
template("Custom content", slot = "header")
#> <template slot="header">Custom content</template>

# With HTML tag content
template(shiny::tags$a(href = "https://posit.co", "Posit"), slot = "footer")
#> <template slot="footer"><a href="https://posit.co">Posit</a></template>

# Combine multiple tags
template(
  shiny::tags$span("A"),
  shiny::tags$span("B"),
  slot = "extra"
)
#> <template slot="extra"><span>A</span><span>B</span></template>

# Custom dateCell slot with check mark (Unicode)
template(
  shiny::tags$p(
    `:class` = "data.isSelected ? 'is-selected' : ''",
    "{{ data.day.split('-').slice(1).join('-') }}",
    shiny::tags$span("\u2714\ufe0f", `v-if` = "data.isSelected")
  ),
  slot = "dateCell",
  scope = "{date, data}"
)
#> <template slot="dateCell" slot-scope="{date, data}"><p :class="data.isSelected ? &#39;is-selected&#39; : &#39;&#39;">
#>   {{ data.day.split('-').slice(1).join('-') }}
#>   <span v-if="data.isSelected">✔️</span>
#> </p></template>
```
