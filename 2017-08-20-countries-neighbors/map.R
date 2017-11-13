

library(dmaps)
library(mop)
countries <- read_csv("countries_color.csv")
colors <- c("#F456B0", "#5030A7","#33A84F","#9B2CAA")
countries$group <- match_replace(countries$color, data_frame(1:4,colors))

dmaps(countries,"world_countries", codeCol = "id", groupCol = "color")


library(geomagic)
library(datafringe)
geomagic::gg_choropleth_map_GcdCat.(countries[c("id","group")], "world_countries")

geomagic::gg_choropleth_map_GcdCat.(countries[c("id","group")], "world_countries")
