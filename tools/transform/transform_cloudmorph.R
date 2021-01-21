# clouds / morphose
# Find words which are the closest

library(stringdist); library(tidyverse); library(fuzzyjoin)
lexicon <- feather::read_feather("texts/output/lexicon.feather")

seed_word = "erode"

morph <- function(seed_word, n_changes = 5, dist_method = "osa", max_dist = 1){
  
  df <-
    as_tibble(seed_word) %>%
    rename(word = value) %>%
    stringdist_left_join(
      lexicon %>% mutate(word = as.character(word)) %>% select(word), 
      by = "word", 
      method = "osa",
      max_dist = 1
    ) %>%
    filter(word.x != word.y) %>%
    rename(word_0 = word.x, word = word.y)
  
  for (i in 1:(n_changes - 2)) {
    
    x <-
      df %>%
      stringdist_left_join(
        lexicon %>% mutate(word = as.character(word)) %>% select(word), 
        by = "word", 
        method = "osa",
        max_dist = 1
      ) %>%
      filter(word.x != word.y) %>%
      filter(word.y != seed_word)
    
    # Rename cols to allow next join
    names(x) <- c("word_0",glue::glue("word_{n1}", n1 = rep(1:i)),"word")
    
    df <- x
    
  }
  
  return(df)
  
}





