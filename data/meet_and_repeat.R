# Tatu Leppämäki, 11 Dec. 2023
# This scripts modifies two wide form dataset to long form to be suitable for later analysis.

# read in data
library(readr)
library(dplyr)
library(data.table)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE, sep =" ")
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

dim(BPRS) # 40 observations, 11 var
dim(RATS) # 16 obs., 13 var

names(BPRS) # "treatment" "subject"   "week0"     "week1"     "week2"     "week3"     "week4"     "week5"     "week6"     "week7"     "week8"   
names(RATS) # "ID"    "Group" "WD1"   "WD8"   "WD15"  "WD22"  "WD29"  "WD36"  "WD43"  "WD44"  "WD50"  "WD57"  "WD64" 

summary(BPRS)
summary(RATS)

# we are working with temporal data where observations are currently in separate week (week1, week2....) / day columns (WD1, WD8...)
# under the temporal columns are the values we are interested in, namely length of a rat and BPRS psychological test score
# next, a conversion to long form data

# strings to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# many things are happening in the following code block
# 1. Values from the  week columns are inserted to  one column, bprs. Each row is the outcome for one person for one week. I guess long form could be summarized as many rows, whereas wide form is many columns.
# 2. Since the weeks column is a string, the actual week number is extracted from it and inserted as a new column.
# 3. The results are arranged by week, starting from the smallest.

BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>% 
  mutate(week = as.integer(substr(weeks,start=5,stop=5))) %>% 
  arrange(week) #order by week variable

dim(BPRSL) # 360 obs. (from the 9 value columns; 9 weeks*40 subjects=360)
glimpse(BPRSL)
summary(BPRSL)

# repeating the same things for the RATS
RATSL <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight")  %>%  mutate(Time = as.integer(substr(WD,3,4))) %>% arrange(Time)

dim(RATSL) # 176 obs (16*11)

# writing both long forms to csv
write_csv(BPRSL,"data/BPRSL.csv")

write_csv(RATSL,"data/RATSL.csv")