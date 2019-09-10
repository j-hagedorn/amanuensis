# get_words.R

library(tidyverse);library(stringr);library(tidytext); library(magrittr)
library(qdapDictionaries)

wordlists <- list()
wordlists$a <- "https://raw.githubusercontent.com/paritytech/wordlist/master/res/wordlist.txt"
wordlists$b <- "https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt"
wordlists$c <- "http://scrapmaker.com/data/wordlists/language/prepositions.txt"

words <- tbl_df(DICTIONARY) %>% select(word)

for (i in wordlists){
  x <- read.delim(i,  sep = "", col.names = "word")
  words <- bind_rows(words,x)
  words <- words %>% 
    mutate(
      word = str_trim(word),
      word = str_to_lower(word),
      word = str_remove_all(word,"[^[:alpha:] ]")
    ) %>% distinct()
  rm(x);rm(i)
}

# Read in lexicon
word_corpus <- corpus %>% 
  unnest_tokens(word,text,"words") %>% 
  mutate(word = str_remove_all(word,"[^[:alpha:] ]")) %>%
  select(word) %>% distinct()

words <- bind_rows(words,word_corpus) %>% distinct() %>% arrange(word)

# Find all prepositional phrases (join to wordlist)
prepositions <- 
  read_csv(
    "http://scrapmaker.com/data/wordlists/language/prepositions.txt", 
    col_names = F
  ) %>%
  rename(word = X1) %>%
  mutate(word = str_trim(word))



