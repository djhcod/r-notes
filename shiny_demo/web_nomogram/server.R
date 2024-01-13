# Server logic ----
server <- function(input, output, session) {
  observeEvent(
    input$action, {

      age1 <- ifelse(input$age < 65, 1, ifelse(input$age <= 79, 2, 3))
      age2 <- ifelse(input$age < 65, 1, ifelse(input$age <= 75, 2, 3))
      tumor_size1 <- ifelse(input$tumor_size < 34, 1,
                            ifelse(input$tumor_size <= 62, 2, 3))
      tumor_size2 <- ifelse(input$tumor_size < 40, 1,
                            ifelse(input$tumor_size <= 62, 2, 3))
      data_input <- data.frame("age1" = age1,
                               "age2" = age2,
                               "grade2" = input$grade,
                               "tumor_size1" = tumor_size1,
                               "tumor_size2" = tumor_size2,
                               "his" = input$his,
                               "figo" = input$figo,
                               "lnd" = input$lnd)

      # 总结个案
      output$case_report <- renderTable({

        case <- data.frame(input$age,
                           ifelse(input$grade == 1, "Low-grade", ifelse(input$grade == 2, "High-grade", "Gx")),
                           input$tumor_size,
                           ifelse(input$his == 1, "Serous",
                                  ifelse(input$his == 2, "Carcinosarcoma",
                                         ifelse(input$his == 3, "Clear Cell" , "Mixed epithelial"))),
                           ifelse(input$figo == 1, "Stage I", "Stage II"),
                           ifelse(input$lnd == 1, "No", "Yes"))
        colnames(case) <- c("Age (years)", "Grade", "Tumor size", "Histology",
                            "FIGO stage", "Lymphadenectomy")
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
        data_input[,1:8] <- lapply(data_input[,1:8], as.numeric)
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
