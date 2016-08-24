

# Script to search for words with high concentration 
# of specific letters or patterns within a particular 
# text file.


# First let's read in a file

with open("C:/Users/joshh/Documents/GitHub/english-words/words3.txt") as file:
    words = [word.strip() for word in file] # .strip function removes newline chars

# Then, define a function to find letters

def sonic_pattern ( letters = "aa", word_list = words, place = "anywhere" ):
   "This function finds words which contain"
   # First define the pattern as a regex string
   import re
   if place == "anywhere":
       letter_pattern = re.compile(letters + '*', re.IGNORECASE)
   elif place == "start":
       letter_pattern = re.compile('^' + letters + '*', re.IGNORECASE)
   elif place == "end":
       letter_pattern = re.compile(letters + '$', re.IGNORECASE)
   list_matches = []
   for line in word_list:
       matched = letter_pattern.search(line) 
       if matched:
           list_matches.append(line)
   return [list_matches] 
   
# Now, get some example words:
f = sonic_pattern(letters="f",place="end")
f

