library(dplyr)
library(purrr)
library(tidyr)
library(jsonlite)

# Total de asignaturas por grado y facultad (todas, con o sin SDG)
total_courses_by_degree <- sdg_summary_df %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "courses_per_degree")

# Asignaturas con al menos un SDG
flat_df <- sdg_summary_df %>%
  select(faculty_school_name, degree_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, degree_name, course_name, sdg)

# Total de asignaturas con SDG por grado y facultad
courses_with_sdg <- flat_df %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "sdg_courses_degree")

# Contamos SDG por grado y facultad
sdg_degree_summary <- flat_df %>%
  count(faculty_school_name, degree_name, sdg, name = "n") %>%
  left_join(courses_with_sdg, by = c("faculty_school_name", "degree_name")) %>%
  left_join(total_courses_by_degree, by = c("faculty_school_name", "degree_name")) %>%
  group_by(faculty_school_name, degree_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # este sí suma 100%
    sdg_ratio_degree = round(100 * sdg_courses_degree[1] / courses_per_degree[1], 1),
    not_sdg_courses_degree = courses_per_degree[1] - sdg_courses_degree[1]
  ) %>%
  ungroup() %>%
  group_split(faculty_school_name, degree_name) %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      degree = df$degree_name[1],
      courses_per_degree = df$courses_per_degree[1],
      sdg_courses_degree = df$sdg_courses_degree[1],
      not_sdg_courses_degree = df$not_sdg_courses_degree[1],
      sdg_ratio_degree = df$sdg_ratio_degree[1],
      sdgs = setNames(as.list(df$n), df$sdg),
      percentages = setNames(as.list(df$percent), df$sdg)
    )
  }) %>%
  split(., map_chr(., "faculty")) %>%
  map(function(degrees) {
    list(
      faculty = degrees[[1]]$faculty,
      degrees = degrees
    )
  }) %>%
  unname()

# Exportar JSON
write_json(sdg_degree_summary, "./docs/data/degree_sdg_data.json", pretty = TRUE, auto_unbox = TRUE)