
setwd("~/git/urv-sdgs-tracker")
# setwd("C:/... ~/git/urv-sdgs-tracker")

library(readr)


# Load and setup main docs ----
degree_programs_list <- read_delim("data/degree_programs_list.csv",
                                   delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                                   trim_ws = TRUE)
course_details_list_guido <- read_csv("data/course_details_list_guido.csv")
course_details_list_docnet <- read_csv("data/course_details_list_docnet.csv")



colnames(degree_programs_list) <- c("web_scraper_order", "faculty_school_url", 
                                         "degree_name", "degree_url")

colnames(course_details_list_guido) <- c("web_scraper_order", "degree_url", 
                                         "course_code", "course_name", "course_delivery_mode", "course_url", 
                                         "course_period", "course_type", "credits", "year")

colnames(course_details_list_docnet) <- c("web_scraper_order", "degree_url", 
                                          "course_delivery_mode", "course_code", "course_name","course_url",
                                          "course_period", "course_type", "credits", "year")


course_details_list_guido <- course_details_list_guido[, c("web_scraper_order", "degree_url", 
                                                           "course_url", "course_code", "course_name", "course_delivery_mode", 
                                                           "course_period", "course_type", "credits", "year")]

course_details_list_docnet <- course_details_list_docnet[, c("web_scraper_order", "degree_url", 
                                                             "course_url", "course_code", "course_name", "course_delivery_mode",
                                                             "course_period", "course_type", "credits", "year")]

course_details_list <- rbind(course_details_list_guido, course_details_list_docnet)

rm(course_details_list_guido,course_details_list_docnet)


# Load and setup coordinators ----
guido_course_coordinators <- read_csv("data/guido-course-coordinators.csv")
docnet_course_coordinators <- read_csv("data/docnet-course-coordinators.csv")

# Load and setup coordinators ----
guido_course_professors <- read_csv("data/guido-course-coordinators.csv")
docnet_course_professors <- read_csv("data/docnet-course-professors.csv")




# Bibliography ----
