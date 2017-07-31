## Get series of books for use as corpora

poem_corpus <-
  gutenberg_download(
    c(
      20,   # Paradise Lost
      1322, # Leaves of Grass
      8209, # Keats Poems 1817
      23684,# Keats: Poems Published in 1820
      3021, # Frost A Boy's Will
      3026, # Frost North of Boston
      29345,# Frost Mountain Interval
      48688,# Donne vol 1
      48772,# Donne vol 2
      23538,# Pound Hugh Selwyn Mauberley
      40200,# Pound Exultations
      41162,# Pound Personae
      51992,# Pound Poems 1918-21
      12242 # Dickinson
    ), 
    meta_fields = c("title","author"),
    strip = T
  )

corpus <-
  poem_corpus %>% 
  mutate(
    gutenberg_id = as.factor(gutenberg_id)
  ) %>%
  group_by(author,title,gutenberg_id) %>%
  mutate(line = row_number()) %>%
  nest()

tst <-
  corpus %>% unnest()
  mutate(
    words = map(.data, unnest_tokens(.word, .text))
  )