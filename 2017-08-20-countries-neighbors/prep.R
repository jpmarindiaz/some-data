
library(tidyverse)
library(jsonlite)
library(mop)

neighbors <- read_json("countries-neighbors.json")
neighbors <- map(neighbors, "neighbours") 
#neighbors <- neighbors %>% keep(~!is.null(.)) 
#map(neighbors,class) %>% reduce(intersect)

neighbors <- stack(neighbors) %>% select(country = values, neighbor = ind)
n0 <- neighbors
world <- read_csv("world-isocodes.csv", col_types = cols(.default = 'c'), na = "") 
problems(world)

dic <- world %>% select(iso_a2, iso_a3)

neighbors$country <- mop::match_replace(neighbors$country, dic)
neighbors$neighbor <- mop::match_replace(neighbors$neighbor, dic)

nodes <- length(unique(c(neighbors$country,neighbors$neighbor)))


neighbors %>% keep_any_na_rows()

write_csv(neighbors,"countries-neighbors.csv")


# TODO
## Add border length
# https://en.wikipedia.org/wiki/List_of_countries_and_territories_by_land_borders


