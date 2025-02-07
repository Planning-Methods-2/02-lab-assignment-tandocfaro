# Lab 2 Script: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Objectives ----
# In this Lab you will learn to:

# 1. Load datasets into your R session -> open the `Lab2_script.R` to go over in class.
# 2. Learn about the different ways `R` can plot information
# 3. Learn about the usage of the `ggplot2` package


#---- Part 1: Loading data ----

# Data can be loaded in a variety of ways. As always is best to learn how to load using base functions that will likely remain in time so you can go back and retrace your steps. 
# This time we will load two data sets in three ways.


## ---- Part 1.1: Loading data from R pre-loaded packages ----

data() # shows all preloaded data available in R in the datasets package
help(package="datasets") # shows the documentation of the package called datasets

#Let's us the Violent Crime Rates by US State data 

help("USArrests") # shows the documentation of the USArrests dataset

# Step 1. Load the data in you session by creating an object

usa_arrests<-datasets::USArrests # this looks the object 'USAarrests' within '::' the package 'datasets'

class(usa_arrests) # Identifies the class of the dataset inside usa_arrests
names(usa_arrests) # Identifies the column names in the dataset inside usa_arrests
dim(usa_arrests) # Identifies the total number of rows and columns respectively.
head(usa_arrests) # Shows the first 6 rows in the dataset
tail(usa_arrests) # Shows the last 6 rows in the dataset

## ---- Part 1.2: Loading data from your computer directory ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa<-read.csv(file = "datasets/accelaissuedpermitsextract.csv",header = T) # Saves the dataset/csv file under the name of building_permits_sa

names(building_permits_sa) # Identifies the column names in the dataset inside building_permits_sa
View(building_permits_sa) # Views the dataset called building_permits_sa
class(building_permits_sa) # Identifies the class of the dataset called building_permit_sa
dim(building_permits_sa) # Identifies how many rows and columns are present in the dataset.
str(building_permits_sa) # Provides the first 4 rows of the dataset that includes the information of the columns
summary(building_permits_sa) # Summarizes the information of the columns that includes lengths, classes, and modes.


## ---- Part 1.3: Loading data directly from the internet ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa2 <- read.csv("https://data.sanantonio.gov/dataset/05012dcb-ba1b-4ade-b5f3-7403bc7f52eb/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512/download/accelaissuedpermitsextract.csv",header = T) # Loads dataset from the internet. 




## ---- Part 1.4: Loading data using a package + API ----
install.packages("tidycensus") # Installs the tidycensus package to the system.
install.packages("tigris") # Installs the tigris package to the system
help(package="tidycensus") # Provides the documentation of the tidycensus package.
library(tidycensus) # Loads the tidycensus package to the file
library(tigris) # Loads the tigris package to the file


#type ?census_api_key to get your Census API for full access.

age10 <- get_decennial(geography = "state", 
                       variables = "P013001", 
                       year = 2010) # Displays the median age 2010 decennial data by state and stored the data under age10

head(age10) # Displays the first 6 rows of data in age10


bexar_medincome <- get_acs(geography = "tract", variables = "B19013_001",
                           state = "TX", county = "Bexar", geometry = TRUE) # Displays the median income of acs data in Bexar county with geometry. The information is stored under the name bexar_medincome.


View(bexar_medincome) # Views the acs data.

class(bexar_medincome) # Identifies the class of the data

#---- Part 2: Visualizing the data ----
#install.packages('ggplot2')

library(ggplot2) # Loads the ggplot2 package.



## ---- Part 2.1: Visualizing the 'usa_arrests' data ----

ggplot() # Creates a plot data of ...

#scatter plot - relationship between two continuous variables
ggplot(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) +
  geom_point() #Creates a graph of the data usa_arrests with Assault in the x axis and Murder in the Y axis.

ggplot() +
  geom_point(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) #Creates a graph of the data usa_arrests with Assault in the x axis and Murder in the Y axis.


#bar plot - compare levels across observations
usa_arrests$state<-rownames(usa_arrests) # Creates a column in the usa_arrests data called rownames.

ggplot(data = usa_arrests,aes(x=state,y=Murder))+
  geom_bar(stat = 'identity') # Creates a bar graph of murders by state.

ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder))+
  geom_bar(stat = 'identity')+
  coord_flip() # Creates a bar graph of murders by state and switching the x an y axis.It arranges the state by most, to least.

# adding color # would murder arrests be related to the percentage of urban population in the state?
ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder,fill=UrbanPop))+
  geom_bar(stat = 'identity')+
  coord_flip() # Creates a bar graph of murders by state and creates a legend of the urban population of the state.

# adding size
ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point() # Creates a graph of usa_arrests of the assault (x) and murder (y) in relation to their urban population (size of circle).


# plotting by south-east and everyone else 

usa_arrests$southeast<-as.numeric(usa_arrests$state%in%c("Florida","Georgia","Mississippi","Lousiana","South Carolina")) # Creates a column called southeast that gives Florida, Georgia, Mississippi, Lousiana, South Carolina 1 value.


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop, color=southeast)) +
  geom_point() # Creates a graph of usa_arrests. Southeast areas are given a color.

usa_arrests$southeast<-factor(usa_arrests$southeast,levels = c(1,0),labels = c("South-east state",'other')) # Adds to the column of southeast label to the states of Florida, Georgia, Mississipi, Lousiana, and South Carolina.

ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_wrap(southeast~ .) # Separates the level of South East States to the others by having them in a different plot.


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_grid(southeast ~ .) # Creates a matrix of plots.

## ---- Part 3: Visualizing the spatial data ----
# Administrative boundaries


library(leaflet)
library(tigris)

bexar_county <- counties(state = "TX",cb=T)
bexar_tracts<- tracts(state = "TX", county = "Bexar",cb=T)
bexar_blockgps <- block_groups(state = "TX", county = "Bexar",cb=T)
#bexar_blocks <- blocks(state = "TX", county = "Bexar") #takes lots of time


# incremental visualization (static)

ggplot()+
  geom_sf(data = bexar_county)

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])+
  geom_sf(data = bexar_tracts)

p1<-ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",],color='blue',fill=NA)+
  geom_sf(data = bexar_tracts,color='black',fill=NA)+
  geom_sf(data = bexar_blockgps,color='red',fill=NA)

ggsave(filename = "02_lab/plots/01_static_map.pdf",plot = p1) #saves the plot as a pdf



# incremental visualization (interactive)

install.packages("mapview")
library(mapview)

mapview(bexar_county)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)+
  mapview(bexar_blockgps)


#another way to vizualize this
leaflet(bexar_county) %>%
  addTiles() %>%
  addPolygons()

names(table(bexar_county$NAME))

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons()

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups")

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups") %>%
  addLayersControl(
    overlayGroups = c("county", "tracts","block groups"),
    options = layersControlOptions(collapsed = FALSE)
  )



