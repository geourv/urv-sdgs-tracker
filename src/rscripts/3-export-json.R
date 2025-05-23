library(dplyr)
library(purrr)
library(jsonlite)

# Función de limpieza de listas
clean_list <- function(lst) {
  lst[!sapply(lst, function(x) is.null(x) || identical(x, "") || (is.list(x) && length(x) == 0))]
}

# Función general para procesar los distintos dataframes
process_sdg_summary <- function(df, output_path) {
  df <- df %>%
    select(-competences_learning_results_en, -description_en, -contents_en, -references_en) %>%
    mutate(course_name = tolower(course_name))
  
  faculty_cols <- grep("^faculty_school_", names(df), value = TRUE)
  degree_cols  <- grep("^degree_", names(df), value = TRUE)
  course_cols  <- grep("^course_", names(df), value = TRUE)
  
  course_level_cols <- c(course_cols, setdiff(names(df), c(faculty_cols, degree_cols, course_cols)))
  
  faculty_list <- df %>%
    group_by(across(all_of(faculty_cols))) %>%
    group_split() %>%
    map(function(fac_df) {
      faculty_info <- fac_df[1, faculty_cols] %>% as.list()
      
      degrees <- fac_df %>%
        group_by(across(all_of(degree_cols))) %>%
        group_split() %>%
        map(function(degree_df) {
          degree_info <- degree_df[1, degree_cols] %>% as.list()
          
          has_sdg <- map_lgl(degree_df$sdg, function(x) {
            if (is.null(x)) return(FALSE)
            if (is.atomic(x) && length(x) == 1 && (is.na(x) || x == "")) return(FALSE)
            if (is.list(x) && length(x) == 0) return(FALSE)
            TRUE
          })
          
          courses_per_degree <- nrow(degree_df)
          sdg_courses_degree <- sum(has_sdg)
          not_sdg_courses_degree <- sum(!has_sdg)
          sdg_ratio_degree <- ifelse(courses_per_degree > 0, round(100 * sdg_courses_degree / courses_per_degree, 1), NA_real_)
          
          degree_info$courses_per_degree <- courses_per_degree
          degree_info$sdg_courses_degree <- sdg_courses_degree
          degree_info$not_sdg_courses_degree <- not_sdg_courses_degree
          degree_info$sdg_ratio_degree <- sdg_ratio_degree
          
          courses <- degree_df %>%
            group_by(across(all_of(course_cols))) %>%
            group_split() %>%
            map(function(course_df) {
              course_info <- course_df[1, course_level_cols] %>% as.list()
              
              # Normalización de sdg y features
              if (is.null(course_info$sdg)) course_info$sdg <- list()
              if (is.null(course_info$features)) course_info$features <- list()
              
              course_info <- clean_list(course_info)
              course_info
            })
          
          degree_info$courses <- courses
          degree_info <- clean_list(degree_info)
          degree_info
        })
      
      faculty_info$degrees <- degrees
      faculty_info <- clean_list(faculty_info)
      faculty_info
    })
  
  write_json(faculty_list, output_path, pretty = TRUE, auto_unbox = TRUE)
}


# Procesar y exportar los diferentes resúmenes
process_sdg_summary(sdg_summary_df, "./docs/data/urv-sdgs.json")
process_sdg_summary(sdg_summary_df_descriptive, "./docs/data/urv-sdgs_descriptive.json")
process_sdg_summary(sdg_summary_df_competencial, "./docs/data/urv-sdgs_competencial.json")
process_sdg_summary(sdg_summary_df_bibliographical, "./docs/data/urv-sdgs_bibliographical.json")
