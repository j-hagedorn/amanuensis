# Getcha lexica

# Use stringdist to find all words most similar to / distinct from a given word
library(tidyverse); library(magrittr)

# Get works from Project Gutenberg
library(gutenbergr); library(tidytext); library(stringr)

gutenberg_works() %>% 
  left_join(gutenberg_subjects) %>%
  #filter(str_detect(author, 'Wells')) %>%
  #filter(str_detect(title, 'physics')) %>%
  #filter(str_detect(subject, 'science')) %>%
  View()

gutenberg_subjects %>% View()

##### Paradise Lost ######

paradiselost <-
  gutenberg_download(20,meta_fields = c("title","author"),strip = T) %>%
  # Label books
  mutate(section = cumsum(str_detect(text,regex("^  BOOK",ignore_case = F)))) %>%
  # Remove filler text between books
  filter(text != "  PARADISE LOST") %>%
  filter(grepl("*THE END OF THE*",text) == F) %>%
  # Remove header and footer matter
  slice(26:10980) %>%
  # Number lines for reference
  mutate(line = row_number()) 

##### Leaves of Grass ######

leaves <-
  gutenberg_download(1322,meta_fields = c("title","author"),strip = T) %>%
  # Label books
  mutate(section = cumsum(str_detect(text,regex("^BOOK ",ignore_case = F)))) %>%
  # Remove header and footer matter
  slice(23:17859) %>%
  # Number lines for reference
  mutate(line = row_number()) 


##### Moby Dick ######

moby <-
  gutenberg_download(2489,meta_fields = c("title","author"),strip = T) %>%
  # Label chapters
  mutate(section = cumsum(str_detect(text,regex("^*CHAPTER [[:digit:]]",ignore_case = F)))) %>%
  # Number lines for reference
  mutate(line = row_number()) 

##### Keats' Collected Works #####

