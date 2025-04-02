# ML-Modelling-ICO-campaign-success

## Introduction (Business understanding)
Initial Coin offerings (as known as ICOs) are a way to raise capital for projects and start-ups in exchange of cryptocurrencies. Over the decades, it has grown in popularity as an alternative to traditional fund raising from venture capital or angel investment.  The concept has resonance towards crowdfunding, except digital currency is issued in return of capital. 
This is done through creating ‘whitepaper’ document. It outlines the details of the project and fund utilisation plan, about the team working on the project, duration, digital token coins, its price offered including legal and regulatory compliance. 
ICO campaigns are generally through online medium. It opens opportunity to global investors to contribute to the ICOs worldwide. Hence, along with the technical description about the ICO, fundraisers often attach video and have social media presence to gain trust and credibility among interested investors. As the popularity of digital currencies increase, adaption of ICO as a fundraiser will continue to grow.
With worldwide opportunity to raise funds, there are certain drawbacks to fundraising via ICO.  With having legal documentation and online presence, it can also attract scammers. Cryptocurrency being a highly speculative and volatile market, it is often difficult to value return on investment, which is often a worry among investors.
Although there are speculations about factors which could be analysed to make a prediction if the ICO would be successful or not. This project is carried out to employ Machine learning (ML) classification models to predict the likelihood of a successful ICO. This is done through using supervised classifier models like decision trees, random forest and Support Vector Machines (SVM). The analysis is done in R studio.

This project aims to understand which factors contribute the most in determining the outcome of the ICO, whether is it successful or not. 

## Data Understanding
The data provided contains different attributes about ICO projects from various companies/ projects. Each ICO campaign is given success (Y) or not success (N) label. The dataset is in a csv format with a total 2767 companies/ projects information and 16 variables. 

### VARIABLES UNDERSTANDING
The dataset provided has attributes which are used as predictors to train the ML model. These attributes can broadly be divided as project information, company details, and blockchain coin distribution details. The description of predictor variables are as follows:

Project information: -
  •	Start Date: The start day of fundraising
  •	End Date: The last day for fundraising
  •	Team size: The number of team members working on the project
  •	Ratings: A score out of 5 (1 being the lowest and 5 being the best) awarded to the project by experts. 
  •	Minimum investment (dummy): whether there are any minimum investments needed
  •	Has Video (dummy): whether the project has video made available or not
  •	Has GitHub (dummy): whether the project has an official GitHub page or not
  •	Has Reddit (dummy): whether the project has official reddit page or not. This is a platform for discussions within the community
Company details: -
  •	Country (region): The location of the company
  •	Brand (slogan): Slogan for the company or its fundraising project
Digital coins information: - 
  •	Coin number: The number of digital blockchain coins to be delivered
  •	Distributed percentage: The percentage of coin offered to the investors. The remaining is held internally by the company or team members
  •	Platform: Name of the blockchain technology used. Most popular technologies are bitcoin, Ethereum, stellar, etc. 
  •	Price: the value of the blockchain coin offered in US dollars
The most important attribute in the dataset is the dependent variable. It is a categorical variable ‘success’. It is represented by 
  •	Y = success, i.e. project achieved their desirable capital funding
  •	N = failure; i.e. project failed to receive their desirable capital funding

**** Descriptive Statistics with data visualizations file is attached seperately

## Data Preparation
Additional data preprocessing is vital before a prediction model could be useful. Handling missing values, incorrect values and handling outliers will be done to prepare dataset for predictive ML modelling. 

### HANDLING MISSING VALUES
The sum of null values in each variable was calculated:
1. Price has 180 missing values
2. Team size has 154 missing values
3. Country_region has 71 missing values
4. Platform has 6 missing values


Utilising `mice()` function to do multiple imputation on handling missing values in the price and team size variables (** Refer Code File A **). 
Since country and platform are categorical variables with over 30 platform types and over 50 country names, it is not possible to fill in missing values. Hence, both variables can be ignored.

### HANDLING OUTLIERS
As seen during data exploration, price, coin number and distributed percentage had extreme outliers. (** Refer Code File B **)
  1. Price (in USD)
There is only value ‘39,384’ that is skewing the variable. After removing the data point, the variable distribution is:

