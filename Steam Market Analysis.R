
library(httr)
library(jsonlite)
library(dplyr)
library(readr)

#Pull top 100 games from SteamSpy
url <-"https://steamspy.com/api.php?request=top100in2weeks"

response <- GET(url)
raw_data <- content(response, as ="text", encoding = "UTF-8")
parsed <- fromJSON(raw_data)

#Convert to a clean data frame
steam_df <- bind_rows(lapply(parsed, function(x) {
  data.frame(
    app_id = x$appid,
    name = x$name,
    developer = x$developer,
    publisher = x$publisher,
    owners = x$owners,
    avg_playtime = x$average_forever,
    price = as.numeric(x$price) / 100,
    positive = x$positive,
    negative = x$negative,
    stringsAsFactors = FALSE
  )
}))

steam_df <- steam_df %>%
  mutate(
    total_reviews = positive + negative,
    review_score = round((positive / total_reviews)*100,1)
  )

glimpse(steam_df)

steam_df <- steam_df %>%
  #Pull the lower bound number out of owners range
  mutate(
    owners_lower = as.numeric(gsub(",","", sub(" \\.\\. .*","", owners))),
    #Flag free vs paid games
    is_free = ifelse(price == 0, "Free", "Paid")
  ) %>%
  #Drop Columns we won't use
  select(-avg_playtime, -owners) %>%
  #Remove any rows with missing review data
  filter(total_reviews > 0)

#1 Free vs paid - average review score
free_vs_paid <- steam_df %>%
  group_by(is_free) %>%
  summarise(
    count = n(),
    avg_review_score = round(mean(review_score),1),
    avg_price = round(mean(price), 2),
    median_owners = median(owners_lower)
  )
print(free_vs_paid)

#2 Top 10 highest rated games (min 10,000 reviews)
top_rated <-steam_df %>%
  filter(total_reviews >= 10000) %>%
  arrange(desc(review_score)) %>%
  select(name, price, review_score, total_reviews, is_free) %>%
  head(10)

#3 Price Distribution summary
price_summary <- steam_df %>%
  filter(is_free == "Paid") %>%
  summarise(
    min_price = min(price),
    max_price = max(price),
    avg_price = round(mean(price),2),
    median_price = median(price)
  )
print(price_summary)

#4 Top 10 most owned games 
most_owned <- steam_df %>%
  arrange(desc(owners_lower)) %>%
  select(name,price,owners_lower,review_score, is_free) %>%
  head(10)
print(most_owned)