keats <-
  gutenberg_download(c(8209,23684),meta_fields = c("title","author"),strip = T) %>%
  # Remove header and footer matter
  slice(21:6253) %>%
  # Remove commentary
  slice(c(1:2104,2715:6233)) %>%
  # Label chapters
  mutate(
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(alt_text,regex("^[[:upper:]]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

##### Frost Poems ####

frost <- 
  gutenberg_download(c(3021, 3026, 29345),meta_fields = c("title","author"),strip = T) %>%
  # Remove header and footer matter
  slice(c(84:1046,1061:1070,1095:3258,3341:5228)) %>%
  # Label chapters
  mutate(
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(alt_text,regex("^[[:upper:]]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

##### Pound ####

pound <- 
  gutenberg_download(c(23538,40200,41162,51992),meta_fields = c("title","author"),strip = T) %>%
  # Remove header and footer matter
  slice(c(20:641,679:682,735:1782,1947:3707,3862:6274)) %>%
  # Label chapters
  mutate(
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(alt_text,regex("^[[:upper:]]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

##### Emily Dickinson ####

emily <- 
  gutenberg_download(12242,meta_fields = c("title","author"),strip = T) %>%
  # Remove header and footer matter
  slice(157:10304) %>%
  # Label chapters
  mutate(
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(alt_text,regex("^[[:upper:]]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

##### Grimm Brothers ####

grimm <-
  gutenberg_download(2591, meta_fields = c("title","author"), strip = T) %>%
  # Remove header and footer matter
  slice(94:9150) %>%
  # Label chapters
  mutate(
    text = str_trim(text, side = "both"),
    author = "Brothers Grimm",
    # Start numbering a new chapter if line is all CAPS
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(text,regex("^[A-Z \\d\\W]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

#### Mother Goose #####

goose <-
  gutenberg_download(17208, meta_fields = c("title","author"), strip = T) %>%
  # Remove header and footer matter
  slice(140:2005) %>%
  # Label chapters
  mutate(
    text = str_trim(text, side = "both"),
    # Start numbering a new chapter if line is all CAPS
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(text,regex("^[A-Z \\d\\W]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

#### Lucretius

de_rerum <- 
  gutenberg_download(785, meta_fields = c("title","author"), strip = T) %>%
  # Label books
  mutate(section = cumsum(str_detect(text,regex("^BOOK",ignore_case = F)))) %>%
  # Remove filler text between books
  filter(!(text == "" & lead(text) == "")) %>%
  # Number lines for reference
  mutate(
    text = str_trim(text, side = "both"),
    section = cumsum(str_detect(text,regex("^[A-Z \\d\\W]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  # Remove header and footer matter
  slice(11:10195) 

##### Five of Maxwell's Papers 

maxwell <- 
  gutenberg_download(4908, meta_fields = c("title","author"), strip = T) %>%
  # Remove header and footer matter
  slice(14:1553) %>%
  # Remove filler text between books
  filter(!(text == "" & lead(text) == "")) %>%
  # Number lines for reference
  mutate(
    text = str_trim(text, side = "both"),
    section = cumsum(str_detect(text,regex("^\\[From the",ignore_case = F))),
    line = row_number()
  ) 

# Proust

proust <- 
  gutenberg_download(7178, meta_fields = c("title","author"), strip = T) %>%
  # Remove header and footer matter
  slice(34:17061) %>%
  # Remove filler text between books
  filter(!(text == "" & lead(text) == "")) %>%
  # Number lines for reference
  mutate(
    # text = str_trim(text, side = "both"),
    section = cumsum(str_detect(text,regex("^[A-Z \\d\\W]+$",ignore_case = F))),
    line = row_number()
  ) 

##### Common Minerals and Rocks

# Principles of Geology, by Charles Lyell 
# Theory of the Earth, Volume 1 (of 4), by James Hutton 
# The Student's Elements of Geology by Lyell 
# Making A Rock Garden 

rocks <- 
  gutenberg_download(
    c(49271,33224,12861,3772,24496),
    meta_fields = c("title","author"),
    strip = T
  ) %>%
  # Remove header and footer matter
  slice(c(5288:23238,27411:38871,38987:39693,39760:39838,33224:82169,86448:91722)) %>%
  # Label chapters
  mutate(
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(alt_text,regex("^[[:upper:]]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

# Ruskin
# Various 26716
# Val d'Arno Ten Lectures on the Tuscan Art 8523
# The Queen of the Air: Greek Myths of Cloud and Storm 12641
# The Poetry of Architecture 17774
# Giotto and his works in Padua 18371
# Lectures on Art 19164
# Lectures on Landscape 20019
# The Stones of Venice 30754, 30755, 30756
# Eagle's Nest...relation of Natural Science to Art 42917

ruskin <- 
  gutenberg_download(
    c(26716,8523,12641,17774,18371,19164,
      20019,30754,30755,30756,42917),
    meta_fields = c("title","author"),
    strip = T
  ) %>%
  # Remove filler text between books
  filter(!(text == "" & lead(text) == "")) %>%
  # Number lines for reference
  mutate(
    text = str_trim(text, side = "both"),
    section = NA,
    line = row_number()
  ) 

# Clausewitz's 'On War'

clausewitz <- 
  gutenberg_download(
    c(1946),
    meta_fields = c("title","author"),
    strip = T
  ) %>%
  # Remove header and footer matter
  slice(c(525:10922)) %>%
  # Remove filler text between books
  filter(!(text == "" & lead(text) == "")) %>%
  mutate(
    text = str_trim(text, side = "both"),
    alt_text = gsub("[[:punct:]]|[[:space:]]|[0-9]","",str_trim(text)),
    section = cumsum(str_detect(alt_text,regex("^[[:upper:]]+$",ignore_case = F))),
    line = row_number()
  ) %>%
  select(-alt_text)

#### COMBINE INTO CORPUS ####

# Bind together
# Must have colnames: 
# "gutenberg_id","text","title","author","section","line"

corpus <-
  paradiselost %>%
  bind_rows(leaves) %>%
  bind_rows(emily) %>%
  bind_rows(keats) %>%
  bind_rows(frost) %>%
  bind_rows(pound) %>%
  bind_rows(moby) %>%
  bind_rows(proust) %>%
  bind_rows(grimm) %>%
  bind_rows(maxwell) %>%
  bind_rows(de_rerum) %>%
  bind_rows(rocks) %>%
  bind_rows(ruskin) %>% 
  bind_rows(clausewitz)

# Write to file to save
feather::write_feather(corpus,"corpus.feather")

# Remove individual df to clean workspace
rm(paradiselost);rm(leaves);rm(emily)
rm(keats);rm(frost);rm(pound);rm(moby)
rm(grimm);rm(de_rerum);rm(rocks);rm(maxwell)
rm(ruskin);rm(proust);rm(clausewitz)

#### NOT YET READ IN ####

# Donne Poems

donne <- gutenberg_download(c(48688, 48772))

tst <-
  donne %>%
  filter(grepl("_",text) == F) %>% 
  slice(c(1046:1068))





##### Wild Flowers East of the Rockies

wildflowers <- gutenberg_download(45676)

# Wild Flowers Worth Knowing 8866
# Trees: A Woodland Notebook Containing Observations on Certain British and Exotic Trees 39946

# MONISM AS CONNECTING RELIGION AND SCIENCE Haeckel 9199
# The Temple of Nature; or, the Origin of Society Darwin, Erasmus 26861


# Lectures on The Science of Language 32856


# Five Stages of Greek Religion 30250
# Euripides and His Age 35472

# Get a library...

# shakespeare: 100
# metamorphosis: 5200
# jekyll: 43
# pope_iliad: 6130
# ulysses: 4300


# Get some functions
source("found_sound.R")
