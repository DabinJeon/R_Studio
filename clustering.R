
teens<-read.csv("snsdata.csv")
str(teens)

table(teens$gender) #NA�� ����

table(teens$gender, useNA = "ifany")

summary(teens)


summary(teens$age)
#�����л� : 13���̻�~20���̸�
teens$age<-ifelse(teens$age>=13 & teens$age<20, teens$age, NA)
summary(teens$age)

#������ "F"�̸鼭 ������ "NA"�� �ƴ϶��
teens$female<-ifelse(teens$gender=="F" & !is.na(teens$gender), 1, 0)
table(teens$female)#�������� �ƴ����� ���� ���� ����
# 0(����+NA)     1(����) 
# 7946          22054 
teens$no_gender<-ifelse(is.na(teens$gender),1,0)
table(teens$no_gender) #NA 2724


table(teens$gender, useNA = "ifany")

table(teens$female)

table(teens$no_gender)

mean(teens$age)

mean(teens$age,na.rm=TRUE) #17.25243

#�� �����⵵�� ���� age�� ���
aggregate(data=teens,age~gradyear, mean ,na.rm=TRUE)
#grdyear �÷����� �׷��� -> �� �׷쿡 ���� age ���� ���

#grdyear ���� age�� ���� ���
ave_age<-ave(teens$age, teens$gradyear, FUN=function(x) mean(x,na.rm=TRUE))
ave_age #18.65586, ..., 

teens$age<-ifelse(is.na(teens$age), ave_age, teens$age)
teens$age

summary(teens$age)

library(stats) #Ŭ�����͸� ���� �Լ��� �ִ� ��Ű��

str(teens)
interests<-teens[5:40]

#ǥ��ȭ�۾�
#z����ǥ��ȭ(sclae) : Ư¡�� ���:0, ǥ������:1
interests_z<-as.data.frame(lapply(interests,scale))#interest�����Ϳ� scale�Լ� ����
#lapply:���(����Ʈ�� ���� -> ������������ ��ȯ)
set.seed(2345) #��������
#kmeans(interests_z)
teen_clusters<-kmeans(interests_z,5) #5���� Ŭ������ ����
teen_clusters

#������ ����:36����(basketball,...,drugs)
#36���� ������ ��(������)�� 3��������.
#������ 5���� �׷���
#�� �׷츶�� centroid����(5��)

#(3,5)
#(0.4815795, 0.44, ...., 0.39 ):36���� �������� �� 
#�׷��� ��տ� ���� ��ǥ

teen_clusters$centers #�߽���

#��� �Ź��� -> �Ź���� ��ũ����(10��)
#->��ġ/��ȸ -> ���¼� �и� -> ���ֻ��� �ܾ�
#��/��/�ߵ�
#���������Ƿ�

teens$cluster<- teen_clusters$cluster

teen_clusters$cluster

teens[1:5,c("cluster", "gender", "age", "friends")]

aggregate(data=teens, age~cluster ,mean)

#�� �׷쿡 ���ϴ� ���� ����
teens$female
aggregate(data=teens, female~cluster ,mean)

#�� �׷쿡 ���� ģ������ ��� ���
aggregate(data=teens, friends~cluster ,mean)