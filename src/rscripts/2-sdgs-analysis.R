########### SDGs analysis for all data combined----
library(text2sdg)
library(corpustools)
library(readr)
library(dplyr)

# TODO: TRY TO ANALYSE SEPARATED COLUMNS. FOR NOW THE COMBINED ANALYSIS IS ENOUGH

# Read course_details_df
course_details_df <- read_csv("./data/course_details_df.csv")

# Mapeo completo de los 17 ODS en diferentes idiomas
sdg_mapping <- tibble(
  sdg_code = paste0("SDG-", sprintf("%02d", 1:17)),
  sdg_en = c(
    "No poverty", "Zero hunger", "Good health and well-being", "Quality education",
    "Gender equality", "Clean water and sanitation", "Affordable and clean energy",
    "Decent work and economic growth", "Industry, innovation and infrastructure",
    "Reduced inequalities", "Sustainable cities and communities", "Responsible consumption and production",
    "Climate action", "Life below water", "Life on land", "Peace, justice and strong institutions",
    "Partnerships for the goals"
  ),
  sdg_ca = c(
    "Fi de la pobresa", "Fam zero", "Salut i benestar", "Educació de qualitat",
    "Igualtat de gènere", "Aigua neta i sanejament", "Energia assequible i neta",
    "Treball digne i creixement econòmic", "Indústria, innovació i infraestructura",
    "Reducció de les desigualtats", "Comunitats i ciutats sostenibles", "Producció i consum responsables",
    "Acció pel clima", "Vida submarina", "Vida d'ecosistemes terrestres", "Pau, justícia i institucions sòlides",
    "Aliances per a assolir els objectius"
  ),
  sdg_es = c(
    "Fin de la pobreza", "Hambre cero", "Salud y bienestar", "Educación de calidad",
    "Igualdad de género", "Agua limpia y saneamiento", "Energía asequible y no contaminante",
    "Trabajo decente y crecimiento económico", "Industria, innovación e infraestructura",
    "Reducción de las desigualdades", "Ciudades y comunidades sostenibles", "Producción y consumo responsables",
    "Acción por el clima", "Vida submarina", "Vida de ecosistemas terrestres", "Paz, justicia e instituciones sólidas",
    "Alianzas para lograr los objetivos"
  )
)


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
sdg_analysis_df_results <- readRDS("./data/sdg_analysis_df_results.rds")


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

