# A sales overview: filters in the header, headline numbers in cards, a
# chart and a ranked table, all following the filters.
#
#   shiny::runApp(system.file("examples/dashboards/sales", package = "shiny.element"))

library(shiny)
library(shiny.element)

set.seed(42)
months  <- seq(as.Date("2026-01-01"), by = "month", length.out = 9)
regions <- c("North", "South", "East", "West")
products <- c("Laptops", "Monitors", "Keyboards", "Headsets", "Docks", "Webcams")
sales <- expand.grid(month = months, region = regions, product = products,
                     stringsAsFactors = FALSE)
sales$revenue <- round(runif(nrow(sales), 2, 30) * 1000)
sales$orders  <- round(sales$revenue / runif(nrow(sales), 80, 160))

kpi_card <- function(id, title, prefix = NULL, suffix = NULL, precision = 0) {
  el_col(span = 6, el_card(shadow = "hover",
    el_statistic(id, value = 0, title = title, prefix = prefix,
                 suffix = suffix, precision = precision, group_separator = ",")))
}

ui <- el_page(
  el_container(
    el_header(
      style = "display: flex; align-items: center; justify-content: space-between;
               border-bottom: 1px solid #ebeef5",
      tags$h3("Sales overview", style = "margin: 0"),
      tags$div(style = "display: flex; gap: 10px",
        el_date_picker("span", type = "monthrange", value = c("2026-01", "2026-09"),
                       value_format = "yyyy-MM", format = "yyyy-MM",
                       start_placeholder = "From", end_placeholder = "To",
                       width = "260px", size = "small"),
        el_select("region", choices = regions, selected = regions, multiple = TRUE,
                  collapse_tags = TRUE, size = "small", width = "220px"))
    ),
    el_main(
      el_row(gutter = 16,
        kpi_card("revenue", "Revenue", prefix = "$"),
        kpi_card("orders", "Orders"),
        kpi_card("basket", "Average order", prefix = "$", precision = 2),
        kpi_card("best", "Best month, share of revenue", suffix = "%", precision = 1)
      ),
      el_row(gutter = 16, style = "margin-top: 16px",
        el_col(span = 14, el_card(header = "Revenue by month",
          plotOutput("trend", height = "260px"))),
        el_col(span = 10, el_card(header = "Products",
          el_table("products", border = FALSE, columns = list(
            list(type = "index", label = "#", width = "50"),
            list(prop = "product", label = "Product"),
            list(prop = "revenue", label = "Revenue", align = "right",
                 formatter = htmlwidgets::JS(
                   "function(r, c, v) { return '$' + v.toLocaleString(); }")),
            list(prop = "share", label = "Share", width = "130",
                 cell = el$progress(":percentage" = "scope.row.share",
                                    ":stroke-width" = "8"))
          ))))
      )
    )
  )
)

server <- function(input, output, session) {
  # Both filters report on load; until they have, there is nothing to show
  picked <- reactive({
    req(input$span, input$region)
    span <- as.Date(paste0(input$span, "-01"))
    sales[sales$month >= span[1] & sales$month <= span[2] &
            sales$region %in% input$region, ]
  })

  observe({
    d <- picked()
    req(nrow(d) > 0)
    by_month <- tapply(d$revenue, d$month, sum)
    update_el_statistic(session, "revenue", value = sum(d$revenue))
    update_el_statistic(session, "orders", value = sum(d$orders))
    update_el_statistic(session, "basket",
                        value = if (sum(d$orders)) sum(d$revenue) / sum(d$orders) else 0)
    update_el_statistic(session, "best",
                        value = if (length(by_month)) 100 * max(by_month) / sum(by_month) else 0)

    by_product <- aggregate(revenue ~ product, d, sum)
    by_product <- by_product[order(-by_product$revenue), ]
    by_product$share <- round(100 * by_product$revenue / sum(by_product$revenue))
    update_el_table(session, "products", data = by_product)
  })

  output$trend <- renderPlot({
    d <- picked()
    req(nrow(d) > 0)
    by_month <- tapply(d$revenue, format(d$month, "%b"), sum)[format(unique(sort(d$month)), "%b")]
    par(mar = c(3, 4, 1, 1), family = "sans", col.axis = "#606266", fg = "#dcdfe6")
    barplot(by_month / 1000, col = "#409EFF", border = NA, las = 1,
            ylab = "Revenue ($k)", col.lab = "#606266")
  })
}

shinyApp(ui, server)
