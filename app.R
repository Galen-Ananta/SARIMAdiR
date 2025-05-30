
library(shiny)

ui <- fluidPage(
  titlePanel("Prediksi Sederhana"),
  sidebarLayout(
    sidebarPanel(
      numericInput("nilai", "Masukkan angka:", 1)
    ),
    mainPanel(
      textOutput("hasil")
    )
  )
)

server <- function(input, output) {
  output$hasil <- renderText({
    paste("Hasil dikali 2 adalah:", input$nilai * 2)
  })
}

shinyApp(ui = ui, server = server)
