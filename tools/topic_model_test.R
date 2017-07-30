library(dplyr); library(tidytext); library(tm); library(topicmodels)

# For Converting to and from Document-Term Matrix and Corpus objects
# Needed for topic modelling
# https://cran.r-project.org/web/packages/tidytext/vignettes/tidying_casting.html

tst <- 
  grimm_words %>%
  anti_join(stop_words) %>%
  select(document = gutenberg_id, term = word) %>%
  group_by(document, term) %>%
  summarize(count = n()) %>%
  cast_dtm(document, term, count) %>%
  LDA(., k = 5) %>%
  tidy() %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)



topics(tst[["VEM"]], 1)
terms(tst[["VEM"]], 5)

