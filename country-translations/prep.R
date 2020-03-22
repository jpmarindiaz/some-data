library(tidyverse)

langs <- list.dirs("world_countries-master/data",recursive = FALSE)

countries <- map(langs, function(x){
  d <- read_csv(paste0(x,"/countries.csv"))
  d$lang <- basename(x)
  d
}) %>% bind_rows()

cs <- countries %>% 
  pivot_wider(names_from = "lang",
              values_from = "name"
              ) %>% 
  mutate(alpha3 = toupper(alpha3), alpha2 = toupper(alpha2)) %>% 
  select(-id, ISOalpha3 = alpha3, ISOalpha2 = alpha2) 
write_csv(cs, "country-names-translations.csv")

