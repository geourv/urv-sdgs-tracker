library(dplyr)
library(purrr)
library(tidyr)
library(jsonlite)

# Total courses per degree and faculty (all, with or without SDG)
total_courses_by_degree <- sdg_summary_df %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "courses_per_degree")

# Courses with at least one SDG
flat_df <- sdg_summary_df %>%
  select(faculty_school_name, degree_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, degree_name, course_name, sdg)

# Total courses with SDG per degree and faculty
courses_with_sdg <- flat_df %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "sdg_courses_degree")

# Count SDGs per degree and faculty
sdg_degree_summary <- flat_df %>%
  count(faculty_school_name, degree_name, sdg, name = "n") %>%
  left_join(courses_with_sdg, by = c("faculty_school_name", "degree_name")) %>%
  left_join(total_courses_by_degree, by = c("faculty_school_name", "degree_name")) %>%
  group_by(faculty_school_name, degree_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
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

# Export JSON
write_json(sdg_degree_summary, "./docs/data/degree_sdg_data.json", pretty = TRUE, auto_unbox = TRUE)

# Total courses per degree and faculty for descriptive summary (all, with or without SDG)
total_courses_by_degree_descriptive <- sdg_summary_df_descriptive %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "courses_per_degree")

# Courses with at least one SDG for descriptive summary
flat_df_descriptive <- sdg_summary_df_descriptive %>%
  select(faculty_school_name, degree_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, degree_name, course_name, sdg)

# Total courses with SDG per degree and faculty for descriptive summary
courses_with_sdg_descriptive <- flat_df_descriptive %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "sdg_courses_degree")

# Count SDGs per degree and faculty for descriptive summary
sdg_degree_summary_descriptive <- flat_df_descriptive %>%
  count(faculty_school_name, degree_name, sdg, name = "n") %>%
  left_join(courses_with_sdg_descriptive, by = c("faculty_school_name", "degree_name")) %>%
  left_join(total_courses_by_degree_descriptive, by = c("faculty_school_name", "degree_name")) %>%
  group_by(faculty_school_name, degree_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
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

# Export JSON for descriptive summary
write_json(sdg_degree_summary_descriptive, "./docs/data/degree_sdg_data_descriptive.json", pretty = TRUE, auto_unbox = TRUE)

# Total courses per degree and faculty for competencial summary (all, with or without SDG)
total_courses_by_degree_competencial <- sdg_summary_df_competencial %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "courses_per_degree")

# Courses with at least one SDG for competencial summary
flat_df_competencial <- sdg_summary_df_competencial %>%
  select(faculty_school_name, degree_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, degree_name, course_name, sdg)

# Total courses with SDG per degree and faculty for competencial summary
courses_with_sdg_competencial <- flat_df_competencial %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "sdg_courses_degree")

# Count SDGs per degree and faculty for competencial summary
sdg_degree_summary_competencial <- flat_df_competencial %>%
  count(faculty_school_name, degree_name, sdg, name = "n") %>%
  left_join(courses_with_sdg_competencial, by = c("faculty_school_name", "degree_name")) %>%
  left_join(total_courses_by_degree_competencial, by = c("faculty_school_name", "degree_name")) %>%
  group_by(faculty_school_name, degree_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
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

# Export JSON for competencial summary
write_json(sdg_degree_summary_competencial, "./docs/data/degree_sdg_data_competencial.json", pretty = TRUE, auto_unbox = TRUE)

# Total courses per degree and faculty for bibliographical summary (all, with or without SDG)
total_courses_by_degree_bibliographical <- sdg_summary_df_bibliographical %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "courses_per_degree")

# Courses with at least one SDG for bibliographical summary
flat_df_bibliographical <- sdg_summary_df_bibliographical %>%
  select(faculty_school_name, degree_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, degree_name, course_name, sdg)

# Total courses with SDG per degree and faculty for bibliographical summary
courses_with_sdg_bibliographical <- flat_df_bibliographical %>%
  distinct(faculty_school_name, degree_name, course_name) %>%
  count(faculty_school_name, degree_name, name = "sdg_courses_degree")

# Count SDGs per degree and faculty for bibliographical summary
sdg_degree_summary_bibliographical <- flat_df_bibliographical %>%
  count(faculty_school_name, degree_name, sdg, name = "n") %>%
  left_join(courses_with_sdg_bibliographical, by = c("faculty_school_name", "degree_name")) %>%
  left_join(total_courses_by_degree_bibliographical, by = c("faculty_school_name", "degree_name")) %>%
  group_by(faculty_school_name, degree_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
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

# Export JSON for bibliographical summary
write_json(sdg_degree_summary_bibliographical, "./docs/data/degree_sdg_data_bibliographical.json", pretty = TRUE, auto_unbox = TRUE)
