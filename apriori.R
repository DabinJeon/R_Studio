# 1. �ŷ� ������ Ư¡ �ľ�
# 2. ������ �� ������ ã��
# 3. ���� �ĺ�
# => ���� ��Ģ
# 
# ���� ��Ģ ���� �о�
# 1)��ٱ��� �м�
# 2)DNA ����, ���� ���� �˻�
# 3)��⼺ ����, ���� �̿� ���� �Ǵ� �Ƿ�� û�� ����
# 4)���� ���� �ߴ�, ��ǰ ����� ����Ǵ� �ൿ�� ����
# 
# ��ٱ��� �м� -> ������Ģ(���������� ������ ���� ����) ����
# 
# 
# {����, ����, ����} -> {��}
#     (����)LHS -> RHS(���� ������ ���Ǵ� ���)
# *������ �ӿ� �����ִ� ���� �߰�
# 
# ���������� �˰�����
# 
# EX)��Ʈ���� �ǸŵǴ� ������ ���� �� 100������ ���,
# ������ ����=
# ��
# {��},{}
# ��,����
# {},{��},{����},{��,����}
# 
# {9999��}-> {��}
# 1315,1547,2326,6453,8633,5614,5345,7567,2345,8552,7460,6234,6345,1574,7571,6345,8569,2034,3211
# 
# ���� ������ �����δ� �������� �ʴ�
# ��������� ����� ���� �� ����

#������Ģ(Association rules)

install.packages("arules")
library(arules)
#groceries<-read.csv("groceries.csv") ����ϸ� �ȵ�
groceries<-read.transactions("groceries.csv",sep=",")
#�������� ������(9835*169)
groceries
summary(groceries)

inspect(groceries[1:5])

itemFrequency(groceries[,1:169]) #������

itemFrequencyPlot(groceries, support=0.1)
#�ּ� ������ 10% �̻� ���� ������ �ð�ȭ

itemFrequencyPlot(groceries, topN=20)
#������ �������������� ���� 20�� ������ t�Ӱ�ȭ

#������(�뷫 9800��*170��)

image(groceries[1:5])
#������(1��~5����� ���)


image(sample(groceries,100))
#���Ƿ� 100���� �ŷ������� ����

apriori(groceries)
#�ּ� ������ �Ӱ�ġ ����?�ּ� �ŷ� �Ǽ� ����
#�ּ� �Ϸ翡 5�� �ŷ��� �־�߸�, �� �����ۿ�
#���� ������Ģ ������ �ǹ̰� �����״� �ִ�.���
#�����ߴٸ�.... 150/10000 => 0.015������ �̻�

#�ŷڵ��� ������
#�ŷڵ�(����->����)=sup(����,����)/sup(����)=0.25
#conf(X->Y) = sup(X,Y) / sup(X)
#minlen:2�� ����,�ּ� 2�� �̻��� �������� ���� ��Ģ�� ����


groceryrules<-apriori(groceries, parameter = list(support=0.006,confidence=0.25, minlen=2))
# �Ϸ��ּ�2���ŷ�*30/ 10000 =0.006������ �̻� ������ ��Ģ ����

inspect(groceryrules[1:10])


summary(groceryrules)

# x->y,z
# x,y->z

inspect(sort(groceryrules, by="support")[1:5])
inspect(sort(groceryrules, by="confidence")[1:5])
inspect(sort(groceryrules, by="lift")[1:5])

#���� ȫ�� �������� �� �䱸����: berries -> ???

#subset() : ��Ģ -> ������Ģ
berryrules<-subset(groceryrules, items %in% "berries")
inspect(berryrules)

byrules<-subset(groceryrules, items %in% c("berries","yogurt"))
byrules
inspect(byrules)
#������ in�� �ּ� 1���� �������� ��Ģ���� �߰������ÿ� ����

#�κи�Ī
fruitrules<-subset(groceryrules, items %pin% c("fruit"))
fruitrules
inspect(fruitrules)

#������Ī: ��� �������� �ݵ�� �����ؾ���
by2rules<-subset(groceryrules, items %ain% c("berries","yogurt"))
by2rules
inspect(by2rules)

#������Ģ�� ���Ϸ� ����
write(groceryrules, file="groceryrules.csv",sep=",",row.names=FALSE)