library(polyglotr)

# Function to Translate a Specific Column, Track Progress, and Dynamically Name Output
translate_column <- function(df, column, source_lang, target_lang, service = "mymemory") {
  
  handlers(global = TRUE)  # Enable progress globally within the function
  handlers("progress")    # Enable progress reporting within the function
  p <- progressor(along = seq_len(nrow(df)))  # Progress bar
  
  # Apply translation row by row
  translations <- pmap(
    list(df[[column]]),
    ~ {
      p()  # Update progress bar
      if (service == "mymemory") {
        mymemory_translate(..1, source_language = source_lang, target_language = target_lang)
      } else {
        stop("Unsupported translation service")
      }
    }
  )
  
  # Add translations to the original data frame
  new_col_name <- paste0(column, "_", target_lang)
  if (!new_col_name %in% names(df)) {
    df[[new_col_name]] <- NA  # Initialize new column with NA
  }
  df[[new_col_name]] <- translations
  
  return(df)
}

# Run the function
# df_translated <- translate_column(course_details_df[1:100,], column = "course_name", source_lang = "ca", target_lang = "en")
df_translated <- translate_column(course_details_df, column = "course_name", source_lang = "ca", target_lang = "en")



#Translate the following columns from Catalan to English language----

course_details_df <-
  translate_column(course_details_df, column = "course_name", source_lang = "ca", target_lang = "en") 

course_details_df <-
  translate_column(course_details_df, "description", "en", source_lang = "ca") 

course_details_df <-
  translate_column(course_details_df, "contents", "en", source_lang = "ca")

course_details_df <-
  translate_column(course_details_df, "competences_learning_results", "en", source_lang = "ca") 

course_details_df <-
  translate_column(course_details_df, "reference", "en", source_lang = "ca")

