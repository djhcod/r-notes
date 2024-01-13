# build model --------------------------------------
dd <- datadist(data_no_rad)
options(datadist = "dd")
model_no_rad <- cph(Surv(time, dead == 1) ~ age1 + grade2 + tumor_size1 + his + figo + lnd,
                    x = T, y = T,
                    data = data_no_rad,
                    surv = T)
nom_no_rad <- nomogram(model_no_rad, maxscale = 100)



dd <- datadist(data_rad)
options(datadist = "dd")
model_rad <- cph(Surv(time, dead == 1) ~ age2 + grade2 + tumor_size2 + his + figo + lnd,
                 x = T, y = T,
                 data = data_rad,
                 surv = T)
nom_rad <- nomogram(model_rad, maxscale = 100)





nompoints <- function(data_input) {
  points_no_rad <- points_cal(formula_rd(nom_no_rad)[["formula"]], rd = data_input)
  points_rad <- points_cal(formula_rd(nom_rad)[["formula"]], rd = data_input)
  points <- cbind(points_no_rad, points_rad, points_no_rad - points_rad) |> as.data.frame()
  colnames(points) <- c("Points without radiotherapy",
                        "Points with radiotherapy",
                        "Total points difference")
  print(points)
}


osbenefits <- function(data_input) {
  survprob_no_rad <- predictSurvProb(model_no_rad,
                                     newd = data_input,
                                     times = c(1 * 12, 3 * 12, 5 * 12))
  survprob_rad <- predictSurvProb(model_rad,
                                  newd = data_input,
                                  times = c(1 * 12, 3 * 12, 5 * 12))

  os_predict <- cbind(t(survprob_no_rad) * 100,
                      t(survprob_rad) * 100,
                      t(survprob_rad) * 100 - t(survprob_no_rad) * 100) |>
    as.data.frame()

  colnames(os_predict) <- c("Without radiotherapy",
                            "With radiotherapy",
                            "OS benefit from adjuvant radiotherapy")
  row.names(os_predict) <- c("Predicted 1-year overall survival (%)",
                             "Predicted 3-year overall survival (%)",
                             "Predicted 5-year overall survival (%)")


  print(os_predict)
}
