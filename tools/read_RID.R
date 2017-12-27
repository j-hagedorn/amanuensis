# read_RID.R
# Read in 'Regressive Imagery Dictionary' for use in text mining
# http://www.kovcomp.co.uk/wordstat/RID.html

library(tidyverse); library(stringr); library(magrittr)

rid <- readLines("text_files/RID.CAT") 
rid <- as.data.frame(rid)

rid %<>% 
  mutate(rid = as.character(rid)) %>%
  separate(
    rid, 
    into = c("v1","v2","v3","v4","v5"), 
    sep = '\\t| ', 
    extra = "merge", 
    fill = "right"
  ) 

rid[rid == ""] <- NA 

rid %<>% 
  fill(v1:v5) %>%
  filter(is.na(v5) == F) %>%
  mutate_all(funs(tolower)) %>%
  mutate_all(funs(as.factor)) %>%
  select(-v5)
  