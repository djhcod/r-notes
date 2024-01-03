data_no_rad <- readRDS("nomogram/data/data_no_rad.rds")
data_rad <- readRDS("nomogram/data/data_rad.rds")

data_input <- data.frame("age" = 3,
                         "grade" = 1,
                         "tumor_size" = 1,
                         "his" = 1,
                         "T_stage" = 2,
                         "N_stage" = 0,
                         "chemotherapy" = 0)


dd <- datadist(data_no_rad)
options(datadist = "dd")
model_no_rad <- cph(Surv(time, dead == 1) ~ age + grade + tumor_size + his +
                      T_stage + N_stage + chemotherapy,
                    x = T, y = T,
                    data = data_no_rad,
                    surv = T)
dd <- datadist(data_rad)
options(datadist = "dd")
model_rad <- cph(Surv(time, dead == 1) ~ age + grade + tumor_size + his + N_stage,
                 x = T, y = T,
                 data = data_rad,
                 surv = T)


osbenefits(data_input, model_no_rad, model_rad)
