#### Load necessary library####


# Install and load required libraries
install_and_load("readxl")
install_and_load("dplyr")

install.packages("readxl")
library(readxl)


install.packages("dplyr")
library(dplyr)
# Read the dataset
file_path <- "D:\\Shihab vai work\\Dataset\\user_data.xlsx"
df <- read_excel(file_path, sheet = "Ratings")

# Select relevant columns (Cuisine, Price, Distance, Service, Talal, Ahmeed)
df_selected <- df %>% select(Cuisine, Price, Distance, Service, Talal, Ahmeed)

# Compute the average rating for Talal and Ahmeed
df_selected <- df_selected %>% mutate(Avg_Rating = rowMeans(select(., Talal, Ahmeed), na.rm = TRUE))

# Find the best configuration (highest rating)
best_config <- df_selected %>% filter(Avg_Rating == max(Avg_Rating))

# Find the worst configuration (lowest rating)
worst_config <- df_selected %>% filter(Avg_Rating == min(Avg_Rating))

# Print results
print("Best Restaurant Configuration:")
print(best_config)

print("Worst Restaurant Configuration:")
print(worst_config)






























