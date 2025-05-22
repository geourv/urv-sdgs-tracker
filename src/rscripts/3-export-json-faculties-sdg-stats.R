library(dplyr)
library(purrr)
library(tidyr)
library(jsonlite)

# Calculate the 4 required fields with validation
faculty_stats <- sdg_summary_df %>%
  group_by(faculty_school_name) %>%
  summarise(
    courses_per_faculty = n_distinct(course_name),
    sdg_courses_faculty = n_distinct(course_name[lengths(sdg) > 0]),
    not_sdg_courses_faculty = n_distinct(course_name[lengths(sdg) == 0]),
    
    # Explicit verification (only for checking, can be removed later)
    check = sdg_courses_faculty + not_sdg_courses_faculty == courses_per_faculty,
    
    sdg_ratio_faculty = round(100 * sdg_courses_faculty / courses_per_faculty, 1)
  ) %>%
  ungroup()

# Show if there are inconsistencies (for debugging)
if(any(!faculty_stats$check)) {
  warning("Inconsistency found! The sum does not match for some faculties:")
  print(faculty_stats %>% filter(!check))
}

# Remove the verification column (optional)
faculty_stats <- faculty_stats %>% select(-check)

# Processing for individual SDGs
flat_df <- sdg_summary_df %>%
  select(faculty_school_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, course_name, sdg)

# Building the final summary
sdg_faculty_summary <- flat_df %>%
  count(faculty_school_name, sdg, name = "n") %>%
  left_join(faculty_stats, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      courses_per_faculty = df$courses_per_faculty[1],
      sdg_courses_faculty = df$sdg_courses_faculty[1],
      not_sdg_courses_faculty = df$not_sdg_courses_faculty[1],
      sdg_ratio_faculty = df$sdg_ratio_faculty[1],
      sdgs = setNames(as.list(df$n), df$sdg),
      percentages = setNames(as.list(df$percent), df$sdg)
    )
  })

# Export JSON
write_json(sdg_faculty_summary, "docs/data/faculties_sdg_data.json", pretty = TRUE, auto_unbox = TRUE)

# Calculate the 4 required fields with validation for descriptive summary
faculty_stats_descriptive <- sdg_summary_df_descriptive %>%
  group_by(faculty_school_name) %>%
  summarise(
    courses_per_faculty = n_distinct(course_name),
    sdg_courses_faculty = n_distinct(course_name[lengths(sdg) > 0]),
    not_sdg_courses_faculty = n_distinct(course_name[lengths(sdg) == 0]),
    
    # Explicit verification (only for checking, can be removed later)
    check = sdg_courses_faculty + not_sdg_courses_faculty == courses_per_faculty,
    
    sdg_ratio_faculty = round(100 * sdg_courses_faculty / courses_per_faculty, 1)
  ) %>%
  ungroup()

# Show if there are inconsistencies (for debugging)
if(any(!faculty_stats_descriptive$check)) {
  warning("Inconsistency found! The sum does not match for some faculties:")
  print(faculty_stats_descriptive %>% filter(!check))
}

# Remove the verification column (optional)
faculty_stats_descriptive <- faculty_stats_descriptive %>% select(-check)

# Processing for individual SDGs for descriptive summary
flat_df_descriptive <- sdg_summary_df_descriptive %>%
  select(faculty_school_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, course_name, sdg)

# Building the final summary for descriptive summary
sdg_faculty_summary_descriptive <- flat_df_descriptive %>%
  count(faculty_school_name, sdg, name = "n") %>%
  left_join(faculty_stats_descriptive, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      courses_per_faculty = df$courses_per_faculty[1],
      sdg_courses_faculty = df$sdg_courses_faculty[1],
      not_sdg_courses_faculty = df$not_sdg_courses_faculty[1],
      sdg_ratio_faculty = df$sdg_ratio_faculty[1],
      sdgs = setNames(as.list(df$n), df$sdg),
      percentages = setNames(as.list(df$percent), df$sdg)
    )
  })

# Export JSON for descriptive summary
write_json(sdg_faculty_summary_descriptive, "docs/data/faculties_sdg_data_descriptive.json", pretty = TRUE, auto_unbox = TRUE)

