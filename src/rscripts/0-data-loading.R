
# Set working directory----
setwd("~/git/urv-sdgs-tracker")
# setwd("C:/Users/Lluis Salvat/git/urv-sdgs-tracker")

# Load packages----
library(readr)
library(dplyr)
library(stringr)



# Load degree programs list ----
degree_programs_list <- read_delim("data/degree_programs_list.csv",
                                   delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                                   trim_ws = TRUE)
colnames(degree_programs_list) <- c("web_scraper_order", "faculty_school_url",
                                    "degree_name", "degree_url")



# Load course details list (guido) ----
course_details_list_guido <- read_csv("data/course_details_list_guido.csv")

# colnames(course_details_list_guido)
# c("web-scraper-order", "web-scraper-start-url",            "code",        "text_url",    "url",                  "url-href",   "period",        "type",        "credits", "year")
# c("web-scraper-order", "degree_url", "course_code", "course_name", "course_delivery_mode", "course_url", "course_period", "course_type", "credits", "year")


#head(course_details_list_guido)
colnames(course_details_list_guido)<-
  c("web_scraper_order",
    "degree_url",
    "course_code", "course_name", "course_delivery_mode", "course_url", "course_period", "course_type", "credits", "year")

# Load course details list (docnet)----
course_details_list_docnet <- read_csv("data/course_details_list_docnet.csv")

colnames(course_details_list_docnet) <- c("web_scraper_order", "degree_url",
                                          "course_delivery_mode", "course_code", "course_name","course_url",
                                          "course_period", "course_type", "credits", "year")

# Load and replace the first course_url for iframe_url in Docnet courses----
docnet_iframes <- read_delim("data/docnet-iframe.csv",
                             delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                             trim_ws = TRUE)
docnet_iframes <- docnet_iframes[, c("web-scraper-start-url", "iframes")]

course_details_list_docnet <- merge(course_details_list_docnet, docnet_iframes, by.x = "course_url", by.y= "web-scraper-start-url", all = TRUE)


course_details_list_docnet <-
  subset(course_details_list_docnet, select=-c(course_url))

colnames(course_details_list_docnet) <- c("web_scraper_order", "degree_url",
                                          "course_delivery_mode", "course_code", "course_name",
                                          "course_period", "course_type", "credits", "year","course_url")



# Union docnet and guido course details ----
course_details_list_docnet <- course_details_list_docnet[, c("web_scraper_order", "degree_url",
                                                             "course_url", "course_code", "course_name", "course_delivery_mode",
                                                             "course_period", "course_type", "credits", "year")]


course_details_list_guido <- course_details_list_guido[, c("web_scraper_order", "degree_url",
                                                           "course_url", "course_code", "course_name", "course_delivery_mode",
                                                           "course_period", "course_type", "credits", "year")]

course_details_list <- rbind(course_details_list_guido, course_details_list_docnet)

# Clean
rm(course_details_list_guido,course_details_list_docnet,docnet_iframes,replacements)



# Course_details_list edition----



# In course_name replace roman numbers per arabic numbers
# Replacement list
replacements <- c(" VIII$" = " 8", " VII$" = " 7", " VI$" = " 6", " V$" = " 5",
                  " IV$" = " 4", " III$" = " 3", " II$" = " 2", " I$" = " 1")

# Apply all the replacements
course_details_list <- course_details_list %>%
  mutate(course_name = Reduce(function(x, y) sub(y, replacements[[y]], x), names(replacements), course_name))



