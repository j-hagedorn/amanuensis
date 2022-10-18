library(tidyverse); library(tidytext); library(stringdist)
# https://ccel.org/ccel/b/bible/darby/cache/darby.txt
# https://ccel.org/ccel/a/anonymous2/cloud/cache/cloud.txt
# https://ccel.org/ccel/t/traherne/centuries/cache/centuries.txt

douayr <-
  readLines("https://ccel.org/ccel/b/bible/douayr/cache/douayr.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  slice(48:125522) %>%
  mutate(
    title = "The Holy Bible: Douay-Rheims",
    author = "Anonymous"
  )

pseudo_dionysius <-
  readLines("https://ccel.org/ccel/d/dionysius/works/cache/works.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  slice(392:11459) %>%
  mutate(
    title = "Divine Names, Mystic Theology, Letters, etc.",
    author = "Pseudo-Dionysius, the Areopagite"
  )  

pseudo_dionysius_2 <-
  readLines("https://ccel.org/ccel/d/dionysius/celestial/cache/celestial.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  slice(18:1769) %>%
  mutate(
    title = "The Heavenly Hierarchy and the Ecclesiastical Hierarchy",
    author = "Pseudo-Dionysius, the Areopagite"
  ) 

anf01 <-
  readLines("https://ccel.org/ccel/s/schaff/anf01/cache/anf01.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  mutate(
    title = "ANF01. The Apostolic Fathers with Justin Martyr and Irenaeus",
    author = "Various"
  )  

anf02 <-
  readLines("https://ccel.org/ccel/s/schaff/anf02/cache/anf02.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  mutate(
    title = "ANF02. Fathers of the Second Century: Hermas, Tatian, Athenagoras, Theophilus, and Clement of Alexandria (Entire)",
    author = "Various"
  ) 

npnf07 <-
  readLines("https://ccel.org/ccel/s/schaff/anf02/cache/anf02.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  mutate(
    title = "NPNF2-07. Cyril of Jerusalem, Gregory Nazianzen",
    author = "Various"
  ) 

npnf09 <-
  readLines("https://ccel.org/ccel/s/schaff/npnf209/cache/npnf209.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  mutate(
    title = "NPNF2-09. Hilary of Poitiers, John of Damascus",
    author = "Various"
  ) 

npnf13 <-
  readLines("https://ccel.org/ccel/s/schaff/npnf213/cache/npnf213.txt",skipNul = T) %>% 
  as.data.frame() %>%
  rename_all(list(~str_replace(., pattern = "\\.", replacement = "text"))) %>%
  mutate(
    title = "NPNF-213. Gregory the Great (II), Ephraim Syrus, Aphrahat",
    author = "Various"
  ) 

df <- 
  bind_rows(
    douayr,anf01,anf02,npnf07,npnf09,npnf13,
    pseudo_dionysius,pseudo_dionysius_2
  ) %>%
  group_by(author, title) %>%
  unnest_tokens(text, text, "paragraphs") %>%
  mutate(
    text = str_squish(text),
    text = str_remove_all(text,"_{2,}")
  ) %>%
  filter(!str_detect(text, "^\\[[0-9]{1,}\\]")) %>%
  mutate(
    chapter = if_else(str_detect(text,"^chapter "),text,NA_character_),
    text = str_remove_all(text,"[0-9]{1,}"),
    text = str_remove_all(text,"\\[|\\]"),
    text = str_squish(text)
  ) %>%
  fill(chapter, .direction = "down") %>%
  filter(!str_detect(text, "^chapter ")) %>%
  filter(!str_detect(text, "file:///ccel")) %>%
  filter(!is.na(chapter))
  
rm(list = c("douayr","anf01","anf02","npnf07","npnf09","npnf13","pseudo_dionysius","pseudo_dionysius_2"))

write_rds(df,"data/fathers.rds")

