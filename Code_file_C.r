# --- 1. Platform variable data cleaning
  # Text cleaning
library(tm)
myCorpus <- Corpus(VectorSource(ico$platform))
cleantext <- function(text) {
  #text to lowercase
  text <- tolower(text)
  
  #Remove punctuation
  text <- gsub("[[:punct:]]", " ", text)
  
  #Remove extra white spaces
  text <- gsub("\\s+", " ", text)
  
  #remove Alpha-numeric characters
  text <- gsub("[^[:alnum:][:space:]]", " ", text)
  
  #Trim trailing whitespace
  text <- trimws(text)
  
  return(text)
}
myCorpus <- sapply(myCorpus, cleantext)
myCorpus <- Corpus(VectorSource(myCorpus))

  # remove extra whitespace
myCorpus <- tm_map(myCorpus, stripWhitespace)

df <- as.data.frame(myCorpus$content)
colnames(df)[1] <- "platform"
ico$platform <- df$platform

# --- 2. CountryRegion variable data cleaning

# Clean accented letters into english letters
myCorpus2 <- Corpus(VectorSource(ico$countryRegion))

cleantext2 <- function(text) {
  
  #remove accented characters
  text <- gsub("é", "e", text)
  text <- gsub("ç", "c", text)
  return(text)
  }
myCorpus2 <- sapply(myCorpus2, cleantext2)
myCorpus2 <- Corpus(VectorSource(myCorpus2))

df2 <- as.data.frame(myCorpus2$content)
colnames(df2)[1] <- "country"
ico$countryRegion <- df2$country
# ---------- Addition of new variable -----------------
# --- 1. new platform dummy variables 
# Taking ethereum, waves and stellar (consisting over 88% share of the platforms)

ico$is_eth <- case_when(
  ico$platform %in% c("ethereum","ethererum", "eth","etherum") ~ "1",
  TRUE ~ "0") 
ico$is_eth <- as.factor(ico$is_eth)

ico$is_waves <- case_when(
  ico$platform %in% c("waves") ~ "1",
  TRUE ~ "0") 
ico$is_waves <- as.factor(ico$is_waves)

ico$is_stellar <- case_when(
  ico$platform %in% c("stellar","stellar protocol") ~ "1",
  TRUE ~ "0") 
ico$is_stellar <- as.factor(ico$is_stellar)

# exploring with predictor variable
ggplot(ico)+geom_bar(aes(is_waves,fill = success),position = "fill") 

ggplot(ico)+geom_bar(aes(is_stellar,fill = success),position = "fill") 

ggplot(ico)+geom_bar(aes(is_otherplatform,fill = success),position = "fill") 


# --- 2. new countryRegion dummy variables

# list continents from countryRegion column
#install.packages('countrycode')
library(countrycode)
ico$continent <- countrycode(sourcevar = ico$countryRegion, origin = "country.name",destination = "region")

# create 3 continents group = Europe, Asia and Africa and America 
ico$continent_group <-  case_when(
  ico$continent %in% c("Europe & Central Asia") ~ "Europe",
  ico$continent %in% c("Middle East & North Africa","Sub-Saharan Africa","South Asia", "East Asia & Pacific") ~ "Africa and Asia",
  ico$continent %in% c("North America","Latin America & Caribbean") ~ "America",
  TRUE ~ "NA")
# correcting few countries in the right group
ico$continent_group <- case_when(ico$countryRegion %in% c("Russia","Kyrgyzstan","Kazakhstan","Cyprus") ~ "Africa and Asia",
                                 TRUE ~ ico$continent_group)

# creating dummy variables based on continent groups

ico$is_europe <- case_when(
  ico$continent_group %in% c("Europe") ~ "1",
  TRUE ~ "0") 
ico$is_europe <- as.factor(ico$is_europe)

ico$is_asia_africa <-  case_when(
  ico$continent_group %in% c("Africa and Asia") ~ "1",
  TRUE ~ "0") 
ico$is_asia_africa <- as.factor(ico$is_asia_africa)

ico$is_america <- case_when(
  ico$continent_group %in% c("America") ~ "1",
  TRUE ~ "0") 
ico$is_america <- as.factor(ico$is_america)

# exploring with predictor variable
ggplot(ico)+geom_bar(aes(is_europe,fill = success),position = "fill") 

ggplot(ico)+geom_bar(aes(is_asia_africa,fill = success),position = "fill") 

ggplot(ico)+geom_bar(aes(is_america,fill = success),position = "fill")

# --- 4. new duration variable
#check if there are any null values or not
summary(is.na(ico$startDate))
summary(is.na(ico$endDate))

ico$duration <- as.numeric(difftime(
  as.Date(ico$endDate, format = "%d/%m/%Y"),
  as.Date(ico$startDate, format = "%d/%m/%Y"),
  units = "days" ))

summary(ico$duration)  

subset(ico[c("startDate","endDate","duration")], ico$duration < 0)  

  # there are 12 negative values, which are converted to absolute numbers
ico$duration <- abs(ico$duration)

  # remove outliers
subset(ico$duration, ico$duration > 90) %>% sort()
  # there is one value 3722 much greater than rest of the values which can be removed
ico <- ico[ico$duration < 3722,]

# check relationship with predictory variable
ggplot(ico)+geom_histogram(aes(duration,fill=success, colour = success),alpha = 0.5, position = "identity")
