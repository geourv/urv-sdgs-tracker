
# library(text2sdg)
# library(corpustools)
library(readr)
library(dplyr)

# TODO: TRY TO ANALYSE SEPARATED COLUMNS. FOR NOW THE COMBINED ANALYSIS IS ENOUGH

# Combined analysis single combined column for the analysis ----

# Read course_details_df
course_details_df <- read_csv("./data/course_details_df.csv")

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
sdg_analysis_df_results <- readRDS("./data/sdg_analysis_df_results.rds")

sdg_summary_df <- sdg_analysis_df_results %>%
  select(-system, -query_id, -hit) %>%
  group_by(document) %>%
  summarise(
    sdg = list(sdg),
    features = list(features),
    .groups = "drop"
  ) %>%
  mutate(document=as.integer(document))

sdg_summary_df <-
  course_details_df %>%
  left_join(sdg_summary_df, by=c("document_number"="document"))

rm("course_details_df","sdg_summary_df")
