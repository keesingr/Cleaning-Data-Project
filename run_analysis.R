subActivityName <- function(activity){
  # Change integer codes to descriptive activity names
  if(activity == 1) return ("Walking")
  else if (activity == 2) return ("Walking_upstairs")
  else if (activity == 3) return ("Walking_downstairs")
  else if (activity == 4) return ("Sitting")
  else if (activity == 5) return ("Standing")  
  else if (activity == 6) return ("Laying")  
}

getMeanAndStdColumns <- function(){
  ## Read a file of column descriptors and provide a data frame of 
  ## column numbers and names for columns containing "mean" or "std" in the name. 
    featureNameVector <- read.table("UCI HAR Dataset/features.txt")
    count <- 0
    ColNames <- NULL
    ColNumbers <- NULL
    for (theRow in featureNameVector$V2){
    count <- count + 1
    if (grepl("mean()", theRow, fixed=TRUE) || grepl("std()", theRow, fixed=TRUE)) {
        ColNames <- c(ColNames, theRow)
        ColNumbers <- c(ColNumbers, count)
      }
    }
    ColNames <- gsub("[[:punct:]]", "", ColNames)         #Remove special characters from names
    ColInfo <- data.frame(ColNames, ColNumbers, stringsAsFactors = FALSE)
}

getMergedDataSets <- function(){
  # returns a data frame containing merged data sets from train and test
  # with subject and activity information added for each record
  
    allData <- read.table("UCI HAR Dataset/train/X_train.txt")            # Read in the table of training data
    addedColumn <- read.table("UCI HAR Dataset/train/subject_train.txt")  # Read in column of subject names
    colnames(addedColumn) <- ("Subject")                  # Name the resulting column subject
    allData <- cbind(allData, addedColumn)                # Add the column to the data frame
    addedColumn <- read.table("UCI HAR Dataset/train/y_train.txt")        # Read in column of conditions 
    addedColumn <- adply(addedColumn, 1, subActivityName) # Translate coded activities to names
    colnames(addedColumn) <- ("Activity")                # Name the resulting column condition
    allData <- cbind(allData, addedColumn)                # Add the column to the data frame
    
    testData <- read.table ("UCI HAR Dataset/test/X_test.txt")
    addedColumn <- read.table("UCI HAR Dataset/test/subject_test.txt")    # Read in column of subject names
    colnames(addedColumn) <- ("Subject")                  # Name the resulting column subject
    testData <- cbind(testData, addedColumn)              # Add the column to the data frame
    addedColumn <- read.table("UCI HAR Dataset/test/y_test.txt")          # Read in column of conditions 
    addedColumn <- adply(addedColumn, 1, subActivityName) # Translate coded activities to names
    colnames(addedColumn) <- ("Activity")                 # Name the resulting column condition
    testData <- cbind(testData, addedColumn)              # Add the column to the data frame  

    allData <- rbind(allData, testData)
}

subsetandNameColumns <- function(fullDataSet, columnsToSubset){
# Builds a new data frame with only columns of fullDataSet in columnsToSubset
# as well as subject column and activity column, with descriptive activity names
  
  newDataSet <- data.frame(x = rep(NA, length(fullDataSet[,1])))    # Build data frame of right dimensions with 
                                                                    # one row of junk NAs.
  columnNames <- NULL
  for (i in 1:length(columnsToSubset[,1])){
    newDataSet <- cbind(newDataSet, fullDataSet[,columnsToSubset$ColNumbers[i]])
    columnNames <- c(columnNames, columnsToSubset$ColNames[i])      # Add column name to list
  }
  newDataSet[,1] <- NULL                                            # Remove first column, which was junk NAs 
  newDataSet <- cbind(newDataSet, fullDataSet$Subject)              # Add in column of subjects
  columnNames <- c(columnNames, "Subject")                          # Add column name to list
  newDataSet <- cbind(newDataSet, fullDataSet$Activity)             # Add in column of conditions
  columnNames <- c(columnNames, "Activity")                         # Add column name to list

  colnames(newDataSet) <- columnNames                               # Rename with correct column names
  #fnewDataSet$Activity <- lapply(newDataSet$Activity, subActivityName) # Add descriptive activity names
  return(newDataSet)
}

getActivityFiles <- function () {
  # Downloads and unzips activity files from UCI website
  temp <- tempfile()
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, temp)
  unzip(temp)
  unlink(temp)
}

getPrettyActivityData <- function(){
  # Returns a dataset containing only desired columns
  desiredColumns <- getMeanAndStdColumns()
  mergedDataset <- getMergedDataSets ()
  prettyData <- subsetandNameColumns(mergedDataset, desiredColumns)
}

createPrettyActivityFile <- function(){
  accelerometerData <- getPrettyActivityData()
  activityMeans <- ddply(accelerometerData, "Activity", colwise(mean))
  subjectMeans <- ddply(accelerometerData, "Subject", colwise(mean))
  write.table(subjectMeans, "Accelerometer_Data.txt", row.names = FALSE)
  write.table(activityMeans, "Accelerometer_Data.txt", row.names = FALSE, append = TRUE)
}