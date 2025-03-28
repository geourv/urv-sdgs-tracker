library(dplyr)
library(purrr)
library(tidyr)
library(jsonlite)

# Total d’assignatures per facultat (totes, amb o sense SDG)
total_courses_by_faculty <- sdg_summary_df %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "total_courses")

# Assignatures amb almenys un SDG
flat_df <- sdg_summary_df %>%
  select(faculty_school_name, course_name, sdg_ca) %>%
  filter(lengths(sdg_ca) > 0) %>%
  unnest(sdg_ca) %>%
  distinct(faculty_school_name, course_name, sdg_ca)

# Total d’assignatures amb SDG per facultat
courses_with_sdg <- flat_df %>%
  distinct(faculty_school_name, course_name) %>%
  count(faculty_school_name, name = "with_sdgs")

# Comptem SDG per facultat
sdg_faculty_summary <- flat_df %>%
  count(faculty_school_name, sdg_ca, name = "n") %>%
  left_join(courses_with_sdg, by = "faculty_school_name") %>%
  left_join(total_courses_by_faculty, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1),  # aquest sí suma 100%
    sdg_course_ratio = round(100 * with_sdgs[1] / total_courses[1], 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      total_courses = df$total_courses[1],
      courses_with_sdgs = df$with_sdgs[1],
      sdg_coverage_percent = df$sdg_course_ratio[1],
      sdgs = setNames(as.list(df$n), df$sdg_ca),
      percentages = setNames(as.list(df$percent), df$sdg_ca)
    )
  })

# Exportar JSON
write_json(sdg_faculty_summary, "C:/Users/Lluis Salvat/Desktop/web_test_1/faculties_sdg_data.json", pretty = TRUE, auto_unbox = TRUE)
