# Lab 2 Assignment: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Instructions ----

# 1. [40 points] Open the R file "Lab2_Script.R" comment each line of code with its purpose (with exception of Part 3)
# 2. [60 points] Open the R file "Lab2_Assignment.R" and answer the questions

#---- Q1. write the code to load the dataset "tract_covariates.csv" located under the "datasets" folder in your repository. Create an object called `opportunities` Use the data.table package to do this. ----

install.packages("data.table")
library(data.table)

tract_covariates <- read.csv("D:/Documents/Methods 2/02-lab-assignment-tandocfaro/datasets/tract_covariates.csv")

opportunities <- data.table(tract_covariates)



#---- Q2. On your browser, read and become familiar with the dataset metadata. Next write the code for the following:
# Link to metadata: https://opportunityinsights.org/wp-content/uploads/2019/07/Codebook-for-Table-9.pdf 

pdf_url <- "https://opportunityinsights.org/wp-content/uploads/2019/07/Codebook-for-Table-9.pdf" 
destination_path <- "D:/Documents/Methods 2/02-lab-assignment-tandocfaro/Codebook-for-Table-9.pdf"

download.file(pdf_url, destination_path, mode = "Wb")

# what is the object class?
class(opportunities)


# how can I know the variable names?
names(opportunities)


# What is the unit of analysis? 
str(opportunities)


# Use the `summary` function to describe the data. What is the variable that provides more interest to you?

summary(opportunities)

# Create a new object called `sa_opportunities` that only contains the rows for the San Antonio area (hint: use the `czname` variable). 

opportunities$sa_opportunities <- opportunities$czname == "San Antonio"

# Create a plot that shows the ranking of the top 10 census tracts by Annualized job growth rate (`ann_avg_job_growth_2004_2013` variable) by census tract (tract variable). Save the resulting plot as a pdf with the name 'githubusername_p1.pdf' # Hint: for ordering you could use the `setorderv()` or reorder() functions, and the ggsave() function to export the plot to pdf. 

library(ggplot2)
library(dplyr)
          
top10_tract <- opportunities %>%
  arrange(desc(ann_avg_job_growth_2004_2013)) %>%
  head(10)

ggplot(data = top10_tract, aes(x=reorder("tract", "ann_avg_job_growth_2004_2013"), y="ann_avg_job_growth_2004_2013"))+
  geom_bar(stat = 'identity')

p1 <- ggplot(data = top10_tract, aes(x="tract", y="ann_avg_job_growth_2004_2013"))+
  geom_bar(stat = 'identity')

ggsave(filename = "githubusername_p1.pdf",plot = p1)

# Create a plot that shows the relation between the `frac_coll_plus` and the `hhinc_mean2000` variables, what can you hypothesize from this relation? what is the causality direction? Save the resulting plot as a pdf with the name 'githubusername_p3.pdf'
ggplot(data = opportunities, aes(frac_coll_plus2010, hhinc_mean2000)) +
  geom_point()

p3 <- ggplot(data = opportunities, aes(frac_coll_plus2010, hhinc_mean2000)) +
  geom_point()

ggsave(filename = "githubusername_p3.pdf",plot = p3)

#the hypothesis is the higher the income, the higher the educational attainment

# Investigate (on the internet) how to add a title,a subtitle and a caption to your last plot. Create a new plot with that and save it as 'githubusername_p_extra.pdf'
p4 <- ggplot(data = opportunities, aes(frac_coll_plus2010, hhinc_mean2000)) +
  geom_point()+ 
  labs(title = "Educational Attainment", 
  subtitle = "Educational Attainment in relation to Median Income Level")

ggsave(filename = "githubusername_p_extra.pdf",plot = p4)








