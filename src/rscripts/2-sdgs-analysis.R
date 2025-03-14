
library(text2sdg)
library(corpustools)
library(pbapply)

# Read course_details_df
course_details_df <- read_csv("./data/course_details_df.csv")

# Create a new dataframe with a single combined column for the analysis----

sdg_analysis_df <- sdg_analysis_df %>%
  mutate(data_combined = paste(course_name_en, description_en, contents_en, 
                               competences_learning_results_en, references_en, 
                               sep = ";"))
# Detect SDGs----

sdg_analysis_df_results <- detect_sdg_systems(sdg_analysis_df$data_combined, 
                            system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))


test <- detect_sdg_systems(sdg_analysis_df$data_combined[1:10], 
                                              system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))


# Concatenate the 'sdg', 'system', 'query_id', 'features', and 'hit' columns by 'document' using a semicolon separator
sdg_analysis_df_results_agg <- aggregate(cbind(sdg, system, query_id, features, hit) ~ document, 
                             data = sdg_analysis_df_results, 
                             FUN = function(x) paste(x, collapse = ";"))

#Join SDGs data to course details dataframe----

course_details_df_sdgs <- merge(course_details_df, sdg_analysis_df_results_agg, 
                                by.x = "document_number", by.y= "document", all = TRUE)

#Write CSVs
write.csv(course_details_df_sdgs, "data/course_details_df_sdgs.csv", row.names = FALSE)
write.csv(sdg_analysis_df_results_agg, "data/sdg_analysis_df_results_agg.csv", row.names = FALSE)
