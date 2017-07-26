
library(tidyverse)
library(readxl)

x <- read_excel("DIVIPOLA_20170630.xlsx",skip = 4)
names(x)
divi <- x %>% 
  mutate(name = paste(`Nombre Municipio`, `Nombre Departamento`, sep = " - ")) %>% 
  select(code = `Código Municipio`, name, 
         lat = Latitud, lon = Longitud, department = `Nombre Departamento`,
         municipality = `Nombre Municipio`, dept_code = `Código Departamento`) %>% 
  mutate(lat = as.numeric(gsub(",",".",lat)),lon = as.numeric(gsub(",",".",lon))) 
names(muni)
muni <- divi %>% 
  group_by(code, name, department, municipality, dept_code) %>% 
  summarise(lat = mean(lat), lon = mean(lon)) %>% 
  select(code, name, lat, lon, department, municipality, dept_code)

muniAlt <- read_csv("muni-alternativeNames.csv", col_types = cols(.default = 'c'))

muni <- left_join(muni,muniAlt) %>% 
select(code, name, alternativeNames, lat, lon, department, municipality, dept_code)

write_csv(muni, "col-divipola-municipios-dane-2017-06-30.csv")


names(divi)
depto <- divi %>% 
  mutate(code = dept_code) %>% 
  select(code, name = department, lat, lon) %>% 
  group_by(code, name) %>% 
  summarise(lat = mean(lat), lon = mean(lon))

deptoAlt <- read_csv("depto-alternativeNames.csv", col_types = cols(.default = 'c'))
depto <- left_join(depto,deptoAlt) %>% 
  select(code, name, alternativeNames, lat, lon)
  
write_csv(depto,"col-divipola-deptos-dane-2017-06-30.csv")


