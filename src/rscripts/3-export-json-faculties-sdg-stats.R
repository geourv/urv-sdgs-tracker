library(dplyr)
library(purrr)
library(tidyr)
library(jsonlite)

# Calculamos los 4 campos requeridos con validación
faculty_stats <- sdg_summary_df %>%
  group_by(faculty_school_name) %>%
  summarise(
    courses_per_faculty = n_distinct(course_name),
    sdg_courses_faculty = n_distinct(course_name[lengths(sdg) > 0]),
    not_sdg_courses_faculty = n_distinct(course_name[lengths(sdg) == 0]),
    
    # Verificación explícita (solo para comprobación, puede eliminarse después)
    check = sdg_courses_faculty + not_sdg_courses_faculty == courses_per_faculty,
    
    sdg_ratio_faculty = round(100 * sdg_courses_faculty / courses_per_faculty, 1)
  ) %>%
  ungroup()

# Mostrar si hay inconsistencias (para depuración)
if(any(!faculty_stats$check)) {
  warning("¡Inconsistencia encontrada! La suma no coincide para algunas facultades:")
  print(faculty_stats %>% filter(!check))
}

# Eliminamos la columna de verificación (opcional)
faculty_stats <- faculty_stats %>% select(-check)

# Procesamiento para los SDGs individuales
flat_df <- sdg_summary_df %>%
  select(faculty_school_name, course_name, sdg) %>%
  filter(lengths(sdg) > 0) %>%
  unnest(sdg) %>%
  distinct(faculty_school_name, course_name, sdg)

# Construcción del resumen final
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

# Exportar JSON
write_json(sdg_faculty_summary, "docs/data/faculties_sdg_data.json", pretty = TRUE, auto_unbox = TRUE)