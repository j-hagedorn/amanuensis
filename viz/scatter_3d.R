library(plotly)

lexicon %>%
  filter(
    len %in% c(3:10) & k_group <= 10
  ) %>%
  plot_ly(
    x = ~distinct_letters, 
    y = ~vowel, 
    z = ~consonant, 
    color = ~k_group, 
    size = ~log(len), 
    # colors = colors,
    marker = list(
      symbol = 'circle', 
      sizemode = 'diameter'
    ), 
    sizes = c(5, 150),
    text = ~paste(
      'Word:', word,
      '<br>Ratio of distinct letters:', distinct_letters,
      '<br>Proportion vowels:', vowel,
      '<br>Proportion consonants:', consonant,
      '<br>Letters:', len,
      '<br>Group:', k_group
    )
  ) 
