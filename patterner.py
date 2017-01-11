

# Script to search for words with high concentration 
# of specific letters or patterns within a particular 
# text file.


# First let's read in a file

with open("C:/Users/joshh/Documents/GitHub/english-words/words.txt") as file:
    words1 = [word.strip() for word in file] # .strip function removes newline chars

with open("C:/Users/joshh/Documents/GitHub/english-words/words2.txt") as file:
    words2 = [word.strip() for word in file] # .strip function removes newline chars

with open("C:/Users/joshh/Documents/GitHub/english-words/words3.txt") as file:
    words3 = [word.strip() for word in file] # .strip function removes newline chars
    
words = list(set(words1 + words2 + words3))

# Set the working directory
os.chdir('C:/Users/joshh/Documents/GitHub/amanuensis/text_files')

# Then, define a function to find letters

def sonic_pattern ( letters = "aa", word_list = words, place = "anywhere" ):
   "This function finds words which contain a given letter pattern at a defined point in the word"
   # First define the pattern as a regex string
   import re
   if place == "anywhere":
       letter_pattern = re.compile(letters, re.IGNORECASE)
   elif place == "start":
       letter_pattern = re.compile('^' + letters, re.IGNORECASE)
   elif place == "end":
       letter_pattern = re.compile(letters + '$', re.IGNORECASE)
   word_list = list(set(word_list)) # Remove duplicates in list
   list_matches = []
   for line in word_list:
       matched = letter_pattern.search(line) 
       if matched:
           list_matches.append(line)
   filename = 'matches_'+letters+'_'+place+'.txt'
   thefile = open(filename, 'w')
   for item in list_matches:
       thefile.write("%s\n" % item)
   return list_matches
   
# Now, get some example words:
end_f = sonic_pattern(letters="f",place="end")
any_k = sonic_pattern(letters="k",place="anywhere")
any_kk = sonic_pattern(letters="kk",place="anywhere")
end_nn = sonic_pattern(letters="nn",place="end")
end_y_walt = sonic_pattern("y", leavesofgrass, "end")
start_w_walt = sonic_pattern("w", leavesofgrass, "start")
any_ou_emily = sonic_pattern("ou", emily, "anywhere")
any_bb = sonic_pattern(letters = "bb",place="anywhere")
