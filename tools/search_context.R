search_context <- function(df, return_nchar) {
  init <-
    df %>%
    unnest_tokens(word, text, "ngrams", n = 1) %>% 
    mutate(
      word = ifelse(
        lag(word) == "tree"
        & word == "of",
        paste0(word,"*"),
        word
      )
    ) %>%
    ungroup() %>%
    select(title:word) %>%
    filter(is.na(word) == F) %>%
    # Remove numbers
    filter(str_detect(word,"\\b\\d+\\b") == F) %>%
    mutate(
      tag = str_detect(word,"\\*"),
      running = cumsum(as.numeric(tag))
    ) %>%
    group_by(running) %>%
    mutate(word_n = row_number()) 
  
  lead_n <- df %>% top_n(-return_nchar/2,word_n) %>% filter(running != 0) 
  
  # Count increased by 1 includes tagged word
  lag_n <-  df %>% top_n((return_nchar/2)+1,word_n) %>% ungroup() %>% filter(running != max(running))
  
  out <- 
    lead_n %>% 
    bind_rows(lag_n) %>%
    ungroup() %>%
    arrange(running,word_n) %>%
    mutate(group = rep(1:return_nchar+1, length.out = nrow(.))) %>%
    mutate(
      tag = group == 1,
      running = cumsum(as.numeric(tag))
    ) %>%
    group_by(title,author,running) %>%
    select(title,author,running,word) %>%
    distinct() %>%
    # Reassemble unnested data into lines
    nest(word) %>%
    mutate(
      text = map(data, unlist), 
      text = map_chr(text, paste, collapse = " ")
    )
  
  return(out)
}


tst <- fathers %>% search_context(100)
