library(shiny)
library(forecast)
library(ggplot2)
library(zoo)

load("agriculture_analysis_data.RData")

# Define Shiny app UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML(
      "body {font-family: Arial, sans-serif; background-color: #f8f9fa;}
      .title {color: #000000; text-align: center; margin-bottom: 20px;}
      .sidebar {background-color: #ffffff; padding: 20px; border-radius: 10px; box-shadow: 0px 4px 6px rgba(0,0,0,0.1);}
      .btn-primary {background-color: #007bff; border-color: #007bff;}
      .main-panel {padding: 20px; background-color: #ffffff; border-radius: 10px; box-shadow: 0px 4px 6px rgba(0,0,0,0.1);}"))
  ),
  titlePanel(tags$h1("Dynamic Prediction of Agriculture PPI", class = "title")),
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      numericInput("year", "Enter Target Year:", value = 2025, min = 2023, max = 2035),
      numericInput("month", "Enter Target Month:", value = 12, min = 1, max = 12),
      numericInput("mining_adjust", "Adjust Mining PPI (%):", value = 10, min = 0, max = 100, step = 1),
      numericInput("history_points", "Number of Historical Points to Include:", value = 80, min = 50, max = 200),
      numericInput("threshold", "Set Threshold for Volatility Alert:", value = 180, min = 50, max = 200),
      actionButton("predict", "Generate", class = "btn btn-primary"),
      p("Choose the target year, month, and parameters, then click 'Generate'.", style = "color: #6c757d; font-size: 14px;")
    ),
    mainPanel(
      class = "main-panel",
      tabsetPanel(
        tabPanel("Forecast Visualization", plotOutput("forecastPlot", height = "500px")),
        tabPanel("Additional Analysis",
                 fluidRow(
                   column(12, plotOutput("uncertaintyPlot", height = "400px")),
                   column(12, plotOutput("sensitivityPlot", height = "400px"))
                 ),
                 verbatimTextOutput("alertMessage")
        )
      )
    )
  )
)

# Define Shiny app server logic
server <- function(input, output) {
  forecast_result <- eventReactive(input$predict, {
    tryCatch({
      arima_model <- auto.arima(agriculture_ts)
      current_date <- Sys.Date()
      target_date <- as.Date(paste0(input$year, "-", input$month, "-01"))
      months_ahead <- as.integer(12 * (as.numeric(format(target_date, "%Y")) - as.numeric(format(current_date, "%Y"))) +
                                   (as.numeric(format(target_date, "%m")) - as.numeric(format(current_date, "%m"))))
      if (months_ahead <= 0) stop("Error: Target date must be in the future.")
      forecast(arima_model, h = months_ahead)
    }, error = function(e) {
      cat("Error in forecast_result: ", e$message, "\n")
      NULL
    })
  })
  
  sensitivity_analysis <- reactive({
    sensitivity_test <- testData_selected
    # Ensure mining column is numeric
    sensitivity_test$mining <- as.numeric(unlist(sensitivity_test$mining))
    sensitivity_test$mining <- sensitivity_test$mining * (1 + input$mining_adjust / 100)
    sensitivity_predictions <- predict(rf_results$model, sensitivity_test)
    data.frame(Actual = testData_selected$agriculture, Predicted = sensitivity_predictions)
  })
  
  output$forecastPlot <- renderPlot({
    req(forecast_result())
    autoplot(forecast_result(), series = "Forecast", linewidth = 1) +
      geom_line(color = "#2E8B57", linewidth = 1.2) +
      ggtitle(paste("Dynamic Forecast for Agriculture PPI in", "Year:", input$year, "& Month:", input$month)) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12),
        panel.grid.major = element_line(color = "gray80", linetype = "dashed"),
        panel.grid.minor = element_blank()
      ) +
      xlab("Year") + ylab("Agriculture PPI")
  })
  
  output$uncertaintyPlot <- renderPlot({
    req(forecast_result())
    autoplot(forecast_result(), include = input$history_points) +
      ggtitle("Prediction with Confidence Intervals") +
      xlab("Year") + ylab("Agriculture PPI") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12),
        panel.grid.major = element_line(color = "gray80", linetype = "dashed"),
        panel.grid.minor = element_blank()
      )
  })
  
  output$sensitivityPlot <- renderPlot({
    sensitivity_data <- sensitivity_analysis()
    ggplot(sensitivity_data, aes(x = Actual, y = Predicted)) +
      geom_point() +
      geom_abline(intercept = 0, slope = 1, color = "red") +
      ggtitle("Sensitivity Analysis: Mining PPI Adjusted") +
      xlab("Actual Agriculture PPI") + ylab("Predicted Agriculture PPI") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 12),
        panel.grid.major = element_line(color = "gray80", linetype = "dashed"),
        panel.grid.minor = element_blank()
      )
  })
  
  output$alertMessage <- renderPrint({
    req(forecast_result())
    threshold <- input$threshold
    if (any(forecast_result()$mean > threshold)) {
      cat("Alert: Projected PPI exceeds threshold! Consider policy interventions.\n")
    } else {
      cat("No significant price volatility detected.\n")
    }
  })
}

shinyApp(ui = ui, server = server)
