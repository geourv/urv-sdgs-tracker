library(polyglotr)

# Create translation column function----

translate_column <- function(df, col_name, target_lang, source_lang = NULL) {
  # Verificar que la columna existe en el dataframe
  if (!col_name %in% names(df)) {
    stop(paste("La columna", col_name, "no existe en el dataframe."))
  }
  
  # Aplicar la traducción con idioma de origen opcional
  if (is.null(source_lang)) {
    translated_text <- google_translate(df[[col_name]], target_language = target_lang)
  } else {
    translated_text <- google_translate(df[[col_name]], source_language = source_lang, target_language = target_lang)
  }
  
  # Crear el nombre de la nueva columna
  new_col_name <- paste0(col_name, "_", target_lang)
  
  # Agregar la columna traducida al dataframe
  df[[new_col_name]] <- translated_text
  
  return(df)
}



#Translate the following columns from Catalan to English language----

course_details_df <-
  translate_column(course_details_df, "course_name", "en", source_lang = "ca") 

course_details_df <-
  translate_column(course_details_df, "description", "en", source_lang = "ca") 

course_details_df <-
  translate_column(course_details_df, "contents", "en", source_lang = "ca")

course_details_df <-
  translate_column(course_details_df, "competences_learning_results", "en", source_lang = "ca") 

course_details_df <-
  translate_column(course_details_df, "reference", "en", source_lang = "ca")

