# #�̻�ġ ����, R�ð�ȭ, 
# install.packages("rJava") 
# install.packages("memoise") 
# install.packages("KoNLP") 
# #Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk-12") 
# Sys.getenv("JAVA_HOME")
# # ��Ű�� �ε�
# library(KoNLP) 
# #�����߻��� => https://www.java.com/en/download/manual.jsp
# ## Checking user defined dictionary! 
# library(dplyr) 
# useNIADic()

#�̻�ġ ����
#������ �� ���� ��(�߸��Է�):���� �������� -5 => ���� ó��
#�ش����� �� ������ 300kg => ��������� ���ؼ� ó��

#�̻�ġ ����
outlier<-data.frame(sex=c(1,2,1,3,2,1),
                    score=c(5,4,3,4,2,6))
outlier

#�̻�ġ Ȯ��
table(outlier$sex)

table(outlier$score)

#����ó��(���� 3 -> NA)
outlier$sex<-ifelse(outlier$sex==3,NA,outlier$sex)
outlier

#score�� 5���� ������ NA
outlier$score<-ifelse(outlier$score>5,NA,outlier$score)
outlier

library(dplyr)

#����ġ �����ϰ� �м�
outlier %>% 
  filter(!is.na(sex) & !is.na(score)) %>% 
  group_by(sex) %>% 
  summarise(mean_score=mean(score))

#sex�÷����� �׷�ȭ -> �� �׷캰 score ���
#is.na(outlier$sex) => FALSE FALSE FALSE  TRUE FALSE FALSE


#2. �ش����� ���� ���� �̻�ġ ó��
#��������� ��� ��� => ���� ó��
#�Ǵ� ����-������ �Ǵܱ���(���� 40~150kg ����� �̻�ġ)
#�Ǵ� ����-����� �Ǵܱ���
#(������ 0.3%�ش�ġ or boxplot���� 1.5 IQR ��� ���)

library(ggplot2)
str(mpg)

boxplot(mpg$hwy)

boxplot(mpg$hwy)$stats
#stats������� [1]���� [5]�� ���� �ش�ġ ��谪
#[1],[5]:����/���� �ش�ġ ���,[2]:1�������
#[3]:������, [4]:3�������

mpg$hwy<-ifelse(mpg$hwy<12 | mpg$hwy>37, NA, mpg$hwy)
table(is.na(mpg$hwy)) #�̻�ġ�� �� 3�� �˻���
#library(help = "stats")

#�̻�ġ�� ������ ������ �����Ϳ��� drv�� ���� 
#�׷�ȭ -> hwy�� ���� ���
mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy,na.rm=T))

mpg[c(10,14,58,93), "drv"]<-"k" #�̻�ġ �Ҵ�
mpg[c(29,43,129,203), "cty"]<-c(3,4,39,42) #�̻�ġ �Ҵ�
#boxplot(mpg$cty)$stats#�ش�ġ ���: <9, 26<

#�䱸����:������ĺ��� ���� ���� ��� �ٸ��� �м�?
#1. drv�� �̻�ġ Ȯ��. �̻�ġ ������ ����ġ ó�� -> �̻�ġ��
#���ŵƴ��� Ȯ��.(%in% ���)

#�̻�ġ Ȯ��
table(mpg$drv)
#�̻�ġ�� NAó��
mpg$drv<-ifelse(mpg$drv %in% c("4","f","r"), mpg$drv, NA)
#�̻�ġ Ȯ��
table(mpg$drv)

#2. boxplot�� ����Ͽ� cty�÷��� �̻�ġ�� �ִ��� Ȯ���ϼ���
boxplot(mpg$cty)$stats
mpg$cty<-ifelse(mpg$cty<9 | mpg$cty>26, NA, mpg$cty)
boxplot(mpg$cty)

#is.na(mpg$drv)
#is.na(mpg$cty)
#�̻�ġ�� ������ ���� drv���� cty����� ���غ�����
#dplyr����(ctrl + shift + m)���� �ۼ��� ��
mpg %>% 
  filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(cty))
  
#���׷���(�ð迭:ȯ��,�ְ�����...)
economics
str(economics)

ggplot(data=economics, aes(x=date, y=psavert))+geom_line()

ggplot(data=mpg, aes(x=drv, y=hwy))+geom_boxplot()
#drv�� ���� hwy ���

mpg$class
table(mpg$class)
#compact, subcompact, suv �ڵ����� ���� cty���� ��

class_mpg<-mpg %>% 
  filter(class %in% c('compact', 'subcompact', 'suv'))

ggplot(data=class_mpg, aes(x=class, y=cty))+geom_boxplot()

#geom_�Լ�
#�Լ�:point(), bar(), line(), boxplot(), col()


#r�����ͺм� ������Ʈ

install.packages("foreign")
library(foreign)#SAS, SPSS �����ͼ��� ���� �� ���
library(dplyr)
library(ggplot2)
install.packages("readxl")
library(readxl)

raw<-read.spss(file="2015_data.sav", to.data.frame=T)
str(raw)
#2006~2015�⵵, �� ���� ����Ȱ�� ���� ����
#����Ȱ��, ��Ȱ, ... ���� -> �м�

