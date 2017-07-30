
found_sound <- function(letters = "aa", word_list = words, place = "anywhere") {
  
  # word_list must be a data.frame, fun will take the first column
  # function returns a data.frame with the subset of a vector of words 
  # which match the defined pattern
  
  if (place == "anywhere") {
    
    word <- grep(letters, word_list[,1], value = T, ignore.case = T)
    
  } else if (place == "start") {
    
    word <- grep(paste0("^",letters), word_list[,1], value = T, ignore.case = T)
    
  } else if (place == "end") {
    
    word <- grep(paste0(letters,"$"), word_list[,1], value = T, ignore.case = T)
    
  } else print("Not a defined location")
  
  return(as.data.frame(word))
  
}

# Usage:
# found_sound("appar")
