get_r_reddit("dataisbeautiful", n = 100000)

url <- "https://www.reddit.com/r/AskReddit/comments/j0z4lp/formerly_suicidal_redditors_whats_something_that/"

comments <- "https://api.pushshift.io/reddit/submission/comment_ids/j0z4lp"

library(tidyverse); library(jsonlite)
reddit <- fromJSON("https://www.reddit.com/r/AskReddit/comments/j0z4lp/formerly_suicidal_redditors_whats_something_that/.json")


comment_id_list <- fromJSON(comments)

comment_id_list$data[1:5]

comments_id_url <- paste0("https://api.pushshift.io/reddit/comment/search?ids=",paste(comment_id_list$data[1:5],collapse = ","))

comments_df <- fromJSON(comments_id_url)

tst <- comments_df$data %>% as_tibble()

tst <- reddit$data$children[[2]]$data
tst <- reddit$data$children

library(RedditExtractoR)
x <- reddit_content(URL=url)


# "https://www.reddit.com/r/redditdev/comments/agw2si/retrieve_all_comments_from_a_subreddit/"