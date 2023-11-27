# Tatu Leppämäki, 27 Nov. 2023
# This scripts modifies a raw HD data set to be suitable for later analysis.

# read in data
library(readr)
library(dplyr)
library(data.table)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# both have 195 obs.
# HD has 8 variables and GII has 10
print(c(dim(hd), dim(gii)))
print(c(str(hd), "\n", str(gii)))

summary(hd)
summary(gii)

setnames(hd, new=c("HDI",
                      "Life.Exp", 
                      "Edu.Exp", 
                      "Edu.Mean",
                      "GNI",
                   "GNI.HDI.diff"),
                   old=c("Human Development Index (HDI)", 
                     "Life Expectancy at Birth", 
                     "Expected Years of Education", 
                     "Mean Years of Education",
                     "Gross National Income (GNI) per Capita",
                     "GNI per Capita Rank Minus HDI Rank"))

setnames(gii, new=c("GII",
                   "Mat.Mor",
                   "Ado.Birth", 
                   "Parli.F", 
                   "Edu2.F",
                   "Edu2.M",
                   "Labo.F",
                   "Labo.M"),
         old=c("Gender Inequality Index (GII)",
               "Maternal Mortality Ratio", 
               "Adolescent Birth Rate", 
               "Percent Representation in Parliament", 
               "Population with Secondary Education (Female)",
               "Population with Secondary Education (Male)",
               "Labour Force Participation Rate (Female)",
               "Labour Force Participation Rate (Male)"))

gii <- mutate(gii, Edu2FM  =  Edu2.F / Edu2.M)
gii <- mutate(gii, LaboFM  =  Labo.F / Labo.M)

human <- inner_join(hd, gii, by = "Country")
#summary(human)
dim(human)
write_csv(human,"data/human.csv")
