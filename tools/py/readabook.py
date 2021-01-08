
def readabook(ID):
    import urllib.request
    url = "http://www.gutenberg.org/cache/epub/" + str(ID) + "/pg" + str(ID) + ".txt"
    geturl = urllib.request.urlopen(url) 
    text = geturl.read()
    text = text.decode("utf-8") # convert from bytes object to string
    text = re.sub("[^\w]", " ",  text).split()
    return text

# Get a library...

# shakespeare = readabook(100)
# paradiselost = readabook(20)
# leavesofgrass = readabook(1322)
# mobydick = readabook(2701)
# grimm = readabook(2591)
# metamorphosis = readabook(5200)
# jekyll = readabook(43)
# iliad = readabook(6130) # Pope's translation
# pound_personae= readabook(41162)
# frost_boyswill = readabook(3021)
# frost_mtintrvl = readabook(29345)
# frost_noboston = readabook(3026)
# keats = readabook(23684)
# emily = readabook(12242)

# ulysses = readabook(4300)

