


library(text2sdg)

data(aurora_queries)
head(aurora_queries)



# Translations


course_description <- "This course focuses on sustainable energy solutions, climate change mitigation, and the role of renewable energy sources in reducing carbon emissions."

sdg_results <- detect_sdg(course_description)
