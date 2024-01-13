# Load packages ------------------------------------
library(shiny)
library(bslib)
library(rms)
library(pec)
library(nomogramFormula)

# load dataset -------------------------------------
data_no_rad <- readRDS("data/data_no_rad.RDS")
data_rad <- readRDS("data/data_yes_rad.RDS")
data_no_rad[,c(1:5, 8:9)] <- lapply(data_no_rad[,c(1:5, 8:9)], as.numeric)
data_no_rad[,c(1:5, 8:9)] <- lapply(data_no_rad[,c(1:5, 8:9)], as.factor)
data_rad[,c(1:5, 8:9)] <- lapply(data_rad[,c(1:5, 8:9)], as.numeric)
data_rad[,c(1:5, 8:9)] <- lapply(data_rad[,c(1:5, 8:9)], as.factor)


# load function--------------------------------------
source("function.R")
