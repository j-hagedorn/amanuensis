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
  select(-v5) %>%
  mutate_all(funs(tolower)) %>%
  mutate(
    # Secondary and Emotions items have one less level.  Move v3 to v4
    v4 = case_when(
      as.character(v1) == "primary" ~ as.character(v4),
      as.character(v1) %in% c("secondary","emotions") ~ as.character(v3)
    ),
    # Copy second level groups to third level
    v3 = case_when(
      as.character(v1) == "primary" ~ as.character(v3),
      as.character(v1) %in% c("secondary","emotions") ~ as.character(v2)
    )
  ) %>%
  mutate_all(funs(as.factor)) %>%
  rename(
    level_1 = v1,
    level_2 = v2,
    level_3 = v3,
    word = v4
  )
  