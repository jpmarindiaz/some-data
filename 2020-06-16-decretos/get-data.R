
library(glue)
library(rvest)
library(tidyverse)


urls <- "https://dapre.presidencia.gov.co/normativa/decretos-2020/decretos-{month}-2020"

months <- c("enero","febrero", "marzo", "abril", "mayo")

decretos_scrape <- lapply(months, function(month){
  # month <- months[4]
  message(month)
  url <- glue(urls)
  h <- read_html(url)
  decs <- h %>% html_nodes("#WebPartWPQ2 a")
  if(length(decs) == 0){
    decs <- h %>% html_nodes("#WebPartWPQ3 a")
  }
  decs_title <- decs %>%  html_text()
  decs_link <- decs %>% html_attr("href")
  decs_text <- h %>% html_nodes(".description") %>% html_text()
  list(
    title = decs_title,
    description = decs_text,
    link = decs_link
  )
}) 

decretos <- map_df(decretos_scrape, ~ .) %>% bind_rows


l <- strsplit(decretos$title, " ")

decretos$numero <- unlist(map(l, ~ as.numeric(.[2])))
decretos$fecha <- unlist(map(l, ~paste0(.[4:8], collapse = " ")))
decretos$file <- basename(decretos$link)

decretos <- decretos %>% select(numero, everything())

write_csv(decretos, "data/decretos-urls.csv")


# Download decretos

rate <- rate_backoff(pause_base = 0.1, pause_min = 0.005, max_times = 4)

library(httr)
library(downloader)

downloads <- lapply(decretos$link, safely(function(url){
  # url <- decretos$link[55]
  filepath <- file.path("decretos", basename(url))
  if(!file.exists(filepath))
    download.file(URLencode(url), filepath)
}))

errors <- keep(downloads, ~ !is.null(.$error))

files <- list.files("decretos")
all(files %in% decretos$file)

library(pdftools)

txts <- map(decretos$file, function(f){
  #f <- decretos$file[1]
  f <- file.path("decretos", f)
  txt <- pdf_text(f)
  txt
})

decretos$text <- map_chr(txts, paste, collapse = "\n\n\n")

decretos <- decretos %>% 
  select(numero, titulo = title, descripcion = description, fecha,
         vinculo = link, archivo = file, texto = text)

write_csv(decretos, "data/decretos.csv")

decretos_no_txt <- decretos %>% select(-texto)
write_csv(decretos_no_txt, "data/decretos sin texto.csv")

