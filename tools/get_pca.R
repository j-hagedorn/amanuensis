lexicon <- feather::read_feather("lexicon.feather")

library(tidyverse); library(tidytext);library(fuzzyjoin)

tst <-
  lexicon %>%
  filter(plosives > 0.2) %>%
  select(word,starts_with("phon_"))

# PCA
prcomps <-
  tibble(pc = 1:15) %>%
  mutate(
    pca = map(pc, ~prcomp(lexicon %>% select(len:frictionless) %>% scale(), .x)),
    tidied = map(pca, tidy),
    augmented = map(pca, augment, lexicon)
  )

# review_pca <- prcomps %>% unnest(tidied, .drop = TRUE)

best_players <- 
  prcomps %>% 
  unnest(augmented) %>%
  filter(pc == 6) %>%
  filter(.fittedPC1 >= 2) %>%
  select(idPlayer:.fittedPC6)

