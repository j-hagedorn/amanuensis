# get_words.R

library(tidyverse);library(stringr);library(tidytext); library(magrittr)
library(qdapDictionaries)

# Read in lexicon
words1 <- read.delim("../english-words/words.txt",  sep = "", col.names = "word")
words2 <- read.delim("../english-words/words2.txt", sep = "", col.names = "word")
words3 <- read.delim("../english-words/words3.txt", sep = "", col.names = "word")
word_corpus <- corpus %>% unnest_tokens(word,text,"words") %>% select(word)
words4 <- tbl_df(DICTIONARY) %>% select(word)

# Find all prepositional phrases (join to wordlist)
prepositions <- 
  read_csv(
    "http://scrapmaker.com/data/wordlists/language/prepositions.txt", 
    col_names = F
  ) %>%
  rename(word = X1) %>%
  mutate(word = str_trim(word))

words <- rbind(words1,words2,words3,words4,word_corpus,prepositions)
rm(words1);rm(words2);rm(words3);rm(words4);rm(word_corpus)

words %<>% distinct()

# Find all words with e.g. only 1 vowel