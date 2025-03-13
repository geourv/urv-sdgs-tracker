
# Load data if necessary
# source("./src/rscripts/0-data-loading.R")

# Translate the columns from Catalan to English
source("./src/R/translate_column.R")

# Translate columns into individual CSV files ----
translate_column(course_details_df, column = "course_name", source_lang = "ca", target_lang = "en", 
                 file_path = "./sandbox/course_name-en.csv", max_cores = 4,
                 context = "Aquest és el nom de l'assignatura:") # Give some context so short texts are better translated

translate_column(course_details_df, column = "description", source_lang = "ca", target_lang = "en", 
                 file_path = "./sandbox/description-en.csv", max_cores = 4)

translate_column(course_details_df, column = "contents", source_lang = "ca", target_lang = "en", 
                 file_path = "./sandbox/contents-en.csv", max_cores = 4)

translate_column(course_details_df, column = "competences_learning_results", source_lang = "ca", target_lang = "en", 
                 file_path = "./sandbox/competences_learning_results-en.csv", max_cores = 4)

translate_column(course_details_df, column = "references", source_lang = "ca", target_lang = "en", 
                 file_path = "./sandbox/references-en.csv", max_cores = 4)


# Prepare SDG analysis df ----
course_name_en <- read_csv("./data/translations/course_name-en.csv") %>% 
  select(translated_text) %>% 
  rename(course_name_en = translated_text)

description_en <- read_csv("./data/translations/description-en.csv") %>% 
  select(translated_text) %>% 
  rename(description_en = translated_text)

contents_en <- read_csv("./data/translations/contents-en.csv") %>% 
  select(translated_text) %>% 
  rename(contents_en = translated_text)

competences_learning_results_en <- read_csv("./data/translations/competences_learning_results-en.csv") %>% 
  select(translated_text) %>% 
  rename(competences_learning_results_en = translated_text)

references_en <- read_csv("./data/translations/references-en.csv") %>% 
  select(translated_text) %>% 
  rename(references_en = translated_text)

# Bind all translated columns to the original dataframe
sdg_analysis_df <- course_details_df %>%
  select(document_number) %>%
  cbind(course_name_en, description_en, contents_en, 
        competences_learning_results_en, references_en)


