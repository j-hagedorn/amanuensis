#!/usr/bin/python 
# -*- coding: utf-8 -*-
"""
Reading and Counting
Created on Mon Dec 23 23:46:48 2013
@author: jhagedorn
Dystopia Beer
"""
#%%  Define function, Wordcount
def wordcount(text):
    counts = {} # Make an empty dictionary 
    for i in words: 
        if i in counts: # Add each word to dictionary & count repeats 
            counts[i] += 1
        else: 
            counts[i] = 1
        for w in sorted(counts, key=counts.get, reverse=True): 
            # print w, counts[w] # Sort and print words by frequency 
            highest = max(counts.values()) 
            print [i for i,v in counts.items() if v == highest] 
    return counts
    
#%% Run program
url = 'http://www.gutenberg.org/cache/epub/1322/pg1322.txt'
import urllib2 
geturl = urllib2.urlopen(url) 
text = geturl.read() 
text = text.lower()
strip = text.replace('\n', ' ').replace('\r', ' ').replace(',', ' ').replace('.', ' ').replace('-', ' ')
words = strip.split(' ')[0:] 
wordcount = wordcount(words)

#%%

# Possible code to shave off Project Gutenburg Headers and Footers
#for line in text:
#                if (not FALSE):
#                    if (line.startswith("*** START OF THIS PROJECT GUTENBERG EBOOK")):
#                        fout = open(outfile, "w")
#                        print "Copying: " + f
#                        bCopying = True
#
#                elif (FALSE):
#                    if (line.startswith("*** END OF THIS PROJECT GUTENBERG EBOOK")):
#                        fout.close()
#                        bCopying = False
#                    else:
#                        fout.write(line)