# Calculate the 4 required fields with validation for competencial summary
faculty_stats_competencial <- sdg_summary_df_competencial %>%
  group_by(faculty_school_name) %>%
  summarise(
    courses_per_faculty = n_distinct(course_name),
    sdg_courses_faculty = n_distinct(course_name[lengths(sdg) > 0]),
    not_sdg_courses_faculty = n_distinct(course_name[lengths(sdg) == 0]),
    
    # Explicit verification (only for checking, can be removed later)
    check = sdg_courses_faculty + not_sdg_courses_faculty == courses_per_faculty,
    
    sdg_ratio_faculty = round(100 * sdg_courses_faculty / courses_per_faculty, 1)
  ) %>%
  ungroup()

# Show if there are inconsistencies (for debugging)
if(any(!faculty_stats_competencial$check)) {
  warning("Inconsistency found! The sum does not match for some faculties:")
  print(faculty_stats_competencial %>% filter(!check))
}

# Remove the verification column (optional)
faculty_stats_competencial <- faculty_stats_competencial %>% select(-check)

# Processing for individual SDGs for competencial summary
flat_df_competencial <- sdg_summary_df_competencial %>%
  select(faculty_school_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, course_name, sdg)

# Building the final summary for competencial summary
sdg_faculty_summary_competencial <- flat_df_competencial %>%
  count(faculty_school_name, sdg, name = "n") %>%
  left_join(faculty_stats_competencial, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      courses_per_faculty = df$courses_per_faculty[1],
      sdg_courses_faculty = df$sdg_courses_faculty[1],
      not_sdg_courses_faculty = df$not_sdg_courses_faculty[1],
      sdg_ratio_faculty = df$sdg_ratio_faculty[1],
      sdgs = setNames(as.list(df$n), df$sdg),
      percentages = setNames(as.list(df$percent), df$sdg)
    )
  })

# Export JSON for competencial summary
write_json(sdg_faculty_summary_competencial, "docs/data/faculties_sdg_data_competencial.json", pretty = TRUE, auto_unbox = TRUE)

# Calculate the 4 required fields with validation for bibliographical summary
faculty_stats_bibliographical <- sdg_summary_df_bibliographical %>%
  group_by(faculty_school_name) %>%
  summarise(
    courses_per_faculty = n_distinct(course_name),
    sdg_courses_faculty = n_distinct(course_name[lengths(sdg) > 0]),
    not_sdg_courses_faculty = n_distinct(course_name[lengths(sdg) == 0]),
    
    # Explicit verification (only for checking, can be removed later)
    check = sdg_courses_faculty + not_sdg_courses_faculty == courses_per_faculty,
    
    sdg_ratio_faculty = round(100 * sdg_courses_faculty / courses_per_faculty, 1)
  ) %>%
  ungroup()

# Show if there are inconsistencies (for debugging)
if(any(!faculty_stats_bibliographical$check)) {
  warning("Inconsistency found! The sum does not match for some faculties:")
  print(faculty_stats_bibliographical %>% filter(!check))
}

# Remove the verification column (optional)
faculty_stats_bibliographical <- faculty_stats_bibliographical %>% select(-check)

# Processing for individual SDGs for bibliographical summary
flat_df_bibliographical <- sdg_summary_df_bibliographical %>%
  select(faculty_school_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, course_name, sdg)

# Building the final summary for bibliographical summary
sdg_faculty_summary_bibliographical <- flat_df_bibliographical %>%
  count(faculty_school_name, sdg, name = "n") %>%
  left_join(faculty_stats_bibliographical, by = "faculty_school_name") %>%
  group_by(faculty_school_name) %>%
  mutate(
    percent = round(100 * n / sum(n), 1)
  ) %>%
  group_split() %>%
  map(function(df) {
    list(
      faculty = df$faculty_school_name[1],
      courses_per_faculty = df$courses_per_faculty[1],
      sdg_courses_faculty = df$sdg_courses_faculty[1],
      not_sdg_courses_faculty = df$not_sdg_courses_faculty[1],
      sdg_ratio_faculty = df$sdg_ratio_faculty[1],
      sdgs = setNames(as.list(df$n), df$sdg),
      percentages = setNames(as.list(df$percent), df$sdg)
    )
  })

# Export JSON for bibliographical summary
write_json(sdg_faculty_summary_bibliographical, "docs/data/faculties_sdg_data_bibliographical.json", pretty = TRUE, auto_unbox = TRUE)
