
library(stringdist); library(tidyr)

tot_words <- nrow(commedia)

str1 <- 
  commedia %>% 
  filter(is.na(word) == F) %>%
  count(word, sort = T) %>%  
  mutate(total = tot_words,
         rank = row_number(),
         freq = n/total) %>%
  slice(1:500)
  
str2 <- 
  leaves %>% 
  filter(is.na(word) == F) %>%
  count(word, sort = T) %>%  
  mutate(total = tot_words,
         rank = row_number(),
         freq = n/total) %>%
  slice(1:500)


dist <- stringdist(str1$word, str2$word, method = "soundex")

rearrange <- 
  # Create distance matrix computing string diff
  stringdistmatrix(str1$word, str2$word, method='jw', useNames = T)  %>%
  as.data.frame() %>%
  mutate(rawtext = row.names(.)) %>%
  group_by(rawtext) %>%
  gather(coded,score,-rawtext) %>%
  mutate(rank = row_number(score)) %>%
  # keep only the most accurate
  filter(score >= 0.01, score < 0.30)
  
rhyme <- 
  # Create distance matrix computing string diff
  stringdistmatrix(str1$word, str2$word, method='soundex', useNames = T)  %>%
  as.data.frame() %>%
  mutate(rawtext = row.names(.)) %>%
  group_by(rawtext) %>%
  gather(coded,score,-rawtext) %>%
  mutate(rank = row_number(score)) %>%
  # keep only rhymes
  filter(score == 0) %>%
  # remove exact rhymes
  filter(rawtext != coded)

  tst2 <-
  tst %>%
  # select match with lowest (best) score
  # filter(rank == min(rank)) %>%
  # keep only the most accurate
  filter(score >= 0.01, score < 0.30) %>%
  select(rawtext,coded)