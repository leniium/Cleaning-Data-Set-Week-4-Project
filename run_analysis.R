#---- Please download and unzip data here. This step could be scripted but preffered to omit those steps. 
library(data.table)
library(dplyr)

#----- START Reading Data -----
activities<-read.table("./activity_labels.txt",col.names = c("activity_no","activity"))
features<-read.table("./features.txt", col.names = c("feature_no","feature"))
training<-read.table("./train/X_train.txt",col.names = features$feature)
training$activity_no<-as.numeric(unlist((read.table("./train/Y_train.txt",col.names = "activity_no"))))
row.names(training) = paste("training ",row.names(training))
test<-read.table("./test/X_test.txt",col.names = features$feature)
test$activity_no<-as.numeric(unlist((read.table("./test/Y_test.txt",col.names = "activity_no"))))
row.names(test) = paste("test ",row.names(test))
data = rbind(test,training)
#------ END Reading Data --------
#----- START Extracting Data -----
meanIndex = grep("[Mm]ean",names(data))
stdIndex = grep("[Ss]td",names(data))
extractedData = cbind(data[,meanIndex],data[,stdIndex],data$activity_no)
colnames(extractedData) = c(colnames(data)[meanIndex],colnames(data)[stdIndex],"activity_no")

#------ END Extracting Data ------
#----- START Creating NEW Data Set -----
splittedData = split(extractedData,extractedData$activity_no)
tidyData = unlist(lapply(splittedData,colMeans,na.rm = TRUE))
names(tidyData) = paste("Average.",names(tidyData))
for (i in 1:6) {
        names(tidyData) = sub(as.character(i),activities$activity[i],names(tidyData))       
}

#------ END Creating New Data Set ------
write.table(tidyData, "TidyData.txt", col.name=FALSE)
