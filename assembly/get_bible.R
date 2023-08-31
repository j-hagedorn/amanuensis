
# from 
# url: https://unbound.biola.edu/index.cfm?method=downloads.showDownloadMain

library(tidyverse); library(magrittr)

kjv <- read_tsv("texts/input/bible/kjv/kjv_apocrypha_utf8.txt", skip = 7) 

bk_nm <- read_tsv("texts/input/bible/kjv/book_names.txt",col_names = c("orig_book_index","book_name"))

names(kjv) <- c("orig_book_index","orig_chapter","orig_verse","empty","orig_subverse","text","empty2")

kjv %<>% 
  select(-empty,-empty2) %>%
  left_join(bk_nm, by = "orig_book_index") %>%
  mutate(
    trans = "kjv",
    id = paste0(orig_book_index,"_",orig_chapter,"_",orig_verse,"_",trans)
  ) %>%
  select(id,trans,orig_book_index,book_name,everything()) 

dr <- read_tsv("texts/input/bible/dr/douay_rheims_utf8.txt", skip = 7) 

names(dr) <- c("orig_book_index","orig_chapter","orig_verse","empty","orig_subverse","text","empty2")

dr %<>% 
  select(-empty,-empty2) %>%
  left_join(bk_nm, by = "orig_book_index") %>%
  mutate(
    trans = "dr",
    id = paste0(orig_book_index,"_",orig_chapter,"_",orig_verse,"_",trans)
  ) %>%
  select(id,trans,orig_book_index,book_name,everything()) 

asv <- read_tsv("texts/input/bible/asv/asv_utf8.txt", skip = 7) 

names(asv) <- c("orig_book_index","orig_chapter","orig_verse","empty","orig_subverse","text","empty2")

asv %<>% 
  select(-empty,-empty2) %>%
  left_join(bk_nm, by = "orig_book_index") %>%
  mutate(
    trans = "asv",
    id = paste0(orig_book_index,"_",orig_chapter,"_",orig_verse,"_",trans)
  ) %>%
  select(id,trans,orig_book_index,book_name,everything()) 

biblos <- kjv %>% bind_rows(asv,dr)

write_rds(biblos,"data/biblos.rds")
write_rds(kjv,"data/kjv.rds")
