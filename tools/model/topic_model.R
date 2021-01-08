library(tidytext); library(tidyverse); library(topicmodels)
library(magrittr)

df <- grimm %>% bind_rows(goose)

extra_stop_words <-
  c(
    "elsie","chanticleer","tom","cinderella","hans",
    "gretel","hansel","riquet","rapunzel","frederick",
    "falada","dummling","jorinda","jorindel","heinel"
  ) 

extra_stop_words <-
  as.data.frame(extra_stop_words) %>%
  rename(word = extra_stop_words)

lda_model <- 
  df %>%
  ungroup() %>%
  group_by(title) %>%
  unite(title_section, title, section) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  anti_join(extra_stop_words) %>%
  count(title_section, word, sort = TRUE) %>%
  ungroup() %>%
  cast_dtm(title_section, word, n) %>%
  LDA(k = 20, control = list(seed = 123)) %>% 
  tidy()

top_terms <- 
  lda_model %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)
