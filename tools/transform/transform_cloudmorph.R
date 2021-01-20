# clouds / morphose
# Find words which are the closest

library(stringdist); library(tidyverse); library(fuzzyjoin)
lexicon <- feather::read_feather("texts/output/lexicon.feather")

seed_word = "erode"


df <-
  as_tibble(seed_word) %>%
  rename(word = value) %>%
  stringdist_left_join(
    lexicon %>% mutate(word = as.character(word)) %>% select(word), 
    by = "word", 
    method = "osa",
    max_dist = 1
  ) %>%
  rename(word_0 = word.x, word = word.y)

# i = 1

for (i in 1:2) {
  
  x <-
    df %>%
    stringdist_left_join(
      lexicon %>% mutate(word = as.character(word)) %>% select(word), 
      by = "word", 
      method = "osa",
      max_dist = 1
    ) 
  
  # Rename cols to allow next join
  names(x) <- c("word_0",glue::glue("word_{n1}", n1 = rep(1:i)),"word")
  
  df <- x
  
}


