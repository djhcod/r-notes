# Load packages ----
library(shiny)
library(maps)
library(mapproj)
# Load data ----
counties <- readRDS("data/counties.rds")
# Source helper functions -----
source("helpers.R")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census."),
      selectInput("var",
                  label = "选择人种",
                  choices = c("白人比例",
                              "黑人比例",
                              "西班牙裔比例",
                              "亚裔比例"),
                  selected = "白人比例"),

      sliderInput("range",
                  label = "感兴趣的范围:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    mainPanel(plotOutput("map"))
  )
)




# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    args <- switch(input$var,
                   "白人比例" = list(counties$white, "darkgreen", "白人比例"),
                   "黑人比例" = list(counties$black, "black", "黑人比例"),
                   "西班牙裔比例" = list(counties$hispanic, "darkorange", "西班牙裔比例"),
                   "亚裔比例" = list(counties$asian, "darkviolet", "亚裔比例"))
    args$min <- input$range[1]
    args$max <- input$range[2]
    do.call(percent_map, args)
  })
}

# Run app ----
shinyApp(ui, server)
