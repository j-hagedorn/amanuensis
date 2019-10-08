# letter_fqy.R

# Load libraries
library(tidyverse); library(tidytext); library(fuzzyjoin)

# Source dependencies
source("get_words.R"); source("read_RID.R")

# Create function to count unique chars in string
library(inline)

.char_unique_code <- "
  std::vector < std::string > s = as< std::vector < std::string > >(x);
  unsigned int input_size = s.size();
  
  std::vector < std::string > chrs(input_size);
  
  for (unsigned int i=0; i<input_size; i++) {
  
  std::string t = s[i];
  
  for (std::string::iterator chr=t.begin();
  chr != t.end(); ++chr) {
  
  if (chrs[i].find(*chr) == std::string::npos) {
  chrs[i] += *chr;
  }
  
  }
  
  }
  return(wrap(chrs));
"

char_unique <- 
  rcpp(
    sig = signature(x = "std::vector < std::string >"),
    body = .char_unique_code,
    includes = c("#include <string>","#include <iostream>")
  )

char_ct_unique <- function(x) nchar(char_unique(x))


letter_fqy <-
  words %>%
  mutate(
    len = nchar(as.character(word)),
    # Count concentration of letters 
    a = str_count(word,"a"),
    b = str_count(word,"b"),
    c = str_count(word,"c"),
    d = str_count(word,"d"),
    e = str_count(word,"e"),
    f = str_count(word,"f"),
    g = str_count(word,"g"),
    h = str_count(word,"h"),
    i = str_count(word,"i"),
    j = str_count(word,"j"),
    k = str_count(word,"k"),
    l = str_count(word,"l"),
    m = str_count(word,"m"),
    n = str_count(word,"n"),
    o = str_count(word,"o"),
    p = str_count(word,"p"),
    q = str_count(word,"q"),
    r = str_count(word,"r"),
    s = str_count(word,"s"),
    t = str_count(word,"t"),
    u = str_count(word,"u"),
    v = str_count(word,"v"),
    w = str_count(word,"w"),
    x = str_count(word,"x"),
    y = str_count(word,"y"),
    z = str_count(word,"z"),
    vowel = str_count(word,"[aeiouy]"),
    consonant = str_count(word,"[bcdfghjklmnpqrstvwxz]"),
    # Identify types of sounds
    sibilants = str_count(word,"s|sh|z|x"), 
    fricatives = str_count(word,"f|v|s|sh|th|z|x"), 
    plosives = str_count(word,"p|b"), 
    dentals = str_count(word,"t|d|th"), 
    nasals = str_count(word,"m|n|ng"), 
    liquids = str_count(word,"l|r"), 
    gutterals = str_count(word,"\\w*(?<!n)g|k"), # All 'g' not preceded by 'n'
    # Label by place of articulation
    bilabial = str_count(word,"p|b|m"),
    labiodental = str_count(word,"f|v"), 
    dental = str_count(word,"th"), 
    alveolar = str_count(word,"t|d|l|n|s|z"), 
    velar = str_count(word,"k|g|ng"),
    glottal = str_count(word,"\\w*(?<!t)h"), # All 'h' not preceded by 't'
    # Label by manner of articulation 
    closure = str_count(word,"p|b|t|d|k|g|s|ng"), 
    narrowing = str_count(word,"th|s|z"),
    frictionless = str_count(word,"w|v|j"),
    # Count n of distinct letters in word
    distinct_letters = NA,
    # distinct_letters = char_ct_unique(as.character(word)),
    # Find words with double letters in middle of word (e.g. dd pp ll)
    double = str_detect(
      word,
      ".(aa|bb|cc|dd|ee|ff|gg|hh|ii|jj|kk|ll|mm|nn|oo|pp|qq|rr|ss|tt|uu|vv|ww|xx|yy|zz)."
    ),
    proper = str_detect(word,"\\b([A-Z]\\w*)\\b"),
    gerund = str_detect(word, "ing$"),
    punct = str_detect(word, "[[:punct:]]"),
    number = str_detect(word, "[0-9]"),
    prep = word %in% as.list(prepositions$word),
    first_letter = str_sub(word, start = 1, end = 1),
    last_letter = str_sub(word, start = -1, end = -1)
  ) %>%
  mutate_at(
    .vars = vars(a:distinct_letters),
    .funs = funs(. / len)
  ) 


# Create groups based on similarity of letter frequency

k_df <- 
  letter_fqy %>%
  select(word, a:z) %>%
  filter(complete.cases(.)) 

k_groups <- 
  k_df %>% 
  select(a:z) %>%
  kmeans(centers = 500)

k_df$k_group <- k_groups$cluster
k_df %<>% select(word,k_group)

letter_fqy %<>% left_join(k_df, by = "word")
  
rm(k_df); rm(k_groups)


# Working lexicon

lexicon <-
  letter_fqy %>%
  # filter out unnecessary words
  filter(punct == F & number == F & proper == F) %>%
  select(-punct,-number,-proper)

feather::write_feather(lexicon,"lexicon.feather")
