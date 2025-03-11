library(text2sdg)


# Detect SDGs----
course_details_df_sdgs <- detect_sdg_systems(course_details_df$data_en,
                              system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))


#Join SDGs data to course details dataframe----
course_details_df_sdgs <- merge(course_details_df, course_details_df_sdgs, 
                                by.x = "document_number", by.y= "document", all = TRUE)



# Aggregate SDGs column data per course----
#course_details_df_sdgs_agg <- 
# aggregate(sdg ~ course_url,data = course_details_df_sdgs,paste, collapse = ";")

# Join aggregate SDGs column data per course into course details dataframe----
#course_details_df_sdgs_agg <- 
# merge(course_details_df, course_details_df_sdgs_agg,"course_url", all = TRUE)

#Write CSVs
#write.csv(course_details_df_sdgs, "data/course_details_df_sdgs.csv", row.names = FALSE)
#write.csv(course_details_df_sdgs_agg, "data/course_details_df_sdgs_agg.csv", row.names = FALSE)
