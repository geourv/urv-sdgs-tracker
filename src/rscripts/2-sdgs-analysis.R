########### SDGs analysis for all data combined----
library(text2sdg)
library(corpustools)
library(readr)
library(dplyr)
library(purrr)

# Read the data frame
course_details_df <- read_csv("./data/course_details_df.csv")

# Block 1: course_name_en, description_en, contents_en
sdg_analysis_df_descriptive <- course_details_df %>%
  mutate(data_combined = paste(course_name_en, description_en, contents_en, sep = ";"))

sdg_analysis_df_results_descriptive <- detect_sdg_systems(sdg_analysis_df_descriptive$data_combined,
                                                          system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))

# Apply substitutions in the features
patterns <- gsub(" ", ", ", unique_expressions$expression, fixed = TRUE)
replacements <- unique_expressions$expression

sdg_analysis_df_results_descriptive$features_fixed <- Reduce(function(x, i) {
  gsub(patterns[i], replacements[i], x, fixed = TRUE)
}, seq_along(patterns), init = sdg_analysis_df_results_descriptive$features)

sdg_analysis_df_results_descriptive <-
  sdg_analysis_df_results_descriptive %>%
  select(-features) %>%
  rename(features = features_fixed)

write.csv(sdg_analysis_df_results_descriptive, "./sandbox/sdg_analysis_df_results_descriptive.csv", row.names = FALSE)

# Block 2: competences_learning_results_en
sdg_analysis_df_competencial <- course_details_df %>%
  mutate(data_combined = paste(competences_learning_results_en, sep = ";"))

sdg_analysis_df_results_competencial <- detect_sdg_systems(sdg_analysis_df_competencial$data_combined,
                                                           system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))

# Apply substitutions in the features
sdg_analysis_df_results_competencial$features_fixed <- Reduce(function(x, i) {
  gsub(patterns[i], replacements[i], x, fixed = TRUE)
}, seq_along(patterns), init = sdg_analysis_df_results_competencial$features)

sdg_analysis_df_results_competencial <-
  sdg_analysis_df_results_competencial %>%
  select(-features) %>%
  rename(features = features_fixed)

write.csv(sdg_analysis_df_results_competencial, "./sandbox/sdg_analysis_df_results_competencial.csv", row.names = FALSE)

# Block 3: references_en
sdg_analysis_df_bibliographical <- course_details_df %>%
  mutate(data_combined = paste(references_en, sep = ";"))

sdg_analysis_df_results_bibliographical <- detect_sdg_systems(sdg_analysis_df_bibliographical$data_combined,
                                                              system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))

# Apply substitutions in the features
sdg_analysis_df_results_bibliographical$features_fixed <- Reduce(function(x, i) {
  gsub(patterns[i], replacements[i], x, fixed = TRUE)
}, seq_along(patterns), init = sdg_analysis_df_results_bibliographical$features)

sdg_analysis_df_results_bibliographical <-
  sdg_analysis_df_results_bibliographical %>%
  select(-features) %>%
  rename(features = features_fixed)

write.csv(sdg_analysis_df_results_bibliographical, "./sandbox/sdg_analysis_df_results_bibliographical.csv", row.names = FALSE)

# Read the saved results if necessary
sdg_analysis_df_results_descriptive <- read_csv("./sandbox/sdg_analysis_df_results_descriptive.csv")
sdg_analysis_df_results_competencial <- read_csv("./sandbox/sdg_analysis_df_results_competencial.csv")
sdg_analysis_df_results_bibliographical <- read_csv("./sandbox/sdg_analysis_df_results_bibliographical.csv")

# Additional processing for block 1
sdg_summary_df_descriptive <- sdg_analysis_df_results_descriptive %>%
  select(-system, -query_id, -hit) %>%
  group_by(document) %>%
  summarise(
    sdg = list(sort(unique(unlist(sdg)))),
    features = list(
      features |>
        unlist() |>
        strsplit(",") |>
        unlist() |>
        trimws() |>
        discard(~ .x %in% c("", "NA")) |>
        unique() |>
        sort()
    ),
    .groups = "drop"
  ) %>%
  mutate(document = as.integer(document))

sdg_summary_df_descriptive <-
  course_details_df %>%
  left_join(sdg_summary_df_descriptive, by = c("document_number" = "document"))

# Additional processing for block 2
sdg_summary_df_competencial <- sdg_analysis_df_results_competencial %>%
  select(-system, -query_id, -hit) %>%
  group_by(document) %>%
  summarise(
    sdg = list(sort(unique(unlist(sdg)))),
    features = list(
      features |>
        unlist() |>
        strsplit(",") |>
        unlist() |>
        trimws() |>
        discard(~ .x %in% c("", "NA")) |>
        unique() |>
        sort()
    ),
    .groups = "drop"
  ) %>%
  mutate(document = as.integer(document))

sdg_summary_df_competencial <-
  course_details_df %>%
  left_join(sdg_summary_df_competencial, by = c("document_number" = "document"))

