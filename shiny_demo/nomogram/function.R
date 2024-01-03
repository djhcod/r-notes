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
