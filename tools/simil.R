
# Load dependencies

library(stringdist); library(tidyverse)

# Define functions

rearrange <- function(string1,string2,alg = "jw",goldilocks=c(0.01,0.30)) {
  # Function takes 2 vectors of strings, of the same size
  # and returns a dataframe of matches based on similarity
  # Args:
    # string1,string2 : the 2 string vectors
    # alg: Algorithm used for similarity, passed to stringdist::stringdistmatrix()
    # goldilocks: Numeric vector of the low and high scores for matching accuracy
  
  # Create distance matrix computing string diff
  stringdistmatrix(string1,string2, method = alg, useNames = T)  %>%
    as.data.frame() %>%
    mutate(rawtext = row.names(.)) %>%
    group_by(rawtext) %>%
    gather(coded,score,-rawtext) %>%
    mutate(rank = row_number(score)) %>%
    # keep only the most accurate
    filter(score >= goldilocks[1], score < goldilocks[2])

}
  
rhyme <- function(string1,string2) {
  # Function takes 2 vectors of strings, of the same size
  # and returns a dataframe of matches based on similarity
  # Args:
  # string1,string2 : the 2 string vectors

  # Create distance matrix computing string diff
  stringdistmatrix(string1,string2, method = 'soundex', useNames = T)  %>%
    as.data.frame() %>%
    mutate(rawtext = row.names(.)) %>%
    group_by(rawtext) %>%
    gather(coded,score,-rawtext) %>%
    mutate(rank = row_number(score)) %>%
    # keep only rhymes
    filter(score == 0) %>%
    # remove exact rhymes
    filter(rawtext != coded)
  
}
  
# Notes:
# Option to remove suffixes (e.g. -ness, -est, etc.)
# Option to remove words with same first letter
# Take a string and find all permutations of it (words, bigrams, trigrams)
# Pass df of words in chunks to stringdistmatrix() and combine (so don't have to slice)
# Remove dups from strings before passing to stringdistmatrix()

