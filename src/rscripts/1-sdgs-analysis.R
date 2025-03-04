library(text2sdg)

test <- detect_sdg_systems(course_details_df$degree_name,
                   system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))