# Additional processing for block 3
sdg_summary_df_bibliographical <- sdg_analysis_df_results_bibliographical %>%
  select(-system, -query_id, -hit) %>%
  group_by(document) %>%
  summarise(
    sdg = list(sort(unique(unlist(sdg)))),
    features = list(
      features |>
        unlist() |>
        strsplit(",") |>
        unlist() |>
        trimws() |>
        discard(~ .x %in% c("", "NA")) |>
        unique() |>
        sort()
    ),
    .groups = "drop"
  ) %>%
  mutate(document = as.integer(document))

sdg_summary_df_bibliographical <-
  course_details_df %>%
  left_join(sdg_summary_df_bibliographical, by = c("document_number" = "document"))

# Load the results of the combined analysis
sdg_analysis_df_results <- readRDS("./data/sdg_analysis_df_results.rds")

# Apply substitutions in the features for the combined analysis
sdg_analysis_df_results$features_fixed <- Reduce(function(x, i) {
  gsub(patterns[i], replacements[i], x, fixed = TRUE)
}, seq_along(patterns), init = sdg_analysis_df_results$features)

sdg_analysis_df_results <-
  sdg_analysis_df_results %>%
  select(-features) %>%
  rename(features = features_fixed)

# Additional processing for the combined analysis
sdg_summary_df <- sdg_analysis_df_results %>%
  select(-system, -query_id, -hit) %>%
  group_by(document) %>%
  summarise(
    sdg = list(sort(unique(unlist(sdg)))),
    features = list(
      features |>
        unlist() |>
        strsplit(",") |>
        unlist() |>
        trimws() |>
        discard(~ .x %in% c("", "NA")) |>
        unique() |>
        sort()
    ),
    .groups = "drop"
  ) %>%
  mutate(document = as.integer(document))

sdg_summary_df <-
  course_details_df %>%
  left_join(sdg_summary_df, by = c("document_number" = "document"))

# Clean up the workspace
rm("sdg_analysis_df_results","sdg_analysis_df_results_descriptive",
   "sdg_analysis_df_results_bibliographical","sdg_analysis_df_results_competencial",
   "sdg_analysis_df_descriptive","sdg_analysis_df_descriptive",
   "sdg_analysis_df_competencial","sdg_analysis_df_bibliographical")


# Read course_details_df
# course_details_df <- read_csv("./data/course_details_df.csv")

# sdg_analysis_df <- course_details_df %>%
#  mutate(data_combined = paste(course_name_en, description_en, contents_en,
#                               competences_learning_results_en, references_en,
#                               sep = ";"))
#
# sdg_analysis_df_results <- detect_sdg_systems(sdg_analysis_df$data_combined,
#                            system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))
# write.csv(sdg_analysis_df_results, "./sandbox/sdg_analysis_df_results.csv", row.names = FALSE)
#
# If CSV is too heavy, saving this one a RDS
# saveRDS(sdg_analysis_df_results, "./data/sdg_analysis_df_results.rds")

# sdg_analysis_df_results <- readRDS("C:/Users/Lluis Salvat/git/urv-sdgs-tracker/data/sdg_analysis_df_results.rds")
# sdg_analysis_df_results <- readRDS("./data/sdg_analysis_df_results.rds")


# Window for paste compound features ----

# sdg_analysis_df_results$features <- gsub("determinants, of, health", "determinants of health", sdg_analysis_df_results$features, fixed = TRUE)
# sdg_analysis_df_results$features <- gsub("quality, of, life", "quality of life", sdg_analysis_df_results$features, fixed = TRUE)
# sdg_analysis_df_results$features <- gsub("rule, of, law", "rule of law", sdg_analysis_df_results$features, fixed = TRUE)
# ...

# Script 2-sdgs-unique-expressions solves the step to get more accurate non-splitted features.

## Patterns and replacements
# patterns <- gsub(" ", ", ", unique_expressions$expression, fixed = TRUE)
# replacements <- unique_expressions$expression
# 
# # Do all substitutions in one step
# sdg_analysis_df_results$features_fixed <- Reduce(function(x, i) {
#   gsub(patterns[i], replacements[i], x, fixed = TRUE)
# }, seq_along(patterns), init = sdg_analysis_df_results$features)
# 
# sdg_analysis_df_results<-
#   sdg_analysis_df_results %>% 
#   select(-features) %>% 
#   rename(features=features_fixed)
# 
# saveRDS(sdg_analysis_df_results, "./data/sdg_analysis_df_results.rds")

# sdg_analysis_df_results <- readRDS("./data/sdg_analysis_df_results.rds")
# 
# sdg_summary_df <- sdg_analysis_df_results %>%
#   select(-system, -query_id, -hit) %>%
#   group_by(document) %>%
#   summarise(
#     sdg = list(sort(unique(unlist(sdg)))),
#     features = list(
#       features |>
#         unlist() |>
#         strsplit(",") |>
#         unlist() |>
#         trimws() |>
#         discard(~ .x %in% c("", "NA")) |>
#         unique() |>
#         sort()
#     ),
#     .groups = "drop"
#   ) %>%
#   mutate(document = as.integer(document))
# 
# sdg_summary_df <-
#   course_details_df %>%
#   left_join(sdg_summary_df, by=c("document_number"="document"))
# 
# rm("course_details_df","sdg_analysis_df_results")
