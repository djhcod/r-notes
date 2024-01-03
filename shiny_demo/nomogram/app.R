# Load packages ------------------------------------
library(shiny)
library(bslib)
library(rms)
library(pec)
library(nomogramFormula)

# load dataset -------------------------------------
data_no_rad <- readRDS("data/data_no_rad.rds")
data_rad <- readRDS("data/data_rad.rds")

# build model --------------------------------------
dd <<- datadist(data_no_rad)
options(datadist = "dd")
model_no_rad <<- cph(Surv(time, dead == 1) ~ age + grade + tumor_size + his +
                       T_stage + N_stage + chemotherapy,
                     x = T, y = T,
                     data = data_no_rad,
                     surv = T)
nom_no_rad <<- nomogram(model_no_rad, maxscale = 100)



dd <<- datadist(data_rad)
options(datadist = "dd")
model_rad <<- cph(Surv(time, dead == 1) ~ age + grade + tumor_size + his + N_stage,
                  x = T, y = T,
                  data = data_rad,
                  surv = T)
nom_rad <<- nomogram(model_rad, maxscale = 100)




# load function--------------------------------------
source("function.R")



# User interface ------------------------------------
ui <- fluidPage(
  theme = bs_theme(bootswatch = "vapor"),

  h1(strong("OS Benefit"), "from Adjuvant Radiation Therapy in Uterine Sarcoma Patients",
     br(),
     a(href="https://github.com/rstudio/shiny", icon("github"), style = "color: black"),
     a(href="https://pubmed.ncbi.nlm.nih.gov/36469973/", icon("paperclip"), style = "color: black"),
     style = "color: black;
              text-align: left;
              background-image: url('banner4.jpeg');
              background-size: cover;
              padding: 100px"),
  br(),
  h6(a(href="https://github.com/rstudio/shiny", "Sorce code"),
     a(href="https://github.com/rstudio/shiny", icon("github")),
     "|",
     a(href="https://pubmed.ncbi.nlm.nih.gov/36469973/", "Published paper"),
     a(href="https://pubmed.ncbi.nlm.nih.gov/36469973/", icon("paperclip"))),
  br(),
  fluidRow(column(12,
                  h1("Abstract"),
                  p(span(strong("Adjuvant radiotherapy"), style = "color: pink"),
                    "has been commonly performed in uterine sarcoma
                    patients, but its role in overall survival (OS) remains controversial.
                    Therefore, our study aimed to build",
                    span(strong("a nomogram-based prognostic stratification"), style = "color:pink"),
                    "to identify uterine sarcoma patients who might benefit
                    from adjuvant radiotherapy."),
                  a(href="www.rstudio.com", "Published Article"))),

  fluidRow(column(4,
                  hr(),
                  wellPanel(

                    sliderInput(inputId = "age",
                                label = h3("Age (years)"),
                                min = 18,
                                max = 90,
                                value = 50))),
           column(4,
                  hr(),
                  wellPanel(
                    selectInput("grade",
                                label = h3("Grade"),
                                choices = list("Low-grade" = 1,
                                               "High-grade" = 2,
                                               "Unkonw" = 3),
                                selected = 1))),
           column(4,
                  hr(),
                  wellPanel(

                    sliderInput(inputId = "tumor_size",
                                label = h3("Tumor size (mm)"),
                                min = 1,
                                max = 300,
                                value = 50)))),
  fluidRow(column(4,
                  hr(),
                  wellPanel(
                    selectInput("his",
                                label = h3("Histology"),
                                choices = c("LMS (leiomyosarcoma)" = 1,
                                            "ESS (endometrial stromal sarcoma)" = 2,
                                            "Adenosarcoma" = 3),
                                selected = 1))),
           column(4,
                  hr(),
                  wellPanel(
                    selectInput("T_stage",
                                label = h3("T stage"),
                                choices = c("T1" = 1,
                                            "T2" = 2,
                                            "T3" = 3,
                                            "T4" = 4),
                                selected = 1))),
           column(4,
                  hr(),
                  wellPanel(
                    selectInput("N_stage",
                                label = h3("N stage"),
                                choices = c("N0" = 0,
                                            "N1" = 1),
                                selected = 0)))),
  fluidRow(column(4,
                  hr(),
                  wellPanel(
                    selectInput("chem",
                                label = h3("Chemotherapy"),
                                choices = c("No" = 0,
                                            "Yes" = 1),
                                selected = 0))),
           column(4,
                  hr(),
                  actionButton(inputId = "action",
                               label = "Predict!",
                               icon("lightbulb"),
                               width = "100%"))),
  fluidRow(column(12,
                  br(),
                  hr(),
                  h1("Results"),
                  br(),
                  wellPanel(
                    h4("Case report"),
                    tableOutput("case_report")),
                  br(),
                  hr(),
                  wellPanel(
                    h4("Total points"),
                    tableOutput(outputId = "points")),
                  br(),
                  hr(),
                  wellPanel(
                    h4("Predict OS"),
                    tableOutput(outputId = "predictions")))),

  p("Du Junhong Copyright 2023",
    style = "text-align: center")
)


# Server logic ----
server <- function(input, output, session) {
  observeEvent(
    input$action, {

      # 总结个案
      output$case_report <- renderTable({
        case <- data.frame(input$age, input$grade, input$tumor_size,
                           input$his, input$T_stage, input$N_stage,
                           input$chem)
        colnames(case) <- c("Age (years)", "Grade", "Tumor size", "Histology",
                            "T_stage", "N_stage", "Chemotherapy")
        print(case)
      },
      striped = T,
      hover = T,
      bordered = T,
      rownames = F,
      colnames = TRUE,
      digits = 2)


      # 计算总分
      output$points <- renderTable({
        age <- ifelse(input$age < 49, 1, ifelse(input$age <= 58, 2, 3))
        tumor_size <- ifelse(input$tumor_size < 70, 1,
                             ifelse(input$tumor_size <= 165, 2,
                                    ifelse(input$tumor_size < 200, 3, 4)))
        data_input <- data.frame("age" = as.numeric(age),
                                 "grade" = as.numeric(input$grade),
                                 "tumor_size" = as.numeric(tumor_size),
                                 "his" = as.numeric(input$his),
                                 "T_stage" = as.numeric(input$T_stage),
                                 "N_stage" = as.numeric(input$N_stage),
                                 "chemotherapy" = as.numeric(input$chem))
        nompoints(data_input)
      },
      striped = T,
      hover = T,
      bordered = T,
      rownames = F,
      colnames = TRUE,
      digits = 2)


      # 预测OS
      output$predictions <- renderTable({
        age <- ifelse(input$age < 49, 1, ifelse(input$age <= 58, 2, 3))
        tumor_size <- ifelse(input$tumor_size < 70, 1,
                             ifelse(input$tumor_size <= 165, 2,
                                    ifelse(input$tumor_size < 200, 3, 4)))
        data_input <- data.frame("age" = age,
                                 "grade" = input$grade,
                                 "tumor_size" = tumor_size,
                                 "his" = input$his,
                                 "T_stage" = input$T_stage,
                                 "N_stage" = input$N_stage,
                                 "chemotherapy" = input$chem)
        osbenefits(data_input)
      },
      striped = T,
      hover = T,
      bordered = T,
      rownames = T,
      colnames = TRUE,
      digits = 2
      )
    }
  )
}




# Run app ----
shinyApp(ui, server)