# Create the SDG lookup tables 
sdg_summary_df <- sdg_summary_df %>%
  rowwise() %>%
  mutate(
    sdg_en = if (length(sdg) > 0) list(paste(sdg, sdg_mapping$sdg_en[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
    sdg_ca = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_ca[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
    sdg_es = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_es[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA)
  ) %>%
  ungroup()


sdg_summary_df <-
  course_details_df %>%
  left_join(sdg_summary_df, by=c("document_number"="document"))

rm("course_details_df","sdg_analysis_df_results")

# ########### SDGs analysis for course_name_en----
# sdg_analysis_df <- course_details_df
# 
# sdg_analysis_df_course_name_results <- detect_sdg_systems(sdg_analysis_df$course_name_en,
#                                               system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))
# #write.csv(sdg_analysis_df_course_name_results, "./sandbox/sdg_analysis_df_course_name_results.csv", row.names = FALSE)
# #
# # If CSV is too heavy, saving this one a RDS
# # saveRDS(sdg_analysis_df_course_name_results, "./data/sdg_analysis_df_course_name_results.rds")
# # sdg_analysis_df_course_name_results <- readRDS("./data/sdg_analysis_df_course_name_results.rds")
# 
# sdg_analysis_course_name_df <- sdg_analysis_df_course_name_results %>%
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
# # Create the SDG lookup tables 
# sdg_analysis_course_name_df <- sdg_analysis_course_name_df %>%
#   rowwise() %>%
#   mutate(
#     sdg_en = if (length(sdg) > 0) list(paste(sdg, sdg_mapping$sdg_en[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_ca = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_ca[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_es = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_es[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA)
#   ) %>%
#   ungroup()
# 
# 
# sdg_analysis_course_name_df <-
#   course_details_df %>%
#   left_join(sdg_analysis_course_name_df, by=c("document_number"="document"))
# 
# ########### SDGs analysis for description_en----
# sdg_analysis_df <- course_details_df 
# 
# sdg_analysis_df_description_results <- detect_sdg_systems(sdg_analysis_df$description_en,
#                                                           system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))
# #write.csv(sdg_analysis_df_description_results, "./sandbox/sdg_analysis_df_description_results.csv", row.names = FALSE)
# #
# # If CSV is too heavy, saving this one a RDS
# # saveRDS(sdg_analysis_df_description_results, "./data/sdg_analysis_df_description_results.rds")
# # sdg_analysis_df_description_results <- readRDS("./data/sdg_analysis_df_description_results.rds")
# 
# sdg_analysis_description_df <- sdg_analysis_df_description_results %>%
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
# # Create the SDG lookup tables 
# sdg_analysis_description_df <- sdg_analysis_description_df %>%
#   rowwise() %>%
#   mutate(
#     sdg_en = if (length(sdg) > 0) list(paste(sdg, sdg_mapping$sdg_en[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_ca = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_ca[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_es = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_es[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA)
#   ) %>%
#   ungroup()
# 
# 
# sdg_analysis_description_df <-
#   course_details_df %>%
#   left_join(sdg_analysis_description_df, by=c("document_number"="document"))
# ########### SDGs analysis for contents_en----
# sdg_analysis_df <- course_details_df 
# 
# sdg_analysis_df_contents_results <- detect_sdg_systems(sdg_analysis_df$contents_en,
#                                                           system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))
# #write.csv(sdg_analysis_df_contents_results, "./sandbox/sdg_analysis_df_contents_results.csv", row.names = FALSE)
# #
# # If CSV is too heavy, saving this one a RDS
# # saveRDS(sdg_analysis_df_contents_results, "./data/sdg_analysis_df_contents_results.rds")
# # sdg_analysis_df_contents_results <- readRDS("./data/sdg_analysis_df_contents_results.rds")
# 
# sdg_analysis_contents_df <- sdg_analysis_df_contents_results %>%
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
# # Create the SDG lookup tables 
# sdg_analysis_contents_df <- sdg_analysis_contents_df %>%
#   rowwise() %>%
#   mutate(
#     sdg_en = if (length(sdg) > 0) list(paste(sdg, sdg_mapping$sdg_en[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_ca = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_ca[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_es = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_es[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA)
#   ) %>%
#   ungroup()
# 
# 
# sdg_analysis_contents_df <-
#   course_details_df %>%
#   left_join(sdg_analysis_contents_df, by=c("document_number"="document"))
# ########### SDGs analysis for competences_learning_results_en----
# sdg_analysis_df <- course_details_df 
# 
# sdg_analysis_df_competences_learning_results <- detect_sdg_systems(sdg_analysis_df$competences_learning_results_en,
#                                                        system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))
# #write.csv(sdg_analysis_df_competences_learning_results, "./sandbox/sdg_analysis_df_competences_learning_results.csv", row.names = FALSE)
# #
# # If CSV is too heavy, saving this one a RDS
# # saveRDS(sdg_analysis_df_competences_learning_results, "./data/sdg_analysis_df_competences_learning_results.rds")
# # sdg_analysis_df_competences_learning_results <- readRDS("./data/sdg_analysis_df_competences_learning_results.rds")
# 
# sdg_analysis_competences_learning_df <- sdg_analysis_df_competences_learning_results %>%
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
# # Create the SDG lookup tables 
# sdg_analysis_competences_learning_df <- sdg_analysis_competences_learning_df %>%
#   rowwise() %>%
#   mutate(
#     sdg_en = if (length(sdg) > 0) list(paste(sdg, sdg_mapping$sdg_en[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_ca = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_ca[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_es = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_es[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA)
#   ) %>%
#   ungroup()
# 
# 
# sdg_analysis_competences_learning_df <-
#   course_details_df %>%
#   left_join(sdg_analysis_competences_learning_df, by=c("document_number"="document"))
# ########### SDGs analysis for references_en----
# sdg_analysis_df <- course_details_df 
# 
# sdg_analysis_df_references_results <- detect_sdg_systems(sdg_analysis_df$references_en,
#                                                        system = c("Aurora", "Elsevier", "Auckland", "SIRIS", "SDSN", "SDGO"))
# #write.csv(sdg_analysis_df_references_results, "./sandbox/sdg_analysis_df_references_results.csv", row.names = FALSE)
# #
# # If CSV is too heavy, saving this one a RDS
# # saveRDS(sdg_analysis_df_references_results, "./data/sdg_analysis_df_references_results.rds")
# # sdg_analysis_df_references_results <- readRDS("./data/sdg_analysis_df_references_results.rds")
# 
# sdg_analysis_references_df <- sdg_analysis_df_references_results %>%
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
# # Create the SDG lookup tables 
# sdg_analysis_references_df <- sdg_analysis_references_df %>%
#   rowwise() %>%
#   mutate(
#     sdg_en = if (length(sdg) > 0) list(paste(sdg, sdg_mapping$sdg_en[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_ca = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_ca[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA),
#     sdg_es = if (length(sdg) > 0) list(paste(sub("SDG", "ODS", sdg), sdg_mapping$sdg_es[match(sdg, sdg_mapping$sdg_code)], sep = ": ")) else list(NA)
#   ) %>%
#   ungroup()
# 
# 
# sdg_analysis_references_df <-
#   course_details_df %>%
#   left_join(sdg_analysis_references_df, by=c("document_number"="document"))