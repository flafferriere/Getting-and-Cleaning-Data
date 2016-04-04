library(dplyr)

# read all Data and assign to individual tables
TestSubject<-read.table("./test/subject_test.txt", header = FALSE)
TestX<-read.table("./test/X_test.txt", sep = "", header = FALSE)
Testy<-read.table("./test/y_test.txt", header = FALSE)

TrainSubject<-read.table("./train/subject_train.txt", header = FALSE)
TrainX<-read.table("./train/X_train.txt", sep = "", header = FALSE)
Trainy<-read.table("./train/y_train.txt", header = FALSE)

Features<-read.table("features.txt", sep = "",header = FALSE)
Activities<-read.table("activity_labels.txt", sep = "", header = FALSE)

# Extract only the mean and std columns from the Features data
FeaturesSelect<-subset(Features,grepl("mean\\(\\)",as.character(Features$V2)) | grepl("std\\(\\)",as.character(Features$V2)))

# Concatenate Datasets columns for Test and for Train data
Test<-cbind(TestSubject,Testy,TestX)
Train<-cbind(TrainSubject,Trainy,TrainX)

# Concatenate Datasets rows of Test and Train data
Data<-rbind(Test,Train)

# keep only the mean and std column
Data<-Data[,c(1,2,FeaturesSelect$V1+2)]

# Assign correct labels for columns of DATA and Activities
colnames(Data)<-c("Subject","ActivityCode", as.character(FeaturesSelect$V2))
colnames(Activities)<-c("ActivityCode","Activity")

# Merge Data with Activity
DataM<-merge(Data, Activities)
DataM$ActivityCode=NULL

#Compute Stats and output
stat = group_by(DataM, Subject, Activity) %>% summarise_each(funs(mean))
write.table(stat, 'Stat.txt', row.names = F)

