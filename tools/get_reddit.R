
# "https://www.reddit.com/r/AskReddit/comments/j0z4lp/formerly_suicidal_redditors_whats_something_that/"
library(tidyverse); library(jsonlite)

link_id <- "j0z4lp"

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



# Get list of comment ids from Pushshift API
comment_id_list <- fromJSON(paste0("https://api.pushshift.io/reddit/submission/comment_ids/",link_id))

# Split into chunks to limit API query rate (assumes 200/minute)
chunks <- split(comment_id_list$data, ceiling(seq_along(comment_id_list$data)/200))

df <- tibble()

for (i in chunks){
  
  x <- fromJSON(paste0("https://api.pushshift.io/reddit/comment/search?ids=",paste(i,collapse = ",")))
  x <- x$data %>% select(id,parent_id,link_id,subreddit,author_fullname,author,created_utc,body,score)
  df <- bind_rows(df,x)
  Sys.sleep(60)
  
}




# "https://www.reddit.com/r/redditdev/comments/agw2si/retrieve_all_comments_from_a_subreddit/"