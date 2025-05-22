library(dplyr)
library(purrr)
library(jsonlite)

# Process and export the original summary
# 1. Preprocessing of the dataframe
df <- sdg_summary_df %>%
  select(-competences_learning_results_en, -description_en, -contents_en, -references_en) %>%
  mutate(
    course_name = tolower(course_name)
  )

# 2. Identification of columns by hierarchical level
faculty_cols <- grep("^faculty_school_", names(df), value = TRUE)
degree_cols  <- grep("^degree_", names(df), value = TRUE)
course_cols  <- grep("^course_", names(df), value = TRUE)

# Columns to keep at the course level
course_level_cols <- c(course_cols, setdiff(names(df), c(faculty_cols, degree_cols, course_cols)))

# 3. Construction of the hierarchy: faculty → degree → courses
faculty_list <- df %>%
  group_by(across(all_of(faculty_cols))) %>%
  group_split() %>%
  map(function(fac_df) {
    
    # Faculty attributes
    faculty_info <- fac_df[1, faculty_cols] %>% as.list()
    
    # List of degrees within the faculty
    degrees <- fac_df %>%
      group_by(across(all_of(degree_cols))) %>%
      group_split() %>%
      map(function(degree_df) {
        
        # Degree attributes
        degree_info <- degree_df[1, degree_cols] %>% as.list()
        
        # Robust check for the presence of SDGs
        has_sdg <- map_lgl(degree_df$sdg, function(x) {
          if (is.null(x)) return(FALSE)
          if (is.atomic(x) && length(x) == 1 && (is.na(x) || x == "")) return(FALSE)
          if (is.list(x) && length(x) == 0) return(FALSE)
          TRUE
        })
        
        # Calculation of automatic values
        courses_per_degree <- nrow(degree_df)
        sdg_courses_degree <- sum(has_sdg)
        not_sdg_courses_degree <- sum(!has_sdg)
        sdg_ratio_degree <- ifelse(courses_per_degree > 0, round(100 * sdg_courses_degree / courses_per_degree, 1), NA_real_)
        
        # Assign values to the degree
        degree_info$courses_per_degree <- courses_per_degree
        degree_info$sdg_courses_degree <- sdg_courses_degree
        degree_info$not_sdg_courses_degree <- not_sdg_courses_degree
        degree_info$sdg_ratio_degree <- sdg_ratio_degree
        
        # List of courses with all information
        courses <- degree_df %>%
          group_by(across(all_of(course_cols))) %>%
          group_split() %>%
          map(function(course_df) {
            course_info <- course_df[1, course_level_cols] %>% as.list()
            
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

# 4. Export to JSON
json_output <- toJSON(faculty_list, pretty = TRUE, auto_unbox = TRUE)
write(json_output, "./docs/data/urv-sdgs.json")

# Process and export the descriptive summary
# 1. Preprocessing of the dataframe
df_descriptive <- sdg_summary_df_descriptive %>%
  select(-competences_learning_results_en, -description_en, -contents_en, -references_en) %>%
  mutate(
    course_name = tolower(course_name)
  )

# 2. Identification of columns by hierarchical level
faculty_cols_descriptive <- grep("^faculty_school_", names(df_descriptive), value = TRUE)
degree_cols_descriptive  <- grep("^degree_", names(df_descriptive), value = TRUE)
course_cols_descriptive  <- grep("^course_", names(df_descriptive), value = TRUE)

# Columns to keep at the course level
course_level_cols_descriptive <- c(course_cols_descriptive, setdiff(names(df_descriptive), c(faculty_cols_descriptive, degree_cols_descriptive, course_cols_descriptive)))

# 3. Construction of the hierarchy: faculty → degree → courses
faculty_list_descriptive <- df_descriptive %>%
  group_by(across(all_of(faculty_cols_descriptive))) %>%
  group_split() %>%
  map(function(fac_df) {
    
    # Faculty attributes
    faculty_info <- fac_df[1, faculty_cols_descriptive] %>% as.list()
    
    # List of degrees within the faculty
    degrees <- fac_df %>%
      group_by(across(all_of(degree_cols_descriptive))) %>%
      group_split() %>%
      map(function(degree_df) {
        
        # Degree attributes
        degree_info <- degree_df[1, degree_cols_descriptive] %>% as.list()
        
        # Robust check for the presence of SDGs
        has_sdg <- map_lgl(degree_df$sdg, function(x) {
          if (is.null(x)) return(FALSE)
          if (is.atomic(x) && length(x) == 1 && (is.na(x) || x == "")) return(FALSE)
          if (is.list(x) && length(x) == 0) return(FALSE)
          TRUE
        })
        
        # Calculation of automatic values
        courses_per_degree <- nrow(degree_df)
        sdg_courses_degree <- sum(has_sdg)
        not_sdg_courses_degree <- sum(!has_sdg)
        sdg_ratio_degree <- ifelse(courses_per_degree > 0, round(100 * sdg_courses_degree / courses_per_degree, 1), NA_real_)
        
        # Assign values to the degree
        degree_info$courses_per_degree <- courses_per_degree
        degree_info$sdg_courses_degree <- sdg_courses_degree
        degree_info$not_sdg_courses_degree <- not_sdg_courses_degree
        degree_info$sdg_ratio_degree <- sdg_ratio_degree
        
        # List of courses with all information
        courses <- degree_df %>%
          group_by(across(all_of(course_cols_descriptive))) %>%
          group_split() %>%
          map(function(course_df) {
            course_info <- course_df[1, course_level_cols_descriptive] %>% as.list()
            
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

# 4. Export to JSON
json_output_descriptive <- toJSON(faculty_list_descriptive, pretty = TRUE, auto_unbox = TRUE)
write(json_output_descriptive, "./docs/data/urv-sdgs_descriptive.json")

# Process and export the competencial summary
# 1. Preprocessing of the dataframe
df_competencial <- sdg_summary_df_competencial %>%
  select(-competences_learning_results_en, -description_en, -contents_en, -references_en) %>%
  mutate(
    course_name = tolower(course_name)
  )

# 2. Identification of columns by hierarchical level
faculty_cols_competencial <- grep("^faculty_school_", names(df_competencial), value = TRUE)
degree_cols_competencial  <- grep("^degree_", names(df_competencial), value = TRUE)
course_cols_competencial  <- grep("^course_", names(df_competencial), value = TRUE)

# Columns to keep at the course level
course_level_cols_competencial <- c(course_cols_competencial, setdiff(names(df_competencial), c(faculty_cols_competencial, degree_cols_competencial, course_cols_competencial)))

# 3. Construction of the hierarchy: faculty → degree → courses
faculty_list_competencial <- df_competencial %>%
  group_by(across(all_of(faculty_cols_competencial))) %>%
  group_split() %>%
  map(function(fac_df) {
    
    # Faculty attributes
    faculty_info <- fac_df[1, faculty_cols_competencial] %>% as.list()
    
    # List of degrees within the faculty
    degrees <- fac_df %>%
      group_by(across(all_of(degree_cols_competencial))) %>%
      group_split() %>%
      map(function(degree_df) {
        
        # Degree attributes
        degree_info <- degree_df[1, degree_cols_competencial] %>% as.list()
        
        # Robust check for the presence of SDGs
        has_sdg <- map_lgl(degree_df$sdg, function(x) {
          if (is.null(x)) return(FALSE)
          if (is.atomic(x) && length(x) == 1 && (is.na(x) || x == "")) return(FALSE)
          if (is.list(x) && length(x) == 0) return(FALSE)
          TRUE
        })
        
        # Calculation of automatic values
        courses_per_degree <- nrow(degree_df)
        sdg_courses_degree <- sum(has_sdg)
        not_sdg_courses_degree <- sum(!has_sdg)
        sdg_ratio_degree <- ifelse(courses_per_degree > 0, round(100 * sdg_courses_degree / courses_per_degree, 1), NA_real_)
        
        # Assign values to the degree
        degree_info$courses_per_degree <- courses_per_degree
        degree_info$sdg_courses_degree <- sdg_courses_degree
        degree_info$not_sdg_courses_degree <- not_sdg_courses_degree
        degree_info$sdg_ratio_degree <- sdg_ratio_degree
        
        # List of courses with all information
        courses <- degree_df %>%
          group_by(across(all_of(course_cols_competencial))) %>%
          group_split() %>%
          map(function(course_df) {
            course_info <- course_df[1, course_level_cols_competencial] %>% as.list()
            
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

# 4. Export to JSON
json_output_competencial <- toJSON(faculty_list_competencial, pretty = TRUE, auto_unbox = TRUE)
write(json_output_competencial, "./docs/data/urv-sdgs_competencial.json")

# Process and export the bibliographical summary
# 1. Preprocessing of the dataframe
df_bibliographical <- sdg_summary_df_bibliographical %>%
  select(-competences_learning_results_en, -description_en, -contents_en, -references_en) %>%
  mutate(
    course_name = tolower(course_name)
  )

# 2. Identification of columns by hierarchical level
faculty_cols_bibliographical <- grep("^faculty_school_", names(df_bibliographical), value = TRUE)
degree_cols_bibliographical  <- grep("^degree_", names(df_bibliographical), value = TRUE)
course_cols_bibliographical  <- grep("^course_", names(df_bibliographical), value = TRUE)

# Columns to keep at the course level
course_level_cols_bibliographical <- c(course_cols_bibliographical, setdiff(names(df_bibliographical), c(faculty_cols_bibliographical, degree_cols_bibliographical, course_cols_bibliographical)))

# 3. Construction of the hierarchy: faculty → degree → courses
faculty_list_bibliographical <- df_bibliographical %>%
  group_by(across(all_of(faculty_cols_bibliographical))) %>%
  group_split() %>%
  map(function(fac_df) {
    
    # Faculty attributes
    faculty_info <- fac_df[1, faculty_cols_bibliographical] %>% as.list()
    
    # List of degrees within the faculty
    degrees <- fac_df %>%
      group_by(across(all_of(degree_cols_bibliographical))) %>%
      group_split() %>%
      map(function(degree_df) {
        
        # Degree attributes
        degree_info <- degree_df[1, degree_cols_bibliographical] %>% as.list()
        
        # Robust check for the presence of SDGs
        has_sdg <- map_lgl(degree_df$sdg, function(x) {
          if (is.null(x)) return(FALSE)
          if (is.atomic(x) && length(x) == 1 && (is.na(x) || x == "")) return(FALSE)
          if (is.list(x) && length(x) == 0) return(FALSE)
          TRUE
        })
        
        # Calculation of automatic values
        courses_per_degree <- nrow(degree_df)
        sdg_courses_degree <- sum(has_sdg)
        not_sdg_courses_degree <- sum(!has_sdg)
        sdg_ratio_degree <- ifelse(courses_per_degree > 0, round(100 * sdg_courses_degree / courses_per_degree, 1), NA_real_)
        
        # Assign values to the degree
        degree_info$courses_per_degree <- courses_per_degree
        degree_info$sdg_courses_degree <- sdg_courses_degree
        degree_info$not_sdg_courses_degree <- not_sdg_courses_degree
        degree_info$sdg_ratio_degree <- sdg_ratio_degree
        
        # List of courses with all information
        courses <- degree_df %>%
          group_by(across(all_of(course_cols_bibliographical))) %>%
          group_split() %>%
          map(function(course_df) {
            course_info <- course_df[1, course_level_cols_bibliographical] %>% as.list()
            
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

# 4. Export to JSON
json_output_bibliographical <- toJSON(faculty_list_bibliographical, pretty = TRUE, auto_unbox = TRUE)
write(json_output_bibliographical, "./docs/data/urv-sdgs_bibliographical.json")
