library(dplyr)
str(ico)

# check for missing data 
sum(!complete.cases(ico))

library(VIM)
aggr(ico, numbers=TRUE, prop=FALSE,sortVars=TRUE,combined=TRUE)
  # PriceUSD has 180 Null values
  # teamSize has 154
  # countryRegion has 71
  # Platform has 6
  # ####coinNum has 316 ; rest all variables dont have missing values

# ---------- Handling missing values ----------------

  # --- 1. handling 'PriceUSD' & 'teamSize' variables missing values by mice()
library(mice)
mice_data <- mice(subset(ico, select = c('priceUSD','teamSize','success')), m = 5, maxit  = 10)

mice_data <- complete(mice_data,action=1) 
sum(!complete.cases(mice_data))

mice_data$success <- ico$success

    # Check for distribution
summary(ico[c('priceUSD','teamSize')])
summary(mice_data[c('priceUSD','teamSize')])

ico$priceUSD <- mice_data$priceUSD
ico$teamSize <- mice_data$teamSize
