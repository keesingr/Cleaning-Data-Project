# Cleaning-Data-Project

This repository contains code necessary to download human subject accelerometer data and modify it to produce a "pretty" data set. The source for these files is the following repository: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Further instructions on the contents of the repository are available at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The file Accelerometer_Data_Codebook.Rmd contains an R Markdown file containing a codebook describing each of the variables in this dataset. Accelerometer_Data_Codebook.html shows the codebook in html format.

The file run_analysis.R contains R code that will download files and unzip files from the repository above, extract the variables described in the codebook, and produce a pretty data file titled "Accelerometer_Data.txt" that contains means values for each of the fields in the codebook for each of the subjects and each activity. This file should be downloaded and installed in a directory with write access. 

The R function getActivityFiles() will download and unzip the files from the archive. The function getPrettyActivityData() will return a data frame with the variables described in the codebook. The function createPrettyActivityFile() will create a file called "Accelerometer_Data.txt" that contains a pretty data set with the means for each variable for each subject and then for each activity


