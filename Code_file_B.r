summary(ico)
# --- 1. outliers in Distributed_Percentage found as the value cannot exceed more than 1.00
  # handling 10 values which is > 1
ico <- ico[ico$distributedPercentage <= 1,]

# --- 2. for PriceUSD variable, there are 43 values greater than the mean 17.87 with only one value 39,384 which is far more greater than the rest of the values
summary(ico$priceUSD)
subset(ico$priceUSD, ico$priceUSD > 17.87) %>% sort()
  # remove PriceUSD= 39,384 outlier from the dataset
ico  <- ico[ico$priceUSD < 39000,]

# --- 3. Log transformation for coinNum 
ico$coinNum <- log(ico$coinNum)

  # checking for outlier values based on histogram plot
subset(ico$coinNum, ico$coinNum < 10) %>% sort()
subset(ico$coinNum, ico$coinNum > 25) %>% sort()

  # Remove outlier values above the 98 percentile either ends
ico <- ico[ico$coinNum >= quantile(ico$coinNum, probs = 0.01) & ico$coinNum <= quantile(ico$coinNum, probs = 0.99),]
  
  # checking final distribution
hist(ico$coinNum)
