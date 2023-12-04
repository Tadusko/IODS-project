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
                     "Life Expectancy at Birth", # years
                     "Expected Years of Education", 
                     "Mean Years of Education",
                     "Gross National Income (GNI) per Capita", # 2017 PPP $
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
               "Maternal Mortality Ratio", # deaths per 100,000 live births
               "Adolescent Birth Rate", # births per 1,000 women ages 15–19
               "Percent Representation in Parliament", 
               "Population with Secondary Education (Female)", # %
               "Population with Secondary Education (Male)", # %
               "Labour Force Participation Rate (Female)", # %
               "Labour Force Participation Rate (Male)")) # %

gii <- mutate(gii, Edu2.FM  =  Edu2.F / Edu2.M)
gii <- mutate(gii, Labo.FM  =  Labo.F / Labo.M)


human <- inner_join(hd, gii, by = "Country")

# We now have a new dataset called "human", that contains country-wise variables related to the
# wealth, education, wellbeing and gender equality of citizens in 195 countries.
# The column names and their correspondence to the short versions are listed above.
# Metadata and full variable related to both Human Development Index and the Gender Inequality Index can be found here:
# https://hdr.undp.org/system/files/documents/technical-notes-calculating-human-development-indices.pdf

# In addition, we have two variables derived from the others, namely:
# Edu2FM = the ratio between female and male population with secondary education
# LaboFM = the ratio between female and male labour force participation rate.

summary(human)
dim(human) # 19 variables and 195 observations

write_csv(human,"data/human.csv")

# Let's drop redundant columns and keep only 9 variables (8 plus country names)
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep))

# extract a completeness indicator of the 'human' data
# in other words, whether a row has missing values
comp <- complete.cases(human)

# the data also includes regions and worldwide. Excluding those
human_filt <- filter(human, comp)

# define the last indice we want to keep
last <- nrow(human_filt) - 7

# choose everything until the last 7 observations
human_filt <- human_filt[1:last, ]

# overwriting the earlier version
write_csv(human_filt,"data/human.csv")
