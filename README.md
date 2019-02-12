# R-Programs

## Caching the Inverse of a Matrix
Matrix inversion is usually a costly computation and there may be some benefit to caching the inverse of a matrix rather than computing it repeatedly (there are also alternatives to matrix inversion that we will not discuss here). Your assignment is to write a pair of functions that cache the inverse of a matrix.

makeCacheMatrix: This function creates a special "matrix" object that can cache its inverse.
cacheSolve: This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. If the inverse has already been calculated (and the matrix has not changed), then cacheSolve should retrieve the inverse from the cache.
Computing the inverse of a square matrix can be done with the solve function in R. For example, if X is a square invertible matrix, then solve(X) returns its inverse.

## Ploting Data (Plot1-4)
* <b>Dataset</b>: <a href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip">Electric power consumption</a> [20Mb]

* <b>Description</b>: Measurements of electric power consumption in
one household with a one-minute sampling rate over a period of almost
4 years. Different electrical quantities and some sub-metering values
are available.


The following descriptions of the 9 variables in the dataset are taken
from
the <a href="https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption">UCI
web site</a>:

<ol>
<li><b>Date</b>: Date in format dd/mm/yyyy </li>
<li><b>Time</b>: time in format hh:mm:ss </li>
<li><b>Global_active_power</b>: household global minute-averaged active power (in kilowatt) </li>
<li><b>Global_reactive_power</b>: household global minute-averaged reactive power (in kilowatt) </li>
<li><b>Voltage</b>: minute-averaged voltage (in volt) </li>
<li><b>Global_intensity</b>: household global minute-averaged current intensity (in ampere) </li>
<li><b>Sub_metering_1</b>: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). </li>
<li><b>Sub_metering_2</b>: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. </li>
<li><b>Sub_metering_3</b>: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.</li>
</ol>


## Course 3, Week 4:- Peer-graded Assignment: Getting and Cleaning Data Course Project

### Explaination for [run_analysis.R](https://github.com/joysn/coursera-GettingandCleaningData/blob/master/run_analysis.R)

#### Major Steps
- Step 0: Load Packages   
       library("data.table")  
       library("reshape2")  

- Step 1: Download and unzip the dataset -   
   Using *download.file*  
   Inzip the file using *unzip*  
       
- Step 2: Get the wanted feature list and its labels -  
   Load *features.txt* and *activity_labels.txt*  
   Look for *mean|std* from *features.txt*  
       
- Step 3: Load Data (TRAIN) -   
   Load using *read.table* - *X_train.txt, Y_train.txt, subject_train.txt* \[Contains the subjectnum details\]    
   Merge them using *cbind*  

- Step 4: Load Data (TEST) -   
   Load using *read.table* - *X_test..txt Y_test.txt, subject_test.txt* \[Contains the subjectnum details\]  
   Merge them using *cbind*  

- Step 5: Merge TRAIN & TEST -   
   Using *rbind*  
       Using ```rbind```  
- Step 6: Create factors -   
   Activity and Subject  
   
   *factor(final_ds[, "Activity"], levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])*  
   
   *as.factor(final_ds[, "SubjectNum"])*  

- Step 7: Create the final dataset file -   
   
   Using *write.table*  
       

[Cookbook](https://github.com/joysn/R-Programs/blob/master/cookbook.md)  

[The Script File](https://github.com/joysn/R-Programs/blob/master/run_analysis.R)  
[The output file](https://github.com/joysn/R-Programs/blob/master/tidyData.txt)  
