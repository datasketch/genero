## code to prepare `DATASET` dataset goes here

usethis::use_data("DATASET")

names_pt <- read.csv(system.file("names-gender-freq-pt.csv", package = "genero"))

library(dplyr)

nms_pt <- names_pt %>%
  select(name = group_name, gender = classification) %>%
  mutate(name = tolower(name),
         gender = ifelse(gender == "M", "male", "female")) %>%
  distinct(name, gender)
readr::write_csv(nms_pt, "inst/names-gender-pt.csv")
