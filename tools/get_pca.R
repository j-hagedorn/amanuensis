lexicon <- feather::read_feather("lexicon.feather")

library(tidyverse); library(tidytext);library(tidymodels)

tst <-
  lexicon %>%
  filter(plosives > 0.2) %>%
  select(word,starts_with("phon_"))

# PCA
df <- 
  lexicon %>%
  filter(len >= 4) %>%
  filter(len <= 10) %>%
  filter(vowel > 0) %>%
  select(word,len:vowel)

rec_pca <- 
  recipe(vowel ~ ., data = df) %>%
  update_role(word, new_role = "id") %>%
  step_normalize(all_predictors()) %>%
  step_pca(all_predictors())

prep_pca <- prep(rec_pca)

tidied_pca <- tidy(prep_pca, 2)

tidied_pca %>%
  filter(component %in% c("PC1","PC2","PC3","PC4","PC5","PC6","PC7")) %>%
  mutate(component = fct_inorder(component)) %>%
  ggplot(aes(value, terms, fill = terms)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~component) +
  labs(y = NULL)

tidied_pca %>%
  filter(component %in% c("PC1","PC2","PC3","PC4","PC5","PC6","PC7")) %>%
  group_by(component) %>%
  top_n(6, abs(value)) %>%
  ungroup() %>%
  mutate(terms = reorder_within(terms, abs(value), component)) %>%
  ggplot(aes(abs(value), terms, fill = value > 0)) +
  geom_col() +
  facet_wrap(~component, scales = "free_y") +
  scale_y_reordered() +
  labs(
    x = "Absolute value of contribution",
    y = NULL, fill = "Positive?"
  )

lex_pca <- juice(prep_pca) 


lex_pca %>%
  ggplot(aes(PC1, PC2, label = word)) +
  geom_point(alpha = 0.2) +
  geom_text(check_overlap = TRUE, family = "IBMPlexSans")

# review_pca <- prcomps %>% unnest(tidied, .drop = TRUE)

sdev <- prep_pca$steps[[2]]$res$sdev
percent_variation <- sdev^2 / sum(sdev^2)

  tibble(
    component = unique(tidied_pca$component),
    percent_var = percent_variation 
  ) %>%
  mutate(component = fct_inorder(component)) %>%
  ggplot(aes(component, percent_var)) +
  geom_col() +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(x = NULL, y = "Percent variance explained by each PCA component")

principe <- 
  prcomps %>% 
  unnest(augmented) %>%
  filter(pc == 5) %>%
  # filter(.fittedPC1 >= 2) %>%
  select(idPlayer:.fittedPC6)

