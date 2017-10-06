# letter_fqy.R

# Count concentration of similar letters 
# Find all words with highest concentration of a letter


letter_fqy <-
  words %>%
  mutate(
    len = nchar(as.character(word)),
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
    # Find words with double letters in middle of word (e.g. dd pp ll)
    double = str_detect(word,".(aa|bb|cc|dd|ee|ff|gg|hh|ii|jj|kk|ll|mm|nn|oo|pp|qq|rr|ss|tt|uu|vv|ww|xx|yy|zz)."),
    proper = str_detect(word,"\\b([A-Z]\\w*)\\b")
  ) %>%
  mutate_at(
    .vars = vars(a:consonant),
    .funs = funs(. / len)
  )

tst <- 
  letter_fqy %>%
  select(a:z) %>%
  filter(complete.cases(.)) %>%
  kmeans(centers = 1000)
  
# row.names(tst) <- tst$word
# tst <- kmeans(letter_fqy, 10)
