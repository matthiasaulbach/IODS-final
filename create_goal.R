# IDEA: therapist dummy coding -> AC 0/1, BD 0/1, etc. so I can calculate ORs for them





install.packages("foreign")
library(foreign)
install.packages("memisc")
library(memisc)
install.packages("dplyr")
library(dplyr)
install.packages("utils")
library(utils)
install.packages("ggplot2")
library(ggplot2)
install.packages("nnet")
library(nnet)
install.packages("gmodels")
library(gmodels)
install.packages("pscl")


goals = as.data.set(spss.system.file("D:\\PhD University of Helsinki\\uni network 02_03_2017\\Desktop\\Data Analysis Keegan\\Goal.sav"))
goals = as.data.set(spss.system.file("\\\\ATKK\\home\\a\\aulbach\\Desktop\\Data Analysis Keegan\\Goal.sav"))
goals <- as.data.frame(goals)
dim(goals)
str(goals)
colnames(goals)
str(goals$therapist)
View(goals)

# The dataset is from an intervention study in which depression patients/clients received several sessions of psychotherapy with Motivational Interviewing techniques.
# In the sessions, certain goals were set. This were then categorized by the researchers.
# The dataset is constructed so that each goal has an own line which means that the same patient appears several times in the dataset. This is because the focus of this analysis are the goal contents rather than the clients.
# The goals are coded as binary variables, i.e. every goal category is a column in the dataset. This is because some goals belong to more than one category.
# In addition, we have information on the name of the therapist (as a categorical variable), and "PHQ" scores: this is a measure for depressive symptoms. The higher the score, the more severe the depression.
# Also we have a column indicating the goalprogress as a numeric variable, indicating to what degree the clients have managed to implement their goal.
# Research questions:
## 1. Does the kind of goal that has been set have an influence on a) goal progress and b) symptom change?
## 2. Do the therapists differ in their effectiveness regarding a) goal progress and b) symptom change?
## 3. Does it depend on the therapist which kind of goal is chosen?

# These research goals imply that we need 1. the goal variables, 2. the therapist variable, 3. goal process, and 4. PHQ scores (beginning and end)
# All other variables are not of interest for the present analysis and will therefore be excluded.

# Data wrangling

## Throwing out rows with missing values
gol <- dplyr::filter(goals, !is.na(pagol))
dim(gol)
str(gol)

## Create a dataset with just the variables of interest
keep_columns <- c("pagol","dietgol", "alcogol", "addictgol", "sleepgol","relaxgol", "socgol", "emogol","coggoal","workgoal","homegoal","hobgoal","hygmdgol","treatgol","badgoal","assgoal","reenggol","unclearg", "therapist", "zgoalprogress","phqentry", "phqend", "goalprogress_full")
Goals <- dplyr::select(gol, dplyr::one_of(keep_columns))
dim(Goals)
str(Goals)
View(Goals)

## let's get rid of the unused "" - level of the "therapist" factor variable
Goals$therapist <- droplevels(Goals$therapist)
dim(Goals)
str(Goals)
summary(Goals)

## I also want to remove missing values within "phqend" to work with complete datasets only.
Goals <- dplyr::filter(Goals, !is.na(phqend))
dim(Goals)
str(Goals)
## What will be interesting to look at are difference scores between phqentry and phqend, i.e. how much depressive symptoms changed during the treatment
phq_change <- c(Goals$phqentry - Goals$phqend)
Goals["phq_change"] <- phq_change
str(Goals)

## I will also create a binary variable of "phqend", according to whether patients still are diagnosed as depressed or not. The cut-off is usually set at 10 points, i.e. anyone scoring 10 points or more is considered as suffering from a depression.
Goals <- mutate(Goals, depr = phqend >= 10)
str(Goals)

## Making the goals factor variables since they were coded with "1" and "0" and represented as numeric.
Goals <- mutate(Goals, pagol = pagol > 0)
Goals <- mutate(Goals, dietgol = dietgol > 0)
Goals <- mutate(Goals, alcogol = alcogol > 0)
Goals <- mutate(Goals, addictgol = addictgol > 0)
Goals <- mutate(Goals, sleepgol = relaxgol > 0)
Goals <- mutate(Goals, relaxgol = relaxgol > 0)
Goals <- mutate(Goals, socgol = socgol > 0)
Goals <- mutate(Goals, emogol = emogol > 0)
Goals <- mutate(Goals, coggoal = coggoal > 0)
Goals <- mutate(Goals, workgoal = workgoal > 0)
Goals <- mutate(Goals, homegoal = homegoal > 0)
Goals <- mutate(Goals, hobgoal = hobgoal > 0)
Goals <- mutate(Goals, hygmdgol = hygmdgol > 0)
Goals <- mutate(Goals, treatgol = treatgol > 0)
Goals <- mutate(Goals, badgoal = badgoal > 0)
Goals <- mutate(Goals, assgoal = assgoal > 0)
Goals <- mutate(Goals, reenggol = reenggol > 0)
Goals <- mutate(Goals, unclearg = unclearg > 0)

str(Goals)

## Writing the file
write.table(Goals, file = "Goals")













