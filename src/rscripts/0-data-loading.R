
# setwd("~/git/urv-sdgs-tracker")
setwd("C:/Users/Lluis Salvat/git/urv-sdgs-tracker")


library(readr)
library(dplyr)
library(jsonlite)
library(stringr)
library(polyglotr)



# Load degree programs list ----
degree_programs_list <- read_delim("data/degree_programs_list.csv",
                                   delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                                   trim_ws = TRUE)
colnames(degree_programs_list) <- c("web_scraper_order", "faculty_school_url", 
                                    "degree_name", "degree_url")




# Load course details list guido ----
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

#Load and replace the first course_url for iframe_url in Docnet courses
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
rm(course_details_list_guido,course_details_list_docnet,docnet_iframes)



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

colnames(guido_course_bibliography) <- c("web_scraper_order", "course_url", "reference")
colnames(docnet_course_bibliography) <- c("web_scraper_order", "course_url", "reference")

guido_course_bibliography <- guido_course_bibliography[, c("web_scraper_order", "course_url", "reference")]
docnet_course_bibliography <- docnet_course_bibliography[, c("web_scraper_order", "course_url", "reference")]

course_bibliography <- rbind(guido_course_bibliography, docnet_course_bibliography)
rm(guido_course_bibliography, docnet_course_bibliography)


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

course_bibliography_agg <- aggregate(reference ~ course_url, 
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

rm(course_coordinators,course_professors,course_description,course_contents,course_competences_learning_results,course_bibliography)


#Merge course details with degree details
# course_details <- left_join(degree_programs_list, course_details, by = "degree_url")

rm(course_details_list,degree_programs_list)

