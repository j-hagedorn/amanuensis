# Getcha lexica

# Use stringdist to find all words most similar to / distinct from a given word

library(tidyverse); library(magrittr)

# Get works from Project Gutenberg
library(gutenbergr); library(tidytext); library(stringr)

gutenberg_works() %>% 
  #left_join(gutenberg_subjects) %>%
  #filter(str_detect(author, 'Wells')) %>%
  #filter(str_detect(title, 'physics')) %>%
  #filter(str_detect(subject, 'science')) %>%
  View()

gutenberg_subjects %>% View()

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
  slice(21:6253) %>%
  # Remove commentary
  slice(c(1:2104,2715:6233)) %>%
  unnest_tokens(word, text) %>%
  mutate(word = str_extract(word, "[a-z]+")) %>% 
  filter(is.na(word) == F)

#### Frost Poems

frost <- gutenberg_download(c(3021, 3026, 29345))

frost_trigrams <-
  frost %>%
  slice(c(84:1046,1061:1070,1095:3258,3341:5228)) %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3)

##### Donne Poems

donne <- gutenberg_download(c(48688, 48772))

tst <-
  donne %>%
  filter(grepl("_",text) == F) %>% 
  slice(c(1046:1068))

##### Pound

pound <- gutenberg_download(c(23538,40200,41162,51992))

pound_trigrams <- 
  pound %>% 
  slice(c(76:683,734:1783,1946:3566,3861:6274)) %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) 

##### Emily Dickinson

emily <- 
  gutenberg_download(12242) %>%
  # Remove header and footer matter
  slice(157:10304) %>%
  unnest_tokens(word, text) 

##### Common Minerals and Rocks

rocks <- gutenberg_download(49271)

##### Wild Flowers East of the Rockies

wildflowers <- gutenberg_download(45676)

# Read in lexicon
words1 <- read.delim("../english-words/words.txt",  sep = "", col.names = "word")
words2 <- read.delim("../english-words/words2.txt", sep = "", col.names = "word")
words3 <- read.delim("../english-words/words3.txt", sep = "", col.names = "word")
words <- rbind(words1,words2,words3)
rm(words1);rm(words2);rm(words3)
words %<>% distinct()

tst <- unique(
  c(
  words$word,
  emily$word,
  keats$word
  )
)

# Making A Rock Garden 24496
# Wild Flowers Worth Knowing 8866
# Principles of Geology, by Charles Lyell 33224
# Theory of the Earth, Volume 1 (of 4), by James Hutton 12861
# The Student's Elements of Geology by Lyell 3772
# Five of Maxwell's Papers 4908
# MONISM AS CONNECTING RELIGION AND SCIENCE Haeckel 9199
# The Temple of Nature; or, the Origin of Society Darwin, Erasmus 26861

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
