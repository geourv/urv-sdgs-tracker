# Example dataframe
df <- data.frame(
  faculty = c("Science", "Science", "Arts", "Arts", "Science"),
  degree = c("Biology", "Biology", "History", "History", "Physics"),
  course = c("Genetics", "Ecology", "Ancient History", "Modern History", "Quantum Mechanics"),
  professor = c("Dr. A", "Dr. B", "Dr. C", "Dr. D", "Dr. E"),
  credits = c(4, 3, 5, 4, 6)
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
