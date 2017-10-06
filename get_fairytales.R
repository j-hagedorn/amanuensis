# get_fairy_tales

grimm <-
  gutenberg_download(2591, meta_fields = c("title","author"), strip = T) %>%
  # Remove header and footer matter
  slice(94:9150) %>%
  # Label chapters
  mutate(
    text = str_trim(text, side = "both"),
    # Start numbering a new chapter if line is all CAPS
    chap = cumsum(str_detect(text,regex("^[A-Z \\d\\W]+$",ignore_case = F)))
  ) %>%
  group_by(title, chap) %>%
  mutate(
    # Number paragraphs within each chapter
    para = cumsum(str_detect(text,regex("^[^a-z]*$",ignore_case = F))),
    # Number lines for reference
    line = row_number()
  )

grimm_words <-
  grimm %>%
  unnest_tokens(word, text, token = "ngrams", n = 4) 

grimm_words %>%
  group_by(words) %>%
  summarize(n = n()) %>%
  arrange(desc(n)) %>%
  View()

str_detect("THE GOLDEN BIRD",regex("^[A-Z \\d\\W]+$",ignore_case = F))
