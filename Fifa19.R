# Fifa 19 Dataset Exploration

# Libraries
library(shiny)
library(xtable)

# fifa <- read.csv("data.csv")
# fifa
# 
# methods(filter)
# 
# rread.csv()
# 
# help(filter)
# 
# colList <- colnames(fifa)
# colList
# 
# colnames(fifa)[colnames(fifa) == 'Jersey.Number'] <- 'Jersey Number'
# colnames(fifa)[colnames(fifa) == 'Release.Clause'] <- 'Release Clause'

fifa <- read.csv("data.csv")

#Renaming Columns 
colnames(fifa)[colnames(fifa) == 'Weak.Foot'] <- 'Weak Foot'
colnames(fifa)[colnames(fifa) == 'Skill.Moves'] <- 'Skill Moves'
colnames(fifa)[colnames(fifa) == 'Work.Rate'] <- 'Work Rate'
colnames(fifa)[colnames(fifa) == 'Body.Type'] <- 'Body Type'
colnames(fifa)[colnames(fifa) == 'Real.Face'] <- 'Real Face' #may not need
colnames(fifa)[colnames(fifa) == 'Loaned.From'] <- 'Loaned From'
colnames(fifa)[colnames(fifa) == 'Contract.Valid.Until'] <- 'Contract Valid Until'
colnames(fifa)[colnames(fifa) == 'Jersey.Number'] <- 'Jersey Number'
colnames(fifa)[colnames(fifa) == 'Release.Clause'] <- 'Release Clause'

write.csv(fifa, file = "data2.csv")


