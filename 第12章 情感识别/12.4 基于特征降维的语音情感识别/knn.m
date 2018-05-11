function rate= knn(trainsample, test,k)
%训练样本trainsample
%test测试样本
sum1=0; %生气情感正确识别个数
sum2=0; %高兴情感正确识别个数
sum3=0; %中性情感正确识别个数
sum4=0; %悲伤情感正确识别个数
sum5=0; %害怕情感正确识别个数
summ=0; %正确识别个数
for x=1:100 %50个测试数据
   for y=1:150 %100个训练数据
       c=(test(x,:)-trainsample(y,:)).^2;
      Eudistance(y)=sqrt(sum(c(:))); 
      %欧氏距离
   end;
   [increase,index]=sort(Eudistance);%递增排序，index用来存储排序前 在Eudistance中的下标
   votes1=0;
   votes2=0;
   votes3=0;
   votes4=0;
   votes5=0;
   
   %%%投票
  
   for n=1:k%最近的k个训练数据点有投票权
      if index(1,n)<=30%第一类
       votes1=votes1+1;
      elseif index(1,n)>30&&index(1,n)<=60%第二类
       votes2=votes2+1;    
      elseif index(1,n)>60&&index(1,n)<=90%第三类
       votes3=votes3+1;   
      elseif index(1,n)>91&&index(1,n)<=120%第四类
       votes4=votes4+1; 
      elseif index(1,n)>120&&index(1,n)<=150%第五类
       votes5=votes5+1; 
      end
   end
   %%投票结果
   if votes1>=votes2&&votes1>=votes3&&votes1>=votes4&&votes1>=votes5  %识别为生气
       result=1;
   elseif  votes2>=votes1&&votes2>=votes3&&votes2>=votes4&&votes2>=votes5 %识别为高兴
       result=2;
   elseif  votes3>=votes1&&votes3>=votes2&&votes3>=votes4&&votes3>=votes5 %识别为中性
       result=3;
    elseif  votes4>=votes1&&votes4>=votes2&&votes4>=votes3&&votes4>=votes5 %识别为悲伤
       result=4;
     elseif  votes5>=votes1&&votes5>=votes2&&votes5>=votes4&&votes5>=votes3 %识别为害怕
       result=5;
   end
    if (x<=20&&result==1)%正确识别为生气个数
        sum1=sum1+1;
    elseif(x>20&&x<=40&&result==2)%正确识别为高兴个数
        sum2=sum2+1;
    elseif(x>40&&x<=60&&result==3)%正确识别为中性个数
        sum3=sum3+1;
     elseif(x>60&&x<=80&&result==4)%正确识别为悲伤个数
        sum4=sum4+1;
     elseif(x>80&&x<=100&&result==5)%正确识别为害怕个数
        sum5=sum5+1;
    end
  summ=sum1+sum2+sum3+sum4+sum5;
end
rate=[sum1,sum2,sum3,sum4,sum5];
