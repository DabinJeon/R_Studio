sms_raw<-read.csv("sms_spam_ansi.txt",stringsAsFactors = FALSE)
sms_raw
sms_raw$text
str(sms_raw)
sms_raw$type<-factor(sms_raw$type)

table(sms_raw$type)

install.packages("tm")
library(tm)

# 1�ܰ� : ����ġ(corpus) ���� -> VCorpus

sms_corpus<-VCorpus(VectorSource(sms_raw$text)) #source ��ü�� ǥ���� �־�� ��
inspect(sms_corpus[1:2])

sms_corpus[1]
as.character(sms_corpus[[1]])

# �������� ������ �ѹ��� Ÿ�Ժ�ȯ
lapply(sms_corpus[1:2], as.character)

#�޼����� �ܾ�� �и� -> �ؽ�Ʈ �м�
# �� ����,�ϰ������� ������ �ܾ�� ����(��ҹ��� ������ �ܾ�)
# �ϰ������� �ҹ��ڷ� �޼����� ��ȯ

tolower("Hi")
sms_corpus_clean<-tm_map(sms_corpus,content_transformer(tolower))

#��������
sms_corpus_clean<-tm_map(sms_corpus_clean,removeNumbers)

#�ҿ�� ����
stopwords()
sms_corpus_clean<-tm_map(sms_corpus_clean,removeWords, stopwords())

# ������ ���Ű�
sms_corpus_clean<-tm_map(sms_corpus_clean,removePunctuation)

#wordStem �Լ� : ������� ����
#snowballC ��Ű�� �ȿ� �������
install.packages("SnowballC")
library(SnowballC)

wordStem(c("learn","learned","learns"))

sms_corpus_clean<-tm_map(sms_corpus_clean,stemDocument)

#�߰� ���� ����
sms_corpus_clean<-tm_map(sms_corpus_clean,stripWhitespace)

lapply(sms_corpus_clean[1:10], as.character)

sms_dtm<-DocumentTermMatrix(sms_corpus_clean) #tdm�� ������ִ� �Լ� 

# sms_dtm�� �Ʒÿ�� ����Ʈ ������ �и�
sms_dtm_train<-sms_dtm[2:4169,]
sms_dtm_test<-sms_dtm[4170:5559,]

sms_train_labels<-sms_raw[2:4169,]$type
sms_test_labels<-sms_raw[4170:5559,]$type

table(sms_train_labels)
table(sms_test_labels)

prop.table(table(sms_train_labels))

install.packages("wordcloud")
library(wordcloud)

wordcloud(sms_corpus_clean,min.freq=50,random.order =FALSE,colors = brewer.pal(8,"Dark2"))

spam<-subset(sms_raw,type=="spam")
ham<-subset(sms_raw,type=="ham")

wordcloud(spam$text, max.words = 40,scale = c(5,0.5))
wordcloud(ham$text, max.words = 40,scale = c(4,0.5))

#�������� ���̺꺣���� �к�⸦ �Ʒý�Ű�� ���� ��ȯ
sms_freq_words<-findFreqTerms(sms_dtm_train,5)

sms_dtm_freq_train<-sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test<-sms_dtm_test[,sms_freq_words]

#���̺� ������ �з���� ������ Ư¡���� �� �����Ϳ� ���� ����

# �󵵼��� 0�̸� "no" 0���� ũ�� "yes"
convert_counts<- function(x){
  x<-ifelse(x>0, "Yes","Np")
}

sms_train<-apply(sms_dtm_freq_train,MARGIN=2,convert_counts)
sms_test<-apply(sms_dtm_freq_test,MARGIN=2,convert_counts)

# ���̺� ������ ���� ����
install.packages("e1071")
library(e1071)

sms_classifier<-naiveBayes(sms_train,sms_train_labels)

#����
sms_test_predict<-predict(sms_classifier,sms_test)

install.packages("gmodels")
library(gmodels)

CrossTable(sms_test_predict,sms_test_labels,dnn=c('predictied','actual'),prop.chisq = FALSE,prop.t=FALSE,prop.r=FALSE)

sms_classifier2<-naiveBayes(sms_train,sms_train_labels,laplace = 1)
sms_test_predict2<-predict(sms_classifier2,sms_test)
CrossTable(sms_test_predict2,sms_test_labels,dnn=c('predictied','actual'),prop.chisq = FALSE,prop.t=FALSE,prop.r=FALSE)







