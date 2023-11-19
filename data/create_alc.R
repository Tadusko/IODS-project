# Tatu Leppämäki, 19 Nov. 2023
# This scripts modifies a raw data set to be suitable for later analysis.
# Dataset is "Student performance" by Paolo Cortez, https://doi.org/10.24432/C5TG7T
# Data is shared and modified under CC BY 4.0.

# necessary libraries
library(readr)
library(dplyr)

# reading in data, seeing what's in there
math <- read.csv("data/student-mat.csv", sep=';')
str(math)
dim(math) # 395 observations, 33 variables

por <- read.csv("data/student-por.csv", sep=';')
str(por)
dim(por) # 649 observations, 33 variables

# these columns won't be used for joining
free_cols <- c("failures","paid","absences","G1","G2","G3")
# thus, the join columns are columns other than those
join_cols <- setdiff(colnames(por), free_cols)
# joining on the other columns
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

alc <- select(math_por, all_of(join_cols))

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

write_csv(alc, "data/alc.csv")
