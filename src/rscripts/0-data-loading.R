
# setwd("~/git/urv-sdgs-tracker")
setwd("C:/Users/Lluis Salvat/git/urv-sdgs-tracker")

library(readr)
library(dplyr)
library(jsonlite)



# Load and setup main docs ----
degree_programs_list <- read_delim("data/degree_programs_list.csv",
                                   delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                                   trim_ws = TRUE)
course_details_list_guido <- read_csv("data/course_details_list_guido.csv")


course_details_list_docnet <- read_csv("data/course_details_list_docnet.csv")
colnames(course_details_list_docnet) <- c("web_scraper_order", "degree_url", 
                                          "course_delivery_mode", "course_code", "course_name","course_url_first_join",
                                          "course_period", "course_type", "credits", "year")



#Load and replace the first course_url for iframe_url in Docnet courses
docnet_iframes <- read_delim("data/docnet-iframe.csv",
                             delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                             trim_ws = TRUE)
docnet_iframes_subset <- docnet_iframes[, c("web-scraper-start-url", "iframes")]
colnames(docnet_iframes_subset) <- c("course_url_first_join","iframes")

course_details_list_docnet <- merge(course_details_list_docnet, docnet_iframes_subset, by = "course_url_first_join", all = TRUE)



#Edit course_details_list_docnet and course_details_list_guido to rbind

colnames(course_details_list_docnet) <- c("course_url_first_join", "web_scraper_order", "degree_url", 
                                          "course_delivery_mode", "course_code", "course_name",
                                          "course_period", "course_type", "credits", "year","course_url")

course_details_list_docnet <- course_details_list_docnet[, c("web_scraper_order", "degree_url", 
                                                             "course_url", "course_code", "course_name", "course_delivery_mode",
                                                             "course_period", "course_type", "credits", "year")]


colnames(course_details_list_guido) <- c("web_scraper_order", "degree_url", 
                                         "course_name", "course_delivery_mode", "course_url", 
                                         "course_code", "course_period", "course_type", "credits", "year")

course_details_list_guido <- course_details_list_guido[, c("web_scraper_order", "degree_url", 
                                                           "course_url", "course_code", "course_name", "course_delivery_mode", 
                                                           "course_period", "course_type", "credits", "year")]


colnames(degree_programs_list) <- c("web_scraper_order", "faculty_school_url", 
                                    "degree_name", "degree_url")



course_details_list <- rbind(course_details_list_guido, course_details_list_docnet)

rm(course_details_list_guido,course_details_list_docnet,docnet_iframes,docnet_iframes_subset)



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

colnames(guido_course_learning_results) <- c("web_scraper_order", "course_url", "learning_results")
colnames(docnet_course_learning_results) <- c("web_scraper_order", "course_url", "learning_results")

guido_course_learning_results <- guido_course_learning_results[, c("web_scraper_order", "course_url", "learning_results")]
docnet_course_learning_results <- docnet_course_learning_results[, c("web_scraper_order", "course_url", "learning_results")]

course_learning_results <- rbind(guido_course_learning_results, docnet_course_learning_results)
rm(guido_course_learning_results,docnet_course_learning_results)



# Load and setup competences ----
docnet_course_competences <- read_csv("data/docnet-course-competences.csv")

colnames(docnet_course_competences) <- c("web_scraper_order", "course_url", "competences")

course_competences <- docnet_course_competences
rm(docnet_course_competences)



# Load and setup bibliography ----
guido_course_bibliography <- read_csv("data/guido-course-bibliography.csv")
docnet_course_bibliography <- read_csv("data/docnet-course-bibliography.csv")

colnames(guido_course_bibliography) <- c("web_scraper_order", "course_url", "reference")
colnames(docnet_course_bibliography) <- c("web_scraper_order", "course_url", "reference")

guido_course_bibliography <- guido_course_bibliography[, c("web_scraper_order", "course_url", "reference")]
docnet_course_bibliography <- docnet_course_bibliography[, c("web_scraper_order", "course_url", "reference")]

course_bibliography <- rbind(guido_course_bibliography, docnet_course_bibliography)
rm(guido_course_bibliography, docnet_course_bibliography)



# Join data----
# Remove the suffixes from degree_url in both datasets so that degree_url matches in both cases
degree_programs_list$degree_url <- sub("/detall$", "", degree_programs_list$degree_url)
course_details_list$degree_url <- sub("/assignatures/gestionar$", "", course_details_list$degree_url)



#Merge course details with additional information
course_details <- course_details_list %>%
  left_join(course_coordinators, by = "course_url") %>%
  left_join(course_professors, by = "course_url") %>%
  left_join(course_description, by = "course_url") %>%
  left_join(course_contents, by = "course_url") %>%
  left_join(course_learning_results, by = "course_url") %>%
  left_join(course_competences, by = "course_url") %>%
  left_join(course_bibliography, by = "course_url")

rm(course_coordinators,course_professors,course_description,course_contents,course_learning_results,course_competences,course_bibliography)


#Merge course details with degree details
course_details <- left_join(degree_programs_list, course_details, by = "degree_url")

rm(course_details_list,degree_programs_list)


#Nest courses within each degree while keeping all degree information
#final_structure <- degree_programs_list %>%
#  left_join(course_details %>% group_by(degree_url) %>%
#              summarise(courses = list(cur_data())), by = "degree_url") %>%
#  mutate(courses = ifelse(is.na(courses), list(NULL), courses))  # Ensures degrees without courses still appear



#Convert the final structure to JSON
#json_output <- toJSON(final_structure, pretty = TRUE, auto_unbox = TRUE, na = "null")

#Save the JSON to a file
#write(json_output, "src/json/sdgs_urv_data.json")