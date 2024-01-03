# Load packages ----
library(shiny)
library(quantmod)

# Source helpers ----
source("helpers.R")

# User interface ----
ui <- fluidPage(
  titlePanel("stockVis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine. Information will be collected from Yahoo finance."),
      textInput(inputId = "symb",
                label = "Symbol",
                value = "SPY"),
      dateRangeInput(inputId = "dates",
                     label = "Date range",
                     start = "2013-01-01",
                     end = as.character(Sys.Date())),
      br(),
      br(),
      checkboxInput(inputId = "log",
                    label = "Plot y axis on log scale",
                    value = FALSE),
      checkboxInput(inputId = "adjust",
                    label = "Adjust prices for inflation",
                    value = FALSE)
    ),
    mainPanel(plotOutput("plot"))
  )
)

# Server logic
server <- function(input, output) {
  dataInput <- reactive({
    getSymbols(input$symb,
               src = "yahoo",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })
  output$plot <- renderPlot({
    chartSeries(finalInput(),
                theme = chartTheme("white"),
                type = "line",
                log.scale = input$log,
                TA = NULL)
  })
}








# Run the app
shinyApp(ui, server)