# In course_details_list create faculty_school_name column
# Function to match degree_url to faculty name
assign_faculty_name <- function(url) {
  if (grepl("^https://guiadocent.urv.cat/guido/public/centres/504/", url)) {
    return("Escola Tècnica Superior d'Arquitectura")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/499/", url)) {
    return("Escola Tècnica Superior d'Enginyeria")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/502/", url)) {
    return("Escola Tècnica Superior d'Enginyeria Química")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/498/", url)) {
    return("Facultat d'Economia i Empresa")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/501/", url)) {
    return("Facultat d'Enologia")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/500/", url)) {
    return("Facultat d'Infermeria")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/493/", url)) {
    return("Facultat de Ciències de l'Educació i Psicologia")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/497/", url)) {
    return("Facultat de Ciències Jurídiques")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/494/", url)) {
    return("Facultat de Lletres")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/496/", url)) {
    return("Facultat de Medicina i Ciències de la Salut")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/495/", url)) {
    return("Facultat de Química")
  } else if (grepl("^https://guiadocent.urv.cat/guido/public/centres/503/", url)) {
    return("Facultat de Turisme i Geografia")
  } else {
    return(NA)  # If no match is found
  }
}

# Apply the function row by row to the 'degree_url' column and create the new column
course_details_list$faculty_school_name <- sapply(course_details_list$degree_url, assign_faculty_name)

rm(replacements,assign_faculty_name)

# Load and setup coordinators ----
guido_course_coordinators <- read_csv("data/guido-course-coordinators.csv")
docnet_course_coordinators <- read_csv("data/docnet-course-coordinators.csv")

colnames(guido_course_coordinators) <- c("web_scraper_order", "course_url", "coordinators","coordinators_url")
colnames(docnet_course_coordinators) <- c("web_scraper_order", "course_url", "coordinators")

guido_course_coordinators <- guido_course_coordinators[, c("web_scraper_order", "course_url", "coordinators")]
docnet_course_coordinators <- docnet_course_coordinators[, c("web_scraper_order", "course_url", "coordinators")]

course_coordinators <- rbind(guido_course_coordinators, docnet_course_coordinators)
rm(guido_course_coordinators,docnet_course_coordinators)



# Load and setup professors ----
guido_course_professors <- read_csv("data/guido-course-professors.csv")
docnet_course_professors <- read_csv("data/docnet-course-professors.csv")

colnames(guido_course_professors) <- c("web_scraper_order", "course_url", "professors", "professors_url")
colnames(docnet_course_professors) <- c("web_scraper_order", "course_url", "professors")

guido_course_professors <- guido_course_professors[, c("web_scraper_order", "course_url", "professors")]
docnet_course_professors <- docnet_course_professors[, c("web_scraper_order", "course_url", "professors")]

course_professors <- rbind(guido_course_professors, docnet_course_professors)
rm(guido_course_professors,docnet_course_professors)



# Load and setup description ----
guido_course_description <- read_csv("data/guido-course-description.csv")
docnet_course_description <- read_csv("data/docnet-course-description.csv")

colnames(guido_course_description) <- c("web_scraper_order", "course_url", "description")
colnames(docnet_course_description) <- c("web_scraper_order", "course_url", "description")

guido_course_description <- guido_course_description[, c("web_scraper_order", "course_url", "description")]
docnet_course_description <- docnet_course_description[, c("web_scraper_order", "course_url", "description")]

course_description <- rbind(guido_course_description, docnet_course_description)
rm(guido_course_description, docnet_course_description)



# Load and setup contents ----
guido_course_contents <- read_csv("data/guido-course-contents.csv")
docnet_course_contents <- read_csv("data/docnet-course-contents.csv")

colnames(guido_course_contents) <- c("web_scraper_order", "course_url", "contents")
colnames(docnet_course_contents) <- c("web_scraper_order", "course_url", "contents")

guido_course_contents <- guido_course_contents[, c("web_scraper_order", "course_url", "contents")]
docnet_course_contents <- docnet_course_contents[, c("web_scraper_order", "course_url", "contents")]

course_contents <- rbind(guido_course_contents, docnet_course_contents)
rm(guido_course_contents, docnet_course_contents)



# Load and setup learning-results ----
guido_course_learning_results <- read_csv("data/guido-course-learning-results.csv")
docnet_course_learning_results <- read_csv("data/docnet-course-learning-results.csv")

