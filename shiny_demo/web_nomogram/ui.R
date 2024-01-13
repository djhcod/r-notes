# User interface ------------------------------------
ui <- fluidPage(
  theme = bs_theme(bootswatch = "vapor"),

  h1(strong("OS Benefit"), "from Adjuvant Radiation Therapy in Type II-EC",
     br(),
     a(href="https://github.com/rstudio/shiny", icon("github"), style = "color: black"),
     a(href="https://pubmed.ncbi.nlm.nih.gov/36469973/", icon("paperclip"), style = "color: black"),
     style = "color: black;
              text-align: left;
              background-image: url('banner.jpeg');
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
  hr(),
  fluidRow(column(4,
                  wellPanel(

                    sliderInput(inputId = "age",
                                label = h3("Age (years)"),
                                min = 18,
                                max = 90,
                                value = 50))),
           column(4,
                  wellPanel(
                    selectInput("grade",
                                label = h3("Grade"),
                                choices = list("Low-grade" = 1,
                                               "High-grade" = 2,
                                               "Gx" = 3),
                                selected = 1))),
           column(4,
                  wellPanel(
                    sliderInput(inputId = "tumor_size",
                                label = h3("Tumor size (mm)"),
                                min = 1,
                                max = 300,
                                value = 50)))),
  fluidRow(column(4,
                  wellPanel(
                    selectInput("his",
                                label = h3("Histology"),
                                choices = c("Serous" = 1,
                                            "Carcinosarcoma" = 2,
                                            "Clear Cell" = 3,
                                            "Mixed epithelial" = 4),
                                selected = 1))),
           column(4,
                  wellPanel(
                    selectInput("figo",
                                label = h3("FIGO stage"),
                                choices = c("FIGO I" = 1,
                                            "FIGO II" = 2),
                                selected = 1))),
           column(4,
                  wellPanel(
                    selectInput("lnd",
                                label = h3("Lymphadenectomy"),
                                choices = c("No" = 1,
                                            "Yes" = 2),
                                selected = 1)))),
  fluidRow(column(4),
           column(4,
                  actionButton(inputId = "action",
                               label = "Predict!",
                               icon("lightbulb"),
                               width = "100%")),
           column(4)),
  fluidRow(column(12,
                  br(),
                  hr(),
                  h1("Results"),
                  br(),
                  wellPanel(
                    h4("Case report"),
                    tableOutput("case_report")),
                  br(),
                  wellPanel(
                    h4("Total points"),
                    tableOutput(outputId = "points")),
                  br(),
                  wellPanel(
                    h4("Predicted OS"),
                    tableOutput(outputId = "predictions")))),

  p("Chen Xi Copyright 2023",
    style = "text-align: center")
)
