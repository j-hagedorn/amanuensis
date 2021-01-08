
# "https://www.reddit.com/r/AskReddit/comments/j0z4lp/formerly_suicidal_redditors_whats_something_that/"
# "https://www.reddit.com/r/AskReddit/comments/jgf6om/serious_whats_something_someone_told_you_when_you/"
# "https://www.reddit.com/r/AskReddit/comments/ij7e5n/suicidal_people_of_reddit_what_helped_keep_you/"
# "https://www.reddit.com/r/AskReddit/search?q=suicide&restrict_sr=1"

library(tidyverse); library(jsonlite)

found_urls <- 
  RedditExtractoR::reddit_urls(
    search_terms="suicide",
    subreddit = "AskReddit",
    page_threshold = 10,
    cn_threshold = 50
  )

get_reddit <- function(link_id,rate_limit = 200){
  
  # Get list of comment ids from Pushshift API
  comment_id_list <- fromJSON(paste0("https://api.pushshift.io/reddit/submission/comment_ids/",link_id))
  
  # Split into chunks to limit API query rate (assumes 200/minute)
  chunks <- split(comment_id_list$data, ceiling(seq_along(comment_id_list$data)/rate_limit))
  
  df <- tibble()
  
  for (i in chunks){
    x <- fromJSON(paste0("https://api.pushshift.io/reddit/comment/search?ids=",paste(i,collapse = ",")))
    x <- x$data %>% select(id,parent_id,link_id,subreddit,author_fullname,author,created_utc,body,score)
    df <- bind_rows(df,x)
    Sys.sleep(60)
  }
  
  return(df)
  
}

reasons_to_live <- get_reddit("j0z4lp")

# write_csv(reasons_to_live,"gleanings/reddit_df.csv")

# "https://www.reddit.com/r/redditdev/comments/agw2si/retrieve_all_comments_from_a_subreddit/"