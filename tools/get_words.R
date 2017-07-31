# get_words.R

library(tidytext); library(magrittr)

# Read in lexicon
words1 <- read.delim("../english-words/words.txt",  sep = "", col.names = "word")
words2 <- read.delim("../english-words/words2.txt", sep = "", col.names = "word")
words3 <- read.delim("../english-words/words3.txt", sep = "", col.names = "word")
word_corpus <- corpus %>% unnest_tokens(word,text,"words") %>% select(word)
words <- rbind(words1,words2,words3,word_corpus)
rm(words1);rm(words2);rm(words3);rm(word_corpus)

words %<>% distinct()
