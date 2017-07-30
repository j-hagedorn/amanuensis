# clouds / morphose

# Find words which are the closest

library(stringdist); library(tidyverse); library(tidytext)

str1 <- words %>% anti_join(stop_words) %>% sample_n(5000)
str2 <- words %>% anti_join(stop_words) %>% sample_n(5000)

morphose <- 
  # Create distance matrix computing string diff
  stringdistmatrix(str1$word, str2$word, method='hamming', useNames = T)  %>%
  as.data.frame() %>%
  mutate(rawtext = row.names(.)) %>%
  select(rawtext, everything()) %>%
  group_by(rawtext) %>%
  gather(coded,score,-rawtext) %>%
  mutate(rank = row_number(score)) %>%
  filter(score == 1)


tst <- morphose %>% kmeans(50) 

tst <- tst %>% augment(morphose) %>% select(.cluster, everything())

# Start with word (either passed as arg or randomly selected)
# Find all words that can be created by replacing one letter in word
# Find all words that can be created by switching two letters in word

# Calculated 'hamming' stringdist
stringdistmatrix("leviathan",words, method='hamming')
