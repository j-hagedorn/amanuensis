
found_sound <- function(word_list = words, letters = "aa", place = "anywhere") {
  
  library(dplyr); library(magrittr)
  # function returns a data.frame with the subset of a vector of words 
  # which match the defined pattern
  
  # word_list must be a data.frame, fun will take the column named "word"
  # if no column is titled "word" it takes the first column
  if ("word" %in% names(word_list)) {
    x <- word_list %>% select(word)
  } else x <- word_list[,1]
  
  if (place == "anywhere") {
    
    word <- grep(letters, x, value = T, ignore.case = T)
    
  } else if (place == "start") {
    
    word <- grep(paste0("^",letters), word_list, value = T, ignore.case = T)
    
  } else if (place == "end") {
    
    word <- grep(paste0(letters,"$"), word_list, value = T, ignore.case = T)
    
  } else print("Not a defined location")
  
  return(as.data.frame(word))
  
}

# Usage:
# found_sound("appar")
