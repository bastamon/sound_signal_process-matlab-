function rate=svmclassfiction(samples,test)   %构造五种情感分类器
train1=samples(1:60,:);%用来构造生气-高兴分类模型训练样本
train2=[samples(1:30,:);samples(61:90,:)];%用来构造生气-中性分类模型训练样本
train3=[samples(1:30,:);samples(91:120,:)];%用来构造生气-悲伤分类模型训练样本
train4=[samples(1:30,:);samples(121:150,:)];%用来构造生气-害怕分类模型训练样本
train5=[samples(31:60,:);samples(61:90,:)];%用来构造高兴-中性分类模型训练样本
train6=[samples(31:60,:);samples(91:120,:)];%用来构造高兴-悲伤分类模型训练样本
train7=[samples(31:60,:);samples(121:150,:)];%用来构造高兴-害怕分类模型训练样本
train8=[samples(61:90,:);samples(91:120,:)];%用来构造中性-悲伤分类模型训练样本
train9=[samples(61:90,:);samples(121:150,:)];%用来构造中性-害怕分类模型训练样本
train10=[samples(91:120,:);samples(121:150,:)];%用来构造悲伤-害怕分类模型训练样本
for i=1:30                %正类样本标记
    trainlabel(i)=1;
end
for i=30:60               %负类样本标记
    trainlabel(i)=-1;
end
trainlabel=trainlabel';
svmStruct(1)= svmtrain(train1,trainlabel);    %构造两类SVM分类模型
svmStruct(2)= svmtrain(train2,trainlabel);    
svmStruct(3)= svmtrain(train3,trainlabel);   
svmStruct(4)= svmtrain(train4,trainlabel);    
svmStruct(5)= svmtrain(train5,trainlabel);    
svmStruct(6)= svmtrain(train6,trainlabel);    
svmStruct(7)= svmtrain(train7,trainlabel);   
svmStruct(8)= svmtrain(train8,trainlabel);    
svmStruct(9)= svmtrain(train9,trainlabel);    
svmStruct(10)= svmtrain(train10,trainlabel);  
sumang=0; %生气情感正确识别个数
sumhap=0; %高兴情感正确识别个数
sumneu=0; %中性情感正确识别个数
sumsad=0; %悲伤情感正确识别个数
sumfea=0; %害怕情感正确识别个数
for i=1:100
    for k=1:5
        votes(k)=0;   %多个SVM分类器将待测样本规定为某一类别个数
    end
    for j=1:10
       C(j) = svmclassify(svmStruct(j),test(i,:));
    end
    if(C(1)==1)    %第一个判决器结果
         votes(1)=votes(1)+1;  %生气情感获得票数
    elseif(C(1)==-1)
         votes(2)=votes(2)+1;  %高兴情感获得票数
    end
    if(C(2)==1)    %第二个判决器结果
         votes(1)=votes(1)+1;  %生气情感获得票数
    elseif(C(2)==-1)
         votes(3)=votes(3)+1;  %中性情感获得票数
    end
    if(C(3)==1)    %第三个判决器结果
         votes(1)=votes(1)+1;  %生气情感获得票数
    elseif(C(3)==-1)
         votes(4)=votes(4)+1;  %悲伤情感获得票数
    end
     if(C(4)==1)    %第四个判决器结果
         votes(1)=votes(1)+1;  %生气情感获得票数
    elseif(C(4)==-1)
         votes(5)=votes(5)+1;  %害怕情感获得票数
     end
     if(C(5)==1)    %第五个判决器结果
         votes(2)=votes(2)+1;  %高兴情感获得票数
    elseif(C(5)==-1)
         votes(3)=votes(3)+1;  %中性情感获得票数
     end
     if(C(6)==1)    %第六个判决器结果
         votes(2)=votes(2)+1;  %高兴情感获得票数
    elseif(C(6)==-1)
         votes(4)=votes(4)+1;  %悲伤情感获得票数
     end
     if(C(7)==1)    %第七个判决器结果
         votes(2)=votes(2)+1;  %高兴情感获得票数
    elseif(C(7)==-1)
         votes(5)=votes(5)+1;  %害怕情感获得票数
     end
     if(C(8)==1)    %第八个判决器结果
         votes(3)=votes(3)+1;  %中性情感获得票数
     elseif(C(8)==-1)
         votes(4)=votes(4)+1;  %悲伤情感获得票数
     end
     if(C(9)==1)    %第九个判决器结果
         votes(3)=votes(3)+1;  %中性情感获得票数
     elseif(C(9)==-1)
        votes(5)=votes(5)+1;  %害怕情感获得票数
     end
     if(C(10)==1)    %第十个判决器结果
         votes(4)=votes(4)+1;  %悲伤情感获得票数
     elseif(C(10)==-1)
         votes(5)=votes(5)+1;  %害怕情感获得票数
    end
   if(i>=1&&i<=20&&votes(1)>votes(2)&&votes(1)>votes(3)&&votes(1)>votes(4)&&votes(1)>votes(5))
       sumang=sumang+1;  %生气类样本正确识别个数
   end
   if(i>=21&&i<=40&&votes(2)>votes(1)&&votes(2)>votes(3)&&votes(2)>votes(4)&&votes(2)>votes(5))
       sumhap=sumhap+1;  %高兴类样本正确识别个数
   end
    if(i>=41&&i<=60&&votes(3)>votes(2)&&votes(3)>votes(1)&&votes(3)>votes(4)&&votes(3)>votes(5))
       sumneu=sumneu+1;  %中性类样本正确识别个数
    end
    if(i>=61&&i<=80&&votes(4)>votes(1)&&votes(4)>votes(2)&&votes(4)>votes(3)&&votes(4)>votes(5))
       sumsad=sumsad+1;  %悲伤类样本正确识别个数
    end
    if(i>=81&&i<=100&&votes(5)>votes(1)&&votes(5)>votes(3)&&votes(5)>votes(4)&&votes(5)>votes(2))
       sumfea=sumfea+1;  %害怕类样本正确识别个数
    end
end
rate=[sumang/20,sumhap/20,sumneu/20,sumsad/20,sumfea/20];
rate
bar(rate,0.5);
set(gca,'XTickLabel',{'生气','高兴','中性','悲伤','害怕'});
ylabel('识别率');
xlabel('五种基本情感');