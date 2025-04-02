library(dplyr)
library(purrr)
library(jsonlite)

# 1. Preprocessament del dataframe
df <- sdg_summary_df %>%
  select(-competences_learning_results_en, -description_en, -contents_en, -references_en) %>%
  mutate(
    course_name = tolower(course_name)
  )

# 2. Identificació de columnes per nivell jeràrquic
faculty_cols <- grep("^faculty_school_", names(df), value = TRUE)
degree_cols  <- grep("^degree_", names(df), value = TRUE)
course_cols  <- grep("^course_", names(df), value = TRUE)

# Columnes que volem conservar a nivell de curs
course_level_cols <- c(course_cols, setdiff(names(df), c(faculty_cols, degree_cols, course_cols)))

# 3. Construcció de la jerarquia facultat → grau → assignatures
faculty_list <- df %>%
  group_by(across(all_of(faculty_cols))) %>%
  group_split() %>%
  map(function(fac_df) {

    # Atributs de la facultat
    faculty_info <- fac_df[1, faculty_cols] %>% as.list()

    # Llista de graus dins la facultat
    degrees <- fac_df %>%
      group_by(across(all_of(degree_cols))) %>%
      group_split() %>%
      map(function(degree_df) {

        # Atributs del grau
        degree_info <- degree_df[1, degree_cols] %>% as.list()

        # Llista d'assignatures amb tota la informació
        courses <- degree_df %>%
          group_by(across(all_of(course_cols))) %>%
          group_split() %>%
          map(function(course_df) {
            course_info <- course_df[1, course_level_cols] %>% as.list()

            # Aplanar sdg i features si són llistes o tenen duplicats
            if (!is.null(course_info$sdg)) {
              course_info$sdg <- course_info$sdg
            }
            if (!is.null(course_info$features)) {
              course_info$features <- course_info$features
            }

            course_info
          })

        degree_info$courses <- courses
        degree_info
      })

    faculty_info$degrees <- degrees
    faculty_info
  })


# 4. Exportar a JSON
json_output <- toJSON(faculty_list, pretty = TRUE, auto_unbox = TRUE)
write(json_output, "./docs/data/urv-sdgs.json")