#1. ������ ���� �޿� ����
# 1) ����Ȯ��-class�Լ�, table�Լ�
# 2) ��ó��(�̻�ġ �� ó��)
# 3) �ð�ȭ-> ��
# 
# #2. ���̿� ������ ����
# 1) ����Ȯ��-class�Լ�, table�Լ�
# 2) ��ó��(�̻�ġ �� ó��)
# 3) �ð�ȭ-> ��


head(raw)
str(raw)
View(raw)

raw<-rename(raw, 
            sex=h10_g3, #����
            birth=h10_g4, #�¾ ����
            marriage=h10_g10, #ȥ�� ����
            religion=h10_g11, #����
            income=p1002_8aq1, #���޿�
            code_job=h10_eco9, #���� �ڵ�
            code_region=h10_reg7) #���� �ڵ�

#��ó�� -> ���ǥ �ۼ� -> �׷��� �ۼ�

#���� ���� Ȯ�� �� ��ó��
class(raw$sex) #"numeric"
table(raw$sex) #1,2�� ����

#���� �������� 9�� �־��ٰ� �����ϰ� �̻�ġ ���� ó��
raw$sex<-ifelse(raw$sex==9, NA, raw$sex)

#����ġ Ȯ��
table(is.na(raw$sex))

#���� �׸� �̸� : 1->male, 2 -> female
raw$sex<-ifelse(raw$sex==1, "male","female")
table(raw$sex)
qplot(raw$sex)


#���� ���� Ȯ��, ��ó��
class(raw$income)#numeric
summary(raw$income)#������
qplot(raw$income)

qplot(raw$income)+xlim(0,1000)

boxplot(raw$income)
boxplot(raw$income)$stats
#608���� �ʰ��� �̻�ġ�� �����ϰ� ��ó��

#�̻�ġ ����ġ ó��
raw$income<-ifelse(raw$income %in% c(0,9999),NA,raw$income)
#�޿� 0���̰ų� 9999������ ����ġ

#10 %in% c(10,20) #TRUE
#15 %in% c(10,20) #FALSE

table(is.na(raw$income))
#�޿��� 0�� �Ǵ� 9999������ 12044�� ->NaNó��->�м� ����

#���� �޿� ���ǥ �ۼ�

sex_income<-raw %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income=mean(income))
sex_income
# sex   mean_income
# female   190
# male     220
  
ggplot(data=sex_income, aes(x=sex, y=mean_income))+geom_col()


#��� ���̿� ���� ���� �޿� ����
class(raw$birth)#"numeric"
summary(raw$birth)#������ ����
qplot(raw$birth)
table(is.na(raw$birth))

#��������(�Ļ�����):feature engineering => ����->ó��->�Ļ�����
raw$age<-2015-raw$birth+1
summary(raw$age)
qplot(raw$age)

#x��:age, y��:income �ð�ȭ
#�� ���̿� ���� ���޿� ���� ����� �ð�ȭ
age_income<-raw %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income =mean(income))

ggplot(data=age_income, aes(x=age, y=mean_income))+geom_line()

#"young","middle", "old"
raw<-raw %>% 
  mutate(ageg=ifelse(age<30, "young",
         ifelse(age<=59,"middle","old")))

table(raw$ageg)
qplot(raw$ageg)

#ageg ���� �������� ���ɴ뺰 �޿� ���
ageg_income<-raw %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income=mean(income))
ageg_income

ggplot(data=ageg_income, aes(x=ageg,y=mean_income))+
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))


#���ɴ� �� ������ ���� ���޿� ���� �м�
sex_income<-raw %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income=mean(income))
#1�� �׷�ȭ ���� : ageg
#2�� �׷�ȭ ���� : sex
sex_income

ggplot(data=sex_income, aes(x=ageg, y=mean_income, fill=sex))+
  geom_col()+
  scale_x_discrete(limits=c("young","middle","old"))


ggplot(data=sex_income, aes(x=ageg, y=mean_income, fill=sex))+
  geom_col(position="dodge")+
  scale_x_discrete(limits=c("young","middle","old"))


#�� �׷����� ����,���� �޿� ����
sex_age<-raw %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income=mean(income))


ggplot(data=sex_age, aes(x=age, y=mean_income, col=sex))+
  geom_line()

raw$code_job
table(raw$code_job)

list_job<-read_excel("Koweps_Codebook.xlsx",col_names = T, sheet=2)
list_job
dim(list_job)
str(raw)
str(list_job)

#code_job�� �������� raw�� list_job�� ����
raw<-left_join(raw, list_job, id="code_job")
str(raw)
#raw$job
#raw$code_job


raw %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(20)


#���� 10���� �������� ���� ��� �޿��� �ð�ȭ

job_income<-raw %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income=mean(income))

job_income

top10<-job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
top10

ggplot(data=top10, aes(x=reorder(job,mean_income),y=mean_income))+
  geom_col()+
  coord_flip()



#���� ���� �� ���� 10���� ����(��������)
job_male<-raw %>% 
  filter(!is.na(job) & sex=="male") %>% 
  group_by(job) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count)) %>% 
  head(10)


# job       count
# ����       100

job_female<-raw %>% 
  filter(!is.na(job) & sex=="female") %>% 
  group_by(job) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count)) %>% 
  head(10)
job_female




















