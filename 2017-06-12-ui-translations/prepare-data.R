
library(rvest)
library(pystr)
library(tidyverse)
library(mop)

url <- "http://pootle.locamotion.org/export/terminology/"
avLangs <- read_html(url) %>% html_nodes("td a") %>% html_text()
avLangs <- gsub("/$","",avLangs[-1])

selectedLangs <- c("Spanish" = "es",
                   "Portuguese" = "pt_BR",
                   "French" = "fr",
                   "Italian" = "it",
                   "German" = "de",
                   "Chinese" = "zh_CN",
                   "Arabic" = "ar",
                   "Hindi" = "hi",
                   "Dutch" = "nl",
                   "Danish" = "da",
                   "Georgian" = "ka",
                   "Japanese" = "ja",
                   "Urdu" = "ur",
                   "Vietnamese" = "vi")

langs <- map(selectedLangs,function(lang){
  tpl <- "http://pootle.locamotion.org/export/terminology/{lang}/essential.po"
  langUrl <- pystr_format(tpl,lang = lang)
  message(lang)
  x <- readLines(langUrl)
  xx <- x %>% keep(~grepl("^msg",.)) %>% mop::extract_inside_quotes()
  en_ln <- spread_every(xx,2,c("en",lang))
  en_ln
})
names(langs) <- selectedLangs
d <- bind_rows(langs)

dlong <- d %>% gather(lang,translation,-en) %>% discard_any_na_rows()
translations <- dlong %>% spread(lang,translation)

translations <- translations %>% discard_all_empty_rows()
translations$pt <- translations$pt_BR
translations$id <- translations$en
translations$id <- gsub("[^[:alnum:]]","",translations$id)
translations <- translations %>% select(id,en,es,pt,de,fr,it,everything())

write_csv(translations,"data/ui-translations.csv")




