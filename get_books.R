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
library(gutenbergr)

gutenberg_works() %>% filter(str_detect(author, 'Dante'))

tst <-
gutenberg_download(1004) %>%
  # Remove header and footer matter
  slice(269:19842) %>%
  # Number lines for reference
  mutate(line = row_number()) %>%
  unnest_tokens(word, text) %>%
  mutate(word = str_extract(word, "[a-z]+"))

# Get a library...

# shakespeare: 100
# paradiselost: 20
# leavesofgrass: 1322
# mobydick: 2701
# grimm: 2591
# metamorphosis: 5200
# jekyll: 43
# pope_iliad: 6130
# pound_personae: 41162
# frost_boyswill: 3021
# frost_mtintrvl: 29345
# frost_noboston: 3026
# keats: 23684
# emily: 12242
# ulysses: 4300

# Get some functions
source("found_sound.R")
