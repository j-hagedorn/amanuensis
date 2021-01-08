# clouds / morphose

# Find words which are the closest

library(stringdist); library(tidyverse); library(tidytext)

str1 <- words %>% anti_join(stop_words) %>% sample_n(5000)
str2 <- words %>% anti_join(stop_words) %>% sample_n(5000)

str1[[1]]


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

x <- data.frame()

for(i in words$word[111:250]) {
  dist <- stringdist(i,words$word)
  df <- words
  df$dist <- dist
  
  df %<>% 
    mutate(
      word1 = i,
      word2 = word
    ) %>%
    filter(dist == 1) %>%
    select(word1,word2)
  
  x %<>% bind_rows(df)
}

# Find all words that can be created by replacing one letter in word

# Calculated 'hamming' stringdist
stringdistmatrix("leviathan",words, method='hamming')
