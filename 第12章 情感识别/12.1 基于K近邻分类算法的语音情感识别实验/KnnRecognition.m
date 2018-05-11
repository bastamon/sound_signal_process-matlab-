%% knn分类主程序（利用采集的情感语音信号特征数据进行分类识别）
clc
clear all;
close all;

%% 载入各情感的特征向量矩阵
load A_fear.mat;
load F_happiness.mat;
load N_neutral.mat;
load T_sadness.mat;
load W_anger.mat;
NumberOfTrain=size(fearVec,2)/2; %一半测试用，一半训练用
trainVector=[fearVec(:,1:NumberOfTrain),hapVec(:,1:NumberOfTrain),neutralVec(:,1:NumberOfTrain),sadnessVec(:,1:NumberOfTrain),angerVec(:,1:NumberOfTrain)]; % 构建训练样本集
testVector=[fearVec(:,(NumberOfTrain+1):size(fearVec,2)),hapVec(:,(NumberOfTrain+1):size(hapVec,2)),neutralVec(:,(NumberOfTrain+1):size(neutralVec,2)),sadnessVec(:,(NumberOfTrain+1):size(sadnessVec,2)),angerVec(:,(NumberOfTrain+1):size(angerVec,2))]; % 构建测试样本集
k=9; %k 最近邻
distanceMatrix=zeros(size(trainVector,2),size(testVector,2)); % 每一列表示某个测试语音与所有训练集样本的距离
%% 计算每个测试样本和训练样本集各样本的距离
for i=1:size(testVector,2)
    for j=1:size(trainVector,2)
        distanceMatrix(j,i)=norm(testVector(:,i)-trainVector(:,j)); %计算欧氏距离
    end
end
%% 统计分类结果 （根据相应的特征向量在数组trainVector或testVector中所处的位置来辨别类型）
totalTestNumber=size(fearVec,2)-NumberOfTrain;
emtionCounter=zeros(1,5);
n1=NumberOfTrain;
n2=n1+NumberOfTrain;
n3=n2+NumberOfTrain;
n4=n3+NumberOfTrain;
n5=n4+NumberOfTrain;
p1=size(fearVec,2)-NumberOfTrain;
p2=p1+size(hapVec,2)-NumberOfTrain;
p3=p2+size(neutralVec,2)-NumberOfTrain;
p4=p3+size(sadnessVec,2)-NumberOfTrain;
p5=p4+size(angerVec,2)-NumberOfTrain;
if(n5~=size(trainVector,2)||p5~=size(testVector,2))
    disp('data error')
    return;
end

for i=1:size(distanceMatrix,2)
    flag=zeros(1,5);
    [sortVec,index]=sort(distanceMatrix(:,i));
    % 统计K个近邻中各类别的数量
    for j=1:k
        if(n1>=index(j)&&index(j)>=1)
            flag(1)=flag(1)+1;
        elseif(n2>=index(j)&&index(j)>n1)
            flag(2)=flag(2)+1;
        elseif(n3>=index(j)&&index(j)>n2)
            flag(3)=flag(3)+1;
        elseif(n4>=index(j)&&index(j)>n3)
            flag(4)=flag(4)+1;
        else
            flag(5)=flag(5)+1;
        end
    end
    [~,index1]=sort(flag);
    % 如果K个近邻中数量最多的类别与该样本实际的类别一致，则认为算法识别正确，相应counter加一。
    if((p1>=i&&i>=1)&&index1(5)==1)
        emtionCounter(index1(5))=emtionCounter(index1(5))+1;
       
    elseif((p2>=i&&i>p1)&&index1(5)==2)
        emtionCounter(index1(5))=emtionCounter(index1(5))+1;
        
    elseif((p3>=i&&i>p2)&&index1(5)==3)
        emtionCounter(index1(5))=emtionCounter(index1(5))+1;
        
    elseif((p4>=i&&i>p3)&&index1(5)==4)
        emtionCounter(index1(5))=emtionCounter(index1(5))+1;
       
    elseif((p5>=i&&i>p4)&&index1(5)==5)
        emtionCounter(index1(5))=emtionCounter(index1(5))+1;
       
    end

end

%% 显示结果
ratio=emtionCounter./totalTestNumber;
bar(ratio);
ylim([0,1])
set(gca,'XTickLabel',{'惊恐','高兴','中性','高兴','生气'});
n=1:5;
for i = 1:length(ratio)
text(n(i)-0.18,ratio(i)+0.02,num2str(ratio(i)));
end
title(strcat('KNN 算法识别结果\_ ',strcat('K = ',num2str(k))));
xlabel('情感类别')
ylabel('识别率')










