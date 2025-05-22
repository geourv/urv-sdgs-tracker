library(dplyr)
library(purrr)
library(tidyr)
library(jsonlite)

# Process and export the original summary
# Total courses per faculty (all, with or without SDG)
total_courses_by_faculty <- sdg_summary_df %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "total_courses")

# Courses with at least one SDG
flat_df <- sdg_summary_df %>%
  select(faculty_school_name, course_name, features) %>%
  filter(lengths(features) > 0) %>%
  unnest(features) %>%
  distinct(faculty_school_name, course_name, features)

# Total courses with SDG per faculty
courses_with_sdg <- flat_df %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "with_sdgs")

# Count SDGs per faculty
sdg_faculty_summary <- flat_df %>%
  count(faculty_school_name, features, name = "n") %>%
  left_join(courses_with_sdg, by = "faculty_school_name") %>%
  left_join(total_courses_by_faculty, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
    sdg_course_ratio = round(100 * with_sdgs[1] / total_courses[1], 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      total_courses = df$total_courses[1],
      courses_with_sdgs = df$with_sdgs[1],
      sdg_coverage_percent = df$sdg_course_ratio[1],
      sdgs = setNames(as.list(df$n), df$features),
      percentages = setNames(as.list(df$percent), df$features)
    )
  })

# Export JSON
write_json(sdg_faculty_summary, "./docs/data/faculties_features_data.json", pretty = TRUE, auto_unbox = TRUE)

# Process and export the descriptive summary
# Total courses per faculty (all, with or without SDG)
total_courses_by_faculty_descriptive <- sdg_summary_df_descriptive %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "total_courses")

# Courses with at least one SDG
flat_df_descriptive <- sdg_summary_df_descriptive %>%
  select(faculty_school_name, course_name, features) %>%
  filter(lengths(features) > 0) %>%
  unnest(features) %>%
  distinct(faculty_school_name, course_name, features)

# Total courses with SDG per faculty
courses_with_sdg_descriptive <- flat_df_descriptive %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "with_sdgs")

# Count SDGs per faculty
sdg_faculty_summary_descriptive <- flat_df_descriptive %>%
  count(faculty_school_name, features, name = "n") %>%
  left_join(courses_with_sdg_descriptive, by = "faculty_school_name") %>%
  left_join(total_courses_by_faculty_descriptive, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
    sdg_course_ratio = round(100 * with_sdgs[1] / total_courses[1], 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      total_courses = df$total_courses[1],
      courses_with_sdgs = df$with_sdgs[1],
      sdg_coverage_percent = df$sdg_course_ratio[1],
      sdgs = setNames(as.list(df$n), df$features),
      percentages = setNames(as.list(df$percent), df$features)
    )
  })

# Export JSON
write_json(sdg_faculty_summary_descriptive, "./docs/data/faculties_features_data_descriptive.json", pretty = TRUE, auto_unbox = TRUE)

# Process and export the competencial summary
# Total courses per faculty (all, with or without SDG)
total_courses_by_faculty_competencial <- sdg_summary_df_competencial %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "total_courses")

# Courses with at least one SDG
flat_df_competencial <- sdg_summary_df_competencial %>%
  select(faculty_school_name, course_name, features) %>%
  filter(lengths(features) > 0) %>%
  unnest(features) %>%
  distinct(faculty_school_name, course_name, features)

# Total courses with SDG per faculty
courses_with_sdg_competencial <- flat_df_competencial %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "with_sdgs")

# Count SDGs per faculty
sdg_faculty_summary_competencial <- flat_df_competencial %>%
  count(faculty_school_name, features, name = "n") %>%
  left_join(courses_with_sdg_competencial, by = "faculty_school_name") %>%
  left_join(total_courses_by_faculty_competencial, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
    sdg_course_ratio = round(100 * with_sdgs[1] / total_courses[1], 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      total_courses = df$total_courses[1],
      courses_with_sdgs = df$with_sdgs[1],
      sdg_coverage_percent = df$sdg_course_ratio[1],
      sdgs = setNames(as.list(df$n), df$features),
      percentages = setNames(as.list(df$percent), df$features)
    )
  })

# Export JSON
write_json(sdg_faculty_summary_competencial, "./docs/data/faculties_features_data_competencial.json", pretty = TRUE, auto_unbox = TRUE)

# Process and export the bibliographical summary
# Total courses per faculty (all, with or without SDG)
total_courses_by_faculty_bibliographical <- sdg_summary_df_bibliographical %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "total_courses")

# Courses with at least one SDG
flat_df_bibliographical <- sdg_summary_df_bibliographical %>%
  select(faculty_school_name, course_name, features) %>%
  filter(lengths(features) > 0) %>%
  unnest(features) %>%
  distinct(faculty_school_name, course_name, features)

# Total courses with SDG per faculty
courses_with_sdg_bibliographical <- flat_df_bibliographical %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "with_sdgs")

# Count SDGs per faculty
sdg_faculty_summary_bibliographical <- flat_df_bibliographical %>%
  count(faculty_school_name, features, name = "n") %>%
  left_join(courses_with_sdg_bibliographical, by = "faculty_school_name") %>%
  left_join(total_courses_by_faculty_bibliographical, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # This sums to 100%
    sdg_course_ratio = round(100 * with_sdgs[1] / total_courses[1], 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      total_courses = df$total_courses[1],
      courses_with_sdgs = df$with_sdgs[1],
      sdg_coverage_percent = df$sdg_course_ratio[1],
      sdgs = setNames(as.list(df$n), df$features),
      percentages = setNames(as.list(df$percent), df$features)
    )
  })

# Export JSON
write_json(sdg_faculty_summary_bibliographical, "./docs/data/faculties_features_data_bibliographical.json", pretty = TRUE, auto_unbox = TRUE)
