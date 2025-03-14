# Example dataframe
df <- data.frame(
  faculty = c("Science", "Science", "Arts", "Arts", "Science"),
  degree = c("Biology", "Biology", "History", "History", "Physics"),
  course = c("Genetics", "Ecology", "Ancient History", "Modern History", "Quantum Mechanics"),
  professor = c("Dr. A", "Dr. B", "Dr. C", "Dr. D", "Dr. E"),
  credits = c(4, 3, 5, 4, 6),
  sdg = c("SDG-01","SDG-02","SDG-03","SDG-04","SDG-05","SDG-06","SDG-07","SDG-08","SDG-09","SDG-10","SDG-11","SDG-12","SDG-13","SDG-14","SDG-15","SDG-16","SDG-17")
)

# Split first by faculty, then within each faculty, split by degree
faculty_list <- split(df, df$faculty) 
faculty_list <- lapply(faculty_list, function(fac) split(fac[, -1:-2], fac$degree))

# Print structure
str(faculty_list, max.level = 2)

# Convert to JSON
json_output <- jsonlite::toJSON(faculty_list, dataframe = "rows", pretty = TRUE)

# Save JSON to file
write(json_output, "./docs/data/urv-sdgs.json")

# Print JSON
cat(json_output)
