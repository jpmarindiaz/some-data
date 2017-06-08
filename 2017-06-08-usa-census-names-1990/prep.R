
library(tidyverse)

file <- "data/original/last-names-usa-census-1990.txt"
last_names <- read_fwf(file,
                       fwf_empty(file, 
                                 col_names = c("last_name","freq","cum.freq","rank")))
write_csv(last_names,"data/last-names-usa-census-1990.csv")

file <- "data/original/first-names-usa-census-1990-female.txt"
female_names <- read_fwf(file,fwf_empty(file, 
                                        col_names = c("name","freq","cum.freq","rank")))
write_csv(female_names,"data/first-names-usa-census-1990-female.csv")

file <- "data/original/first-names-usa-census-1990-male.txt"
male_names <- read_fwf(file,fwf_empty(file, 
                                      col_names = c("name","freq","cum.freq","rank")))
write_csv(male_names,"data/first-names-usa-census-1990-male.csv")

# prepare female/male names

l <- list(male = male_names, female = female_names)
gender_names <- l %>% 
  bind_rows(.id = "gender") %>% 
  select(gender,name) %>% 
  mutate(name = tolower(name))
write_csv(gender_names,"data/names-gender-en.csv")