![image](https://github.com/user-attachments/assets/c25ae2ef-f8b8-4811-b9cb-3943d5f55326)


  2. Coin number
The only variable in the dataset that has significantly large values. In order to ensure it does not affect the performance of ML model, it is essential to transform the variable. 
The distribution is extremely left-skewed as seen in the chart below:

![image](https://github.com/user-attachments/assets/a91cd462-2792-428d-85d5-0797618b05d3)

Log transformation stabilizes the variance and formulates the distribution more symmetric:

![image](https://github.com/user-attachments/assets/02d13c3d-26f4-4e2a-a534-d3dd207de3a3)
 
Although the distribution is symmetrical, there are still outliers present on the either ends. 1st and 99th percentiles of its distribution is removed to drop any outliers present on extreme points. The variable distribution changes after removing outliers:

![image](https://github.com/user-attachments/assets/d99a7cda-0934-404e-92ec-147b60bc8906)

  
### HANDLING INCORRECT VALUES
  1. Distributed Percentage

![image](https://github.com/user-attachments/assets/a24e8b98-6253-4fee-816c-04c6f30398bf)

The variable distribution shows that there are 10 values that are greater than 1, which are removed to avoid incorrect prediction. (** Refer Code File B **)
```
[1]   1.66   4.00   9.52  62.50 266.25 869.75  20.00 100.00  50.00  60.00
```
The correct distribution is as follows:

![image](https://github.com/user-attachments/assets/20243671-1227-4fe3-abc6-fa9d1c32d842)

### ADDITIONAL VARIABLE CREATION
Using remaining variables in the dataset to derive new attributes related to the project information. By creating new variables, it will help capture additional information and potentially improve model performance. It might provide model additional insights to make model more interpretable. 
(** Refer Code File C **)

  1. Duration of the project
This is calculated by calculating number of days between ‘Start Date’ and ‘End Date’.  There were 12 negative values and one very extreme datapoint ‘3722 days’ was found. 
The original distribution can be seen below:
 
![image](https://github.com/user-attachments/assets/29e7f164-15ba-4c28-91d4-65fb8c7a6dbc)

The outliers were thereby removed from the dataset.
Duration showcases a relation with the response variable, which could be beneficial for ML model to derive insights.

![image](https://github.com/user-attachments/assets/4d1c6943-9e32-4baa-b484-8c869bded36f)

  2. Platform dummy variables
Platform variable is grouped into the top three major used blockchain technology into dummy variables. Ethereum, waves and stellar together consists over 88% of the share. Hence, these three are converted into dummy variables - 
    is_eth : if the platform used is Ethereum 
    is_waves: if the platform used is waves 
    is_stellar: if the platform used is stellar

  3. Country Region dummy variables
Country Region variable is grouped into continents group using ‘countrycode’ library in R, which are then re-grouped into three major regions – Europe, Asia-Africa, and America. Dummy variables are created based on these three groups:
    is_europe: if the country is from Europe
    is_asia_africa: if the country is from Asia and Africa
    is_america: if the country is from American region

### REMOVING UNNCESSARY VARIABLES
In order to avoid overfitting the data, certain variable such as id, start date, end date, country region, platform, brand slogan were removed from the dataset.

### SPLITTING DATA INTO TRAIN AND TEST DATASETS
The data is separated into response variable and feature variables. ‘Success’ is chosen to be the response categorical variable. Then the data is split into train and test, with train size of 80% and a random seed of 123 to make model replicable. 

Standard normalization scaling is used to achieve an optimised result.

## Data Modelling
There are various classification ML models available for binary class prediction. Looking at the limited size of the dataset, complexity, and nature, Decision trees, random Forest, and Support vector Machines (SVM) are preferred over other models. 

1. Decision trees are easily interpretive, intuitive and are suitable to smaller datasets
2. Random Forest like decision trees, are versatile and simple. Unlike decision trees, they are less likely to be prone to overfitting
3. SVM can handle complex relationships and is effective for higher number of features. They are also robust to overfitting

Comparing the output of each model using handout sampling on each three models. The confusion matrices are shown below:


### Decision trees
```
Model:
Call:
C5.0.default(x = train, y = train_label$train.success)

Classification Tree
Number of samples: 2107 
Number of predictors: 17 

Tree size: 7 

Non-standard options: attempt to group attributes


Decision tree:

rating <= 0.5135135: 0 (896/211)
rating > 0.5135135:
:...duration > 0.3904639: 0 (26/3)
    duration <= 0.3904639:
    :...is_stellar = 1: 0 (23/5)
        is_stellar = 0:
        :...teamSize <= 0.1351351: 0 (415/150)
            teamSize > 0.1351351:
            :...rating > 0.8108108: 1 (166/50)
                rating <= 0.8108108:
                :...hasReddit = 0: 0 (110/41)
                    hasReddit = 1: 1 (471/219)


Evaluation on training data (2107 cases):

	    Decision Tree   
	  ----------------  
	  Size      Errors  

	     7  679(32.2%)   <<


	   (a)   (b)    <-classified as
	  ----  ----
	  1060   269    (a): class 0
	   410   368    (b): class 1


Attribute usage:

	100.00%	rating
	 57.48%	duration
	 56.24%	is_stellar
	 55.15%	teamSize
	 27.57%	hasReddit


Confusion Matrix:
Confusion Matrix and Statistics

          Reference
Prediction   0   1
         0 254 119
         1  52 102
                                          
               Accuracy : 0.6755          
                 95% CI : (0.6337, 0.7154)
    No Information Rate : 0.5806          
    P-Value [Acc > NIR] : 4.768e-06       
                                          
                  Kappa : 0.3044          
                                          
 Mcnemar's Test P-Value : 4.485e-07       
                                          
            Sensitivity : 0.8301          
            Specificity : 0.4615          
         Pos Pred Value : 0.6810          
         Neg Pred Value : 0.6623          
             Prevalence : 0.5806          
         Detection Rate : 0.4820          
   Detection Prevalence : 0.7078          
      Balanced Accuracy : 0.6458 
```

The decision tree model is of tree size 7 and utilises 5 features for tree building. 
The accuracy of 67.55% shows that the model appropriately predicts the result for roughly two-thirds of the instances in the dataset. While this accuracy seems moderate, it should be considered to hyperparameter tuning to increase its predicting power.

The model has considered 5 important features. Among them, ‘Duration’ and ‘is_stellar’ platform variables are derived variables and are given significant feature importance in building the model. 

### Random Forest
```
Model:
	Call:
 	randomForest(formula = success ~ ., data = train) 
               Type of random forest: classification
                     Number of trees: 500
	No. of variables tried at each split: 4

        OOB estimate of  error rate: 35.79%
	Confusion matrix:
 	    0   1 class.error
	0 1056 247   0.1895625
	1  507 297   0.6305970

	Confusion Matrix:
	Confusion Matrix and Statistics

          Reference
	Prediction   0   1
        	 0 289 113
         	 1  57  68
                                          
               Accuracy : 0.6774          
                 95% CI : (0.6356, 0.7172)
    No Information Rate : 0.6565          
    P-Value [Acc > NIR] : 0.1678          
                                          
                  Kappa : 0.2278          
                                          
 Mcnemar's Test P-Value : 2.461e-05       
                                          
            Sensitivity : 0.8353          
            Specificity : 0.3757          
         Pos Pred Value : 0.7189          
         Neg Pred Value : 0.5440          
             Prevalence : 0.6565          
         Detection Rate : 0.5484          
   Detection Prevalence : 0.7628          
      Balanced Accuracy : 0.6055         
```
The random forest model contains 500 decision trees. They build multiple trees decision independently. Then they combine their predictions to improve accuracy and reduce overfitting. The accuracy is similar to decision trees model.

### Support Vector Machine
```
Model:
	Support Vector Machine object of class "ksvm" 

	SV type: C-svc  (classification) 
 	parameter : cost C = 1 

	Linear (vanilla) kernel function. 

	Number of Support Vectors : 1556 

	Objective Function Value : -1544.985 
	Training error : 0.334124 

             Confusion Matrix:

Confusion Matrix and Statistics

          Reference
Prediction   0   1
         0 294 181
         1  12  40
                                        
               Accuracy : 0.6338        
                 95% CI : (0.591, 0.675)
    No Information Rate : 0.5806        
    P-Value [Acc > NIR] : 0.007316      
                                        
                  Kappa : 0.1586        
                                        
 Mcnemar's Test P-Value : < 2.2e-16     
                                        
            Sensitivity : 0.9608        
            Specificity : 0.1810        
         Pos Pred Value : 0.6189        
         Neg Pred Value : 0.7692        
             Prevalence : 0.5806        
         Detection Rate : 0.5579        
   Detection Prevalence : 0.9013        
      Balanced Accuracy : 0.5709   
```
SVM is the least performing model so far with low accuracy and kappa statistic. Although, sensitivity value is higher. 

## Evaluation
For the purpose of the project, it is important to decrease the number of false positives i.e., the model should effectively predict correct number of successful projects. The objective of the model is to reliably predict successful projects based on its predictor features. Hence, higher the precision of the model will be beneficial.
  For Decision Tree model, 
	    Precision = 0.69
  For Random Forest model,
	    Precision = 0.71

Sensitivity calculates the model's capability to rightly identify positive instances. The Random Forest model has 0.8353, higher than decision trees. 
Hence, Random Forest classifier model is considered to do further tuning to improve its prediction capability.

### PARAMETER TUNING       
To further optimise the model, hyper parameters are customised to improve the model. For Random Forest model the tuning parameters are:

1. Number of trees: Increasing number of trees can lead to improved performance. Hence, Ntree was set in between 400 to 800 range
2. Maximum depth of trees: increasing depth can potentially cause overfitting the data and more complexity. Mtree was kept between 1 and 10.
3. Performing grid search over the above hyperparameters

This was done using cross validation 5-fold method to partition the training datasets in 5 folds for producing more stabilized and reliable estimates of model performance. 
The outcome is as follows:

```
Call:
summary.resamples(object = results)

Models: 300, 400, 500, 600, 700, 800 
Number of resamples: 5 

Accuracy 
         Min.   1st Qu.    Median      Mean   3rd Qu.      Max. NA's
300 0.6142857 0.6452381 0.6642857 0.6552306 0.6682578 0.6840855    0
400 0.6142857 0.6523810 0.6610979 0.6552305 0.6714286 0.6769596    0
500 0.6071429 0.6404762 0.6658711 0.6552249 0.6690476 0.6935867    0
600 0.6190476 0.6452381 0.6682578 0.6561852 0.6690476 0.6793349    0
700 0.6047619 0.6476190 0.6634845 0.6557022 0.6738095 0.6888361    0
800 0.6071429 0.6452381 0.6634845 0.6561761 0.6714286 0.6935867    0

Kappa 
          Min.   1st Qu.    Median      Mean   3rd Qu.      Max. NA's
300 0.09047161 0.1474579 0.2026175 0.1833399 0.2298914 0.2462611    0
400 0.09309021 0.1779279 0.2233448 0.1944215 0.2362429 0.2415017    0
500 0.06959884 0.1334645 0.2116351 0.1796066 0.2187209 0.2646139    0
600 0.10685805 0.1598196 0.2361438 0.1987962 0.2408332 0.2503265    0
700 0.06531532 0.1494253 0.2142810 0.1815017 0.2274851 0.2510016    0
800 0.06959884 0.1449418 0.2142810 0.1819410 0.2184466 0.2624367    0
```
Best model selected was ntree = 500 and mtree = 2. The paramters are then added to the random forest model:

### Random Forest
```
Model:
Call:
 	randomForest(formula = success ~ ., data = train, ntree = 500,  
 	tuneGrid = tunegrid, trControl = control) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 4

        OOB estimate of  error rate: 35.79%
Confusion matrix:
     0   1 class.error
0 1098 231   0.1738149
1  523 255   0.6722365

Confusion Matrix:
Confusion Matrix and Statistics

          Reference
Prediction   0   1
         0 275 135
         1  31  86
                                          
               Accuracy : 0.685           
                 95% CI : (0.6434, 0.7245)
    No Information Rate : 0.5806          
    P-Value [Acc > NIR] : 5.205e-07       
                                          
                  Kappa : 0.308           
                                          
 Mcnemar's Test P-Value : 1.303e-15       
                                          
            Sensitivity : 0.8987          
            Specificity : 0.3891          
         Pos Pred Value : 0.6707          
         Neg Pred Value : 0.7350          
             Prevalence : 0.5806          
         Detection Rate : 0.5218          
   Detection Prevalence : 0.7780          
      Balanced Accuracy : 0.6439

```
The sensitivity has increased after hyper parameter tuning, showing that model is more reliable in correctly identifying success outcomes than before. In turn, its accuracy and kappa statistic have also increased. 
Moreover, random forest model in an ensemble learning approach by creating multiple decision trees using bootstrap sampling. The out-of-the-bag (OOB) estimation helps understand model’s performance without any outside validation. Although the OOB error estimation 35.79% remains constant after hyperparameter tuning, the model classified rest of the 64% data correctly while using bootstrap sampling in building the model.  

The metric comparison of random forest model before and after hyperparameter tuning:

![image](https://github.com/user-attachments/assets/b21e5984-4e93-48fa-bec2-b4053ed4b175)

Confusion Matrix: 

![image](https://github.com/user-attachments/assets/16eb0dd7-ca88-4610-9520-78a2b102ea1a)

The AUC curve for the optimised random forest model. 
AUC = 0.6822514

![image](https://github.com/user-attachments/assets/7af27445-a122-42ae-b6d3-6c13c81e9d99)

## Conclusion
The success of a project or campaign depends on variety of internal and external dynamic factors, which is difficult to take into consideration in a ML models. Although the ML model can moderately predict the outcome of project but it still lacks the precision power. One of the limitation is the volume of the dataset. With more datapoints, a ML model has a better chance to form predictions accurately. 
In reality, blockchain technology is still maturing and hence it is still unprecedented if the crypto market will rise or crash. The public’s perception is continuously changing and this project contributes in giving investors a way to predict ICO outcome probability.




 


