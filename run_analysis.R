setwd("C://Users//lena_/Documents//Coursera//Coursera Data Scientist/Getting and Cleaning Data//Week 4//Project")
#---- Please download and unzip data here. This step could be scripted but preffered to omit those steps. 
library(data.table)
library(dplyr)

#----- START Reading Data -----
activities<-read.table("./activity_labels.txt",col.names = c("activity_no","activity"))
features<-read.table("./features.txt", col.names = c("feature_no","feature"))
training<-read.table("./train/X_train.txt",col.names = features$feature)
training$activity_no<-as.numeric(unlist((read.table("./train/Y_train.txt" , col.names = "activity_no"))))
training$subject_no<-as.numeric(unlist((read.table("./train/subject_train.txt" , col.names = "subject_no"))))
row.names(training) = paste("training ",row.names(training))
test<-read.table("./test/X_test.txt",col.names = features$feature)
test$activity_no<-as.numeric(unlist((read.table("./test/Y_test.txt" , col.names = "activity_no"))))
test$subject_no<-as.numeric(unlist((read.table("./test/subject_test.txt", col.names = "subject_no"))))
row.names(test) = paste("test ",row.names(test))
data = rbind(test,training)
#------ END Reading Data --------
#-----START LABELING DATA -----
label_func <- function(x) activities[x,2]
data$activity_label <- sapply(data$activity_no, label_func)
names(data)[1:561]=as.character(features[,2])

#-----END LABELING DATA -------
#----- START Extracting Data -----
Index = grep("[Mm]ean|[Ss]td",names(data))
extractedData = cbind(data[,Index],data$activity_label,data$subject_no)
colnames(extractedData) = c(colnames(data)[Index],"activity_label","subject_no")

#------ END Extracting Data ------
#----- START Creating NEW Data Set -----
tidyData <- melt(extractedData, id=c("subject_no","activity_label"), measure.vars = names(extractedData)[1:86])
tidyData <- group_by(tidyData, subject_no)
tidyData <- group_by(tidyData, activity_label, add=TRUE)
tidyData <- group_by(tidyData, variable, add=TRUE)
#------ END Creating New Data Set ------
write.table(tidyData, "TidyData.txt", row.name=FALSE)