colnames(guido_course_learning_results) <- c("web_scraper_order", "course_url", "competences_learning_results")
colnames(docnet_course_learning_results) <- c("web_scraper_order", "course_url", "competences_learning_results")

guido_course_learning_results <- guido_course_learning_results[, c("web_scraper_order", "course_url", "competences_learning_results")]
docnet_course_learning_results <- docnet_course_learning_results[, c("web_scraper_order", "course_url", "competences_learning_results")]

course_learning_results <- rbind(guido_course_learning_results, docnet_course_learning_results)
rm(guido_course_learning_results,docnet_course_learning_results)



# Load and setup competences ----
docnet_course_competences <- read_csv("data/docnet-course-competences.csv")

colnames(docnet_course_competences) <- c("web_scraper_order", "course_url", "competences_learning_results")

course_competences <- docnet_course_competences
rm(docnet_course_competences)



# Union of learning results and competences ----
course_competences_learning_results <- rbind(course_learning_results,course_competences)
rm(course_learning_results,course_competences)



# Load and setup bibliography ----
guido_course_bibliography <- read_csv("data/guido-course-bibliography.csv")
docnet_course_bibliography <- read_csv("data/docnet-course-bibliography.csv")

colnames(guido_course_bibliography) <- c("web_scraper_order", "course_url", "references")
colnames(docnet_course_bibliography) <- c("web_scraper_order", "course_url", "references")

guido_course_bibliography <- guido_course_bibliography[, c("web_scraper_order", "course_url", "references")]
docnet_course_bibliography <- docnet_course_bibliography[, c("web_scraper_order", "course_url", "references")]

course_bibliography <- rbind(guido_course_bibliography, docnet_course_bibliography)
rm(guido_course_bibliography, docnet_course_bibliography)



############################## Translation window----
# List of terms to remove in Description----
terms_to_remove_description <- c("^'- ","^- ","^—","^• ","^NA")

# Replace
course_description$description <- trimws(
  Reduce(function(x, pattern) gsub(pattern, "", x, fixed = TRUE), 
         terms_to_remove_description, course_description$description))



# List of terms to remove in References----
terms_to_remove_references <- c(
  "accés al CRAI", "No disponible a la URV", ", Més info", "Més info",
  "diversos,", "Diversos,", "diversos.", "Diversos.",
  "(Llibre) ", "(Llibre) , ", "(Llibre) / ", "(Llibre) -, ", "(Revista) ", "(Revista) , ",
  "(Altres) ", "(Altres) , ", "(Altres) / " ,"(Lloc web) ", "(Lloc web) , ",
  "(Bases de dades) ", "(Bases de dades) , ", "(Capítol llibre) ", "(Capitol llibre)  / ",
  "(Audios)  /  ",
  "^/ ","^:","^, ","^•","^- ","^. ")


# Replace
course_bibliography$references <- trimws(
  Reduce(function(x, pattern) gsub(pattern, "", x, fixed = TRUE), 
         terms_to_remove_references, course_bibliography$references))



# List of terms to remove in Competences and Learning results----
# Find the first row words of course_competences_learning_results df
course_competences_learning_results_first_words <- 
  sapply(strsplit(course_competences_learning_results$competences_learning_results, "[ \\n-]+"), `[`, 1)

# Convert the vector to unique words
course_competences_learning_results_unique_first_words <- 
  unique(course_competences_learning_results_first_words)

# Repeat the finding to better discriminate first words
course_competences_learning_results_second_words <- 
  sapply(strsplit(course_competences_learning_results_unique_first_words, "\\n+"), `[`, 1)

# Convert the vector to unique words
course_competences_learning_results_unique_second_words <- 
  unique(course_competences_learning_results_second_words)

# Save the vector to review and manually select words that don't have to be deleted
# write.csv(data.frame(course_competences_learning_results_unique_second_words), 
#          "sandbox/terms_to_remove_comp_learnres.csv", row.names = FALSE)

