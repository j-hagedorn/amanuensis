# Make a function to join wordlists to RID

join_to_rid <- function(df){
  
  library(tidyverse); library(fuzzyjoin)
  
  rid %>% regex_join(df, by = c("regex_word" = "word"), mode = "inner", ignore_case = FALSE)
  
}