# Tatu Leppämäki, 12 Nov. 2023
# This scripts modifies a raw data set to be suitable for later analysis.

library(readr)
#library(dplyr)

# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                    sep="\t", header=TRUE)

# Printing out the dimensions and structure of the data
dim(lrn14)
str(lrn14)
# The data include 60 variables (columns) and 183 observations (rows).
# All variables are integers except for 'Gender', which is a character string

# combining, scaling and extracting to a new dataframe
lrn14$attitude <- lrn14$Attitude / 10
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
lrn14$deep <- rowMeans(lrn14[, deep_questions])
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])
learning2014 <- lrn14[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"
more_than_zero <- dplyr::filter(learning2014, points > 0)

# writing to file
write_csv(more_than_zero, "data/learning2014.csv")

# reading back and making sure everything is correct
df <- read_csv("data/learning2014.csv")
dim(df)
str(df)
# yep, 166 rows, 7 cols