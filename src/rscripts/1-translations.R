
# Set working directory
setwd("~/git/urv-sdgs-tracker")
# setwd("C:/Users/Lluis Salvat/git/urv-sdgs-tracker")

# Load data if necessary
# source("./src/rscripts/0-data-loading.R")

# Load readr and tidyverse library if necessary
library(readr)
library(tidyverse)

# Translate the columns from Catalan to English
source("./src/R/translate_column_services.R")

# TODO: Filter those rows with lower confidence and retry.

# Translate columns into individual CSV files: Using Apertium ----
translate_column(course_details_df, column = "course_name", source_lang = "ca", target_lang = "en",
                 file_path = "./sandbox/course_name-en-apertium.csv", max_cores = 8,
                 service = "apertium")
translate_column(course_details_df, column = "description", source_lang = "ca", target_lang = "en",
                 file_path = "./sandbox/description-en-apertium.csv", max_cores = 8,
                 service = "apertium")
translate_column(course_details_df, column = "contents", source_lang = "ca", target_lang = "en",
                 file_path = "./sandbox/contents-en-apertium.csv", max_cores = 8,
                 service = "apertium")

# With individual rows!!!!
translate_column(course_competences_learning_results, column = "competences_learning_results", source_lang = "ca", target_lang = "en",
                 file_path = "./sandbox/competences_learning_results-en-apertium.csv", max_cores = 8,
                 service = "apertium")
translate_column(course_bibliography, column = "references", source_lang = "auto", target_lang = "en",
                 file_path = "./sandbox/references-en-apertium.csv", max_cores = 8,
                 service = "apertium")


# Translate columns into individual CSV files: Using Libretranslate ----
translate_column(course_details_df, column = "course_name", source_lang = "ca", target_lang = "en",
                 file_path = "./sandbox/course_name-en.csv", max_cores = 4,
                 context = "Aquest és el nom de l'assignatura:",
                 service = "libretranslate")
translate_column(course_details_df, column = "description", source_lang = "ca", target_lang = "en",
                 file_path = "./sandbox/description-en.csv", max_cores = 4,
                 service = "libretranslate")
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
        competences_learning_results_en, references_en)%>%
  mutate(across(ends_with("_en"), ~ na_if(., "Error in translation request")))

# Delete environment df
rm(contents_en,course_name_en,competences_learning_results_en,description_en,references_en)

