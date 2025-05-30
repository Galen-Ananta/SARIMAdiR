# =================== Memanggil Library ===================
if (!require("shiny")) install.packages("shiny")
if (!require("forecast")) install.packages("forecast")
if (!require("tseries")) install.packages("tseries")

library(shiny)
library(forecast)
library(tseries)

# =================== UI ===================
ui <- fluidPage(
  titlePanel("SARIMA Forecasting App"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV", accept = ".csv"),
      selectInput("freq", "Frekuensi Data", choices = c("Harian" = 365, "Bulanan" = 12, "Tahunan" = 1)),
      numericInput("start_year", "Tahun Mulai", value = 2010),
      numericInput("start_period", "Periode Awal (misal: bulan atau hari)", value = 1),
      numericInput("horizon", "Berapa langkah ke depan ingin diprediksi?", value = 12, min = 1),
      actionButton("run", "Jalankan Prediksi")
    ),
    
    mainPanel(
      plotOutput("forecast_plot"),
      verbatimTextOutput("summary_out")
    )
  )
)

# =================== Server ===================
server <- function(input, output) {
  data_ts <- eventReactive(input$run, {
    req(input$file)
    df <- read.csv(input$file$datapath)
    freq <- as.numeric(input$freq)
    start <- c(input$start_year, input$start_period)
    ts(df[,1], start = start, frequency = freq)
  })
  
  model_fit <- eventReactive(input$run, {
    ts_data <- data_ts()
    auto.arima(ts_data)
  })
  
  forecast_result <- reactive({
    fit <- model_fit()
    forecast(fit, h = input$horizon)
  })
  
  output$forecast_plot <- renderPlot({
    plot(forecast_result())
  })
  
  output$summary_out <- renderPrint({
    summary(model_fit())
  })
}

# =================== Run App ===================
shinyApp(ui = ui, server = server)