# Read the df with words that don't have to be deleted 
course_competences_learning_results_not_delete <-
  read.csv("data/course_competences_learning_results_not_delete.csv")

# Convert to vector
course_competences_learning_results_not_delete <-  
  course_competences_learning_results_not_delete[, 1]

course_competences_learning_results_not_delete <- 
  gsub("\\t+$", "", course_competences_learning_results_not_delete)

# Check vectors
#print(course_competences_learning_results_not_delete)
#print(course_competences_learning_results_unique_second_words)

# Delete words from course_competences_learning_results_unique_second_words vector (words that we want to be deleted)
# that are included in course_competences_learning_results_not_delete vector (words that we don't want to be deleted)
terms_to_remove_comp_learnres <- 
  setdiff(course_competences_learning_results_unique_second_words,course_competences_learning_results_not_delete)

terms_to_remove_comp_learnres <- terms_to_remove_comp_learnres[!is.na(terms_to_remove_comp_learnres) & terms_to_remove_comp_learnres != "NA"]

# Check vector
#print(terms_to_remove_comp_learnres)


# Replace
course_competences_learning_results$competences_learning_results <- trimws(
  Reduce(function(x, pattern) gsub(pattern, "", x, fixed = TRUE), 
         terms_to_remove_comp_learnres, course_competences_learning_results$competences_learning_results))


# Delete useless data----
rm(terms_to_remove_description,
   terms_to_remove_comp_learnres,
   terms_to_remove_references,
   course_competences_learning_results_first_words,
   course_competences_learning_results_unique_first_words,
   course_competences_learning_results_second_words,
   course_competences_learning_results_unique_second_words,
   course_competences_learning_results_not_delete)

##############################



# Aggregate ----
course_competences_learning_results_agg <- aggregate(competences_learning_results ~ course_url,
                                                     data = course_competences_learning_results,
                                                     paste, collapse = ";")

course_description_agg <- aggregate(description ~ course_url,
                                    data = course_description,
                                    paste, collapse = ";")

course_contents_agg <- aggregate(contents ~ course_url,
                                    data = course_contents,
                                    paste, collapse = ";")

course_bibliography_agg <- aggregate(references ~ course_url,
                                 data = course_bibliography,
                                 paste, collapse = ";")


# Remove the suffixes from degree_url in both datasets so that degree_url matches in both cases
degree_programs_list$degree_url <- sub("/detall$", "", degree_programs_list$degree_url)
course_details_list$degree_url <- sub("/assignatures/gestionar$", "", course_details_list$degree_url)


course_details_df <- course_details_list %>%
  left_join(course_competences_learning_results_agg, by = "course_url") %>%
  left_join(course_description_agg, by = "course_url") %>%
  left_join(course_contents_agg, by = "course_url") %>%
  left_join(course_bibliography_agg, by = "course_url") %>%
  select(-web_scraper_order) %>%
  left_join(degree_programs_list, by='degree_url') %>%
  select(-web_scraper_order) %>%
  mutate(document_number=row_number()) %>%
  mutate(degree_year=str_extract(degree_name, "(?<=\\()\\d{4}(?=\\))")) %>%
  select(document_number,starts_with('degree'),starts_with('faculty'),everything())

#missing_description <- course_details_df[is.na(course_details_df$description),"course_url"]

rm(course_competences_learning_results_agg,course_description_agg,course_contents_agg,course_bibliography_agg,course_coordinators,course_professors,course_description,course_contents,course_competences_learning_results,course_bibliography)



#Merge course details with degree details
# course_details <- left_join(degree_programs_list, course_details, by = "degree_url")

rm(course_details_list,degree_programs_list)

# Save course_details_df (only once!)
# course_details_df <- write.csv(course_details_df, "./data/course_details_df.csv", row.names = FALSE)
