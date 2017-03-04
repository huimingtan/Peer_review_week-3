library(plyr)

setwd("C:/Users/user/Desktop/Coursera/course3/week4/UCI HAR Dataset")
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_test<-read.table("./test/subject_test.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
subject_train<-read.table("./train/subject_train.txt")
Combine_x_test_train<-rbind(x_test,x_train)
Combine_y_test_train<-rbind(y_test,y_train)
Combine_subject_test_train<-rbind(subject_test,subject_train)
colnames(Combine_subject_test_train)<-"Subject_number"
colnames(Combine_y_test_train)<-"Number"

feature<-read.table("features.txt")
feature<-setNames(feature,c("V1"="Number","V2"="Name"))
colnames(Combine_x_test_train)<- feature$Name

act_labels<-read.table("./activity_labels.txt")
act_labels<- setNames(act_labels,c("V1"="Number","V2"="Activity"))

Combine_all<-cbind(Combine_x_test_train,Combine_y_test_train,
                   Combine_subject_test_train)

Mean_STD_table<-grep("mean|std|Mean",names(Combine_all),value=TRUE)
Add_columns<-union(c("Subject_number","Number"),Mean_STD_table)
Data_Mean_STD_table<-Combine_all[,Add_columns]

Data_all<-join(Data_Mean_STD_table,act_labels,by="Number",match="first")
Data_all<-Data_all[,-1]

names(Data_Mean_STD_table) <- gsub("Acc", "Acceleration", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("^t", "Time", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("^f", "Frequency", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("BodyBody", "Body", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("mean", "Mean", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("std", "Std", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("Freq", "Frequency", names(Data_Mean_STD_table))
names(Data_Mean_STD_table) <- gsub("Mag", "Magnitude", names(Data_Mean_STD_table))

write.table(Data_all,"TidyData.txt",row.name=FALSE)
