
https://ccel.org/ccel/b/bible/douayr/cache/douayr.txt
https://ccel.org/ccel/b/bible/darby/cache/darby.txt
https://ccel.org/ccel/a/anonymous2/cloud/cache/cloud.txt
https://ccel.org/ccel/t/traherne/centuries/cache/centuries.txt

pseudo_dionysius <-
  readLines("https://ccel.org/ccel/d/dionysius/works/cache/works.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  slice(670:16739) %>%
  mutate(
    title = "Divine Names, Mystic Theology, Letters, etc.",
    author = "Pseudo-Dionysius, the Areopagite"
  ) %>%
  # Label rows
  mutate(line = row_number()) 

pseudo_dionysius_2 <-
  readLines("https://ccel.org/ccel/d/dionysius/celestial/cache/celestial.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  mutate(
    title = "The Heavenly Hierarchy and the Ecclesiastical Hierarchy",
    author = "Pseudo-Dionysius, the Areopagite"
  ) %>%
  # Label rows
  mutate(line = row_number()) 

anf01 <-
  readLines("https://ccel.org/ccel/s/schaff/anf01/cache/anf01.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  mutate(
    title = "ANF01. The Apostolic Fathers with Justin Martyr and Irenaeus",
    author = "Various"
  ) %>%
  # Label rows
  mutate(line = row_number()) 

anf02 <-
  readLines("https://ccel.org/ccel/s/schaff/anf02/cache/anf02.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  mutate(
    title = "ANF02. Fathers of the Second Century: Hermas, Tatian, Athenagoras, Theophilus, and Clement of Alexandria (Entire)",
    author = "Various"
  ) %>%
  # Label rows
  mutate(line = row_number())

npnf07 <-
  readLines("https://ccel.org/ccel/s/schaff/anf02/cache/anf02.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  mutate(
    title = "NPNF2-07. Cyril of Jerusalem, Gregory Nazianzen",
    author = "Various"
  ) %>%
  # Label rows
  mutate(line = row_number())

npnf09 <-
  readLines("https://ccel.org/ccel/s/schaff/npnf209/cache/npnf209.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  mutate(
    title = "NPNF2-09. Hilary of Poitiers, John of Damascus",
    author = "Various"
  ) %>%
  # Label rows
  mutate(line = row_number())

npnf13 <-
  readLines("https://ccel.org/ccel/s/schaff/npnf213/cache/npnf213.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(funs(gsub(.)), pattern = ".", replacement = "text") %>%
  mutate(
    title = "NPNF-213. Gregory the Great (II), Ephraim Syrus, Aphrahat",
    author = "Various"
  ) %>%
  # Label rows
  mutate(line = row_number())



