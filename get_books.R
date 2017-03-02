# Getcha lexica

# Use stringdist to find all words most similar to / distinct from a given word

library(dplyr); library(magrittr)

# Read in lexicon
words1 <- read.delim("../english-words/words.txt",  sep = "", col.names = "word")
words2 <- read.delim("../english-words/words2.txt", sep = "", col.names = "word")
words3 <- read.delim("../english-words/words3.txt", sep = "", col.names = "word")
words <- rbind(words1,words2,words3)
rm(words1);rm(words2);rm(words3)
words %<>% distinct()

# Get works from Project Gutenberg
library(gutenbergr); library(tidytext); library(stringr)

gutenberg_works() %>% 
  filter(str_detect(author, 'Wells')) %>%
  View()

##### Paradise Lost ######

paradiselost <-
gutenberg_download(20) %>%
  # Label books
  mutate(book = cumsum(str_detect(text,regex("^  BOOK",ignore_case = F)))) %>%
  # Remove filler text between books
  filter(text != "  PARADISE LOST") %>%
  filter(grepl("*THE END OF THE*",text) == F) %>%
  # Remove header and footer matter
  slice(26:10980) %>%
  # Number lines for reference
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  mutate(word = str_extract(word, "[a-z]+"))

##### Leaves of Grass ######

leaves <-
  gutenberg_download(1322) %>%
  # Label books
  mutate(book = cumsum(str_detect(text,regex("^BOOK ",ignore_case = F)))) %>%
  # Remove header and footer matter
  slice(23:17859) %>%
  # Number lines for reference
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  mutate(word = str_extract(word, "[a-z]+"))

##### Leaves of Grass ######

leaves <-
  gutenberg_download(1322) %>%
  # Label books
  mutate(book = cumsum(str_detect(text,regex("^BOOK ",ignore_case = F)))) %>%
  # Remove header and footer matter
  slice(23:17859) %>%
  # Number lines for reference
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  mutate(word = str_extract(word, "[a-z]+"))

##### Moby Dick ######

moby <-
  gutenberg_download(2489) %>%
  # Label chapters
  mutate(chapter = cumsum(str_detect(text,regex("^*CHAPTER [[:digit:]]",ignore_case = F)))) %>%
  # Number lines for reference
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  mutate(word = str_extract(word, "[a-z]+"))

##### Keats' Collected Works #####

keats <-
  gutenberg_download(c(8209,23684)) %>%
  # Remove header and footer matter
  slice(21:6253)

#### Frost Poems

frost <- gutenberg_download(c(3021, 3026, 29345))

##### Donne Poems

donne <- gutenberg_download(c(48688, 48772))

##### Pound

pound <- gutenberg_download(c(23538,40200,41162,51992))

##### Emily Dickinson

emily <- 
  gutenberg_download(12242) %>%
  # Remove header and footer matter
  slice(157:10304) %>%
  unnest_tokens(word, text) 


# Get a library...

# shakespeare: 100
# grimm: 2591
# metamorphosis: 5200
# jekyll: 43
# pope_iliad: 6130
# pound_personae: 41162
# emily: 12242
# ulysses: 4300

# Get some functions
source("found_sound.R")
