
# Script 2-sdgs-unique-expressions gets almost all possible expressions from the text2sdgs queries. 
# These are expanded using ChatGPT when there are asteriscs *
# We can use this to get more accurate features after the text2sdgs analysis

library(dplyr)
library(stringr)
library(tidyr)
library(purrr)
library(tibble)

# List all queries text2sdg queries ----
data("aurora_queries", package = "text2sdg")
data("auckland_queries", package = "text2sdg")
data("elsevier_queries", package = "text2sdg")
data("sdgo_queries", package = "text2sdg")
data("sdsn_queries", package = "text2sdg")
data("siris_queries", package = "text2sdg")

# combinar totes les consultes
all_queries <- bind_rows(
  aurora_queries,
  auckland_queries,
  elsevier_queries,
  sdgo_queries,
  sdsn_queries,
  siris_queries
) %>%
  mutate(query = as.character(query))

rm(auckland_queries,aurora_queries,elsevier_queries,sdgo_queries,sdsn_queries,siris_queries)


# Get composed expressions ----
extract_literals <- function(query_row) {
  matches <- str_match_all(query_row$query, '"([^"]+)"')[[1]][, 2]
  if (length(matches) == 0) return(NULL)
  tibble(expression = matches)
}

unique_expressions <- map_dfr(1:nrow(all_queries), ~extract_literals(all_queries[., ])) %>%
  mutate(expression = tolower(expression)) %>%   # convertir a minúscula abans de filtrar
  distinct(expression) %>%
  arrange(expression) %>% 
  mutate(n_words = str_count(expression, "\\S+")) %>%
  filter(n_words > 1) %>%
  select(expression)

# # Export expressions with * to complete with GPT 
# expressions_with_star <- unique_expressions %>%
#   filter(stringr::str_detect(expression, "\\*"))
# 
# # Exportar a CSV
# write_csv(expressions_with_star, "./sandbox/expressions_with_star.csv")

expressions_expanded <- read_csv("./resources/asterisc_expressions_expanded.csv")
expanded_long <- expressions_expanded %>%
  filter(!is.na(expansions)) %>%
  separate_rows(expansions, sep = ",") %>%
  mutate(expansions = str_trim(expansions)) %>%
  filter(expansions != "") %>%
  distinct(expansions) %>%
  rename(expression = expansions)

unique_expressions <- unique_expressions %>%
  filter(!stringr::str_detect(expression, "\\*")) %>% 
  rbind(expanded_long)

rm(all_queries,expanded_long,expressions_expanded)