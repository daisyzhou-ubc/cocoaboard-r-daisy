library(shiny)
library(bslib)
library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)
library(scales)

# ---- Load & clean data ----
sales <- read_csv("data/Chocolate_Sales.csv", show_col_types = FALSE)

# Clean Amount column: remove "$" and "," then convert to numeric
sales <- sales |>
  mutate(
    Amount = as.numeric(gsub("[\\$,]", "", Amount)),
    Date = as.Date(Date, format = "%d/%m/%Y")
  ) |>
  rename(
    sales_person = `Sales Person`,
    country = Country,
    product = Product,
    date = Date,
    amount = Amount,
    boxes_shipped = `Boxes Shipped`
  )

# ---- UI ----
ui <- page_sidebar(
  theme = bs_theme(
    bg = "#FFF8F0",
    fg = "#3E2723",
    primary = "#5D4037",
    info = "#795548",
    base_font = font_google("Open Sans")
  ),
  title = "Chocolate Sales Dashboard",
  bg = "#FFF8F0",

  sidebar = sidebar(
    title = "Filters",
    selectInput(
      "country",
      "Country",
      choices = c("All", sort(unique(sales$country))),
      selected = "All"
    ),
    selectInput(
      "product",
      "Product",
      choices = c("All", sort(unique(sales$product))),
      selected = "All"
    )
  ),

  layout_columns(
    value_box(
      title = "Total Revenue",
      value = textOutput("total_revenue"),
      theme = "primary"
    ),
    value_box(
      title = "Total Boxes Shipped",
      value = textOutput("total_boxes"),
      theme = "info"
    ),
    col_widths = c(6, 6)
  ),

  layout_columns(
    card(
      card_header("Monthly Revenue Trend"),
      plotOutput("revenue_plot")
    ),
    card(
      card_header("Top 10 Sales Representatives"),
      tableOutput("leaderboard")
    ),
    col_widths = c(7, 5)
  )
)

# ---- Server ----
server <- function(input, output) {

  # Reactive calc: filtered dataframe
  filtered_df <- reactive({
    df <- sales

    if (input$country != "All") {
      df <- df |> filter(country == input$country)
    }

    if (input$product != "All") {
      df <- df |> filter(product == input$product)
    }

    df
  })

  # Output: Total Revenue value box
  output$total_revenue <- renderText({
    total <- sum(filtered_df()$amount, na.rm = TRUE)
    paste0("$", format(total, big.mark = ",", scientific = FALSE))
  })

  # Output: Total Boxes Shipped value box
  output$total_boxes <- renderText({
    total <- sum(filtered_df()$boxes_shipped, na.rm = TRUE)
    format(total, big.mark = ",")
  })

  # Output: Monthly revenue line chart
  output$revenue_plot <- renderPlot({
    monthly <- filtered_df() |>
      mutate(month = floor_date(date, "month")) |>
      group_by(month) |>
      summarise(revenue = sum(amount, na.rm = TRUE), .groups = "drop")

    ggplot(monthly, aes(x = month, y = revenue)) +
      geom_line(color = "#2C3E50", linewidth = 1) +
      geom_point(color = "#2C3E50", size = 2) +
      scale_y_continuous(labels = scales::dollar_format()) +
      labs(x = NULL, y = "Revenue") +
      theme_minimal(base_size = 14)
  })

  # Output: Top 10 salesperson leaderboard table
  output$leaderboard <- renderTable({
    filtered_df() |>
      group_by(sales_person) |>
      summarise(
        Revenue = sum(amount, na.rm = TRUE),
        Boxes = sum(boxes_shipped, na.rm = TRUE),
        .groups = "drop"
      ) |>
      arrange(desc(Revenue)) |>
      head(10) |>
      mutate(
        Rank = row_number(),
        Revenue = paste0("$", format(Revenue, big.mark = ","))
      ) |>
      select(Rank, `Sales Person` = sales_person, Revenue, Boxes)
  }, digits = 0)
}

shinyApp(ui = ui, server = server)
