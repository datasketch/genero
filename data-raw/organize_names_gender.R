## code to prepare `DATASET` dataset goes here

usethis::use_data("DATASET")

# https://brasil.io/dataset/genero-nomes/nomes
# https://brasil.io/dataset/genero-nomes/nomes?format=csv
# names_pt <- read.csv(system.file("names-gender-freq-pt.csv", package = "genero"))
names_pt <- read.csv("https://brasil.io/dataset/genero-nomes/nomes?format=csv")

library(dplyr)

names_gender_pt <- names_pt %>%
  select(name = group_name, gender = classification) %>%
  mutate(name = tolower(name),
         gender = ifelse(gender == "M", "male", "female")) %>%
  distinct(name, gender)
readr::write_csv(names_gender_pt, "inst/names_gender_pt.csv")

usethis::use_data(names_gender_pt, overwrite = TRUE)

##
url <- "http://raw.githubusercontent.com/jpmarindiaz/some-data/master/names_gender_es/names-gender-es.csv"
names_gender_es <- read.csv(url, stringsAsFactors = FALSE)
names(names_gender_es)
names_gender_es <- names_gender_es %>%
  mutate(name = stringi::stri_escape_unicode(name))
#stringi::stri_escape_unicode(c("hola é", "ñ as"))

usethis::use_data(names_gender_es, overwrite = TRUE)

usethis::use_data(names_gender_es, names_gender_pt, internal = TRUE, overwrite = TRUE)

