# clean_corpus.R
library(tidyverse); library(textclean); library(tidygraph)
library(quanteda);library(text2vec); library(tidytext)

corpus <- read_csv("data/corpus.csv")
reg_list <- read_csv("data/reg_list.csv")

# Define cleaning routine
clean_text <- function(x){
  
  x %>%
    str_to_lower() %>%
    str_replace_all("\\[|\\]"," ") %>% # remove square brackets
    str_replace_all( "[^\\s]*[0-9][^\\s]*"," ") %>% # remove mixed string & number
    str_replace_all("\\-"," ") %>% # replace dashes, shd be picked up in noun phrases
    str_replace_all("_"," ") %>%
    str_replace_all("§|§§","rule ") %>%
    str_squish() %>%
    replace_number(remove = T) %>% # remove number
    replace_html(replacement = "") 
  
}

corpus_sections <- 
  corpus %>% 
  ungroup() %>%
  mutate(
    text_clean = clean_text(text),
    id = str_pad(row_number(),width = 10,pad = "0")
  ) %>%
  filter(text_clean != "")

corpus_sentences <-
  corpus_sections %>%
  select(id,text) %>%
  unnest_tokens(sentence,text,"sentences") %>%
  group_by(id) %>%
  mutate(
    text_clean = clean_text(sentence),
    sid = paste0(id,"_",str_pad(row_number(),width = 5,pad = "0"))
  ) %>%
  ungroup()
  
iter_sections <- 
  corpus_sections$text_clean %>%
  word_tokenizer() %>%
  itoken(ids = corpus_sections$id)

iter_sentences <- 
  corpus_sentences$text_clean %>%
  word_tokenizer() %>%
  itoken(ids = corpus_sentences$sid)

vocab <- 
  iter_sections %>%
  create_vocabulary(
    stopwords = c(setdiff(stopwords::stopwords("en"),c("of"))) # keep 'of'
  ) %>%
  prune_vocabulary(
    # doc_proportion_min = 0.001,
    term_count_min = 2 
  )

get_colloc <- function(iter_obj,vocabulary,stopword_list=c(letters),n_iter=3,colloc_min=50,pmi_min=5,voc_min_n=10,voc_min_prop=0.01){
  
  colloc_model <- 
    Collocations$new(
      vocabulary = vocab, 
      collocation_count_min = colloc_min,
      pmi_min = pmi_min
    )
  
  colloc_model$fit(iter_obj, n_iter = n_iter)
  
  # Transform original iterator and vocab to insert collocations
  iter_phrases <- colloc_model$transform(iter_obj)
  
  vocab_phrases <- 
    iter_phrases %>%
    create_vocabulary(stopwords = stopword_list) %>%
    prune_vocabulary(
      term_count_min = voc_min_n, 
      doc_proportion_min = voc_min_prop
    )
  
  output <- list()
  output$model <- colloc_model
  output$iter  <- iter_phrases
  output$stat  <- colloc_model$collocation_stat
  output$vocab <- vocab_phrases
  
  return(output)
  
}

colloc_sections <- 
  iter_sections %>% 
  get_colloc(
    vocab,
    n_iter = 2,
    colloc_min = 5,
    pmi_min = 0,
    stopword_list = c(stopwords::stopwords("en")),
    voc_min_n = 3,
    voc_min_prop = 0.0001
  )

# Transform sentence iterator using collocations learned from sections
iter_sent_phrases <- colloc_sections$model$transform(iter_sentences)
# colloc_sections$vocab %>% View()

dtm_sections <-
  colloc_sections$iter %>%
  create_dtm(vocab_vectorizer(colloc_sections$vocab)) %>% 
  quanteda::as.dfm() %>% 
  quanteda::convert("tripletlist") %>% 
  as_tibble()

dtm_sentences <-
  iter_sent_phrases %>%
  create_dtm(vocab_vectorizer(colloc_sections$vocab)) %>% 
  quanteda::as.dfm() %>% 
  quanteda::convert("tripletlist") %>% 
  as_tibble()

vocab <- colloc_sections$vocab

rm(list = c("iter_sections","iter_sentences","iter_sent_phrases","colloc_sections","get_colloc","clean_text"))
