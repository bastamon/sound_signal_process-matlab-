%实验要求：基于特征降维的语音情感识别
clc;
clear;
load A_fear fearVec;
load F_happiness hapVec;
load N_neutral neutralVec;
load T_sadness sadnessVec;
load W_anger angerVec;
sampleang=angerVec';
samplehap=hapVec';
sampleneu=neutralVec';
samplesad=sadnessVec';
samplefear=fearVec';
trainang=sampleang(1:30,:); %每类三十个样本作为训练样本
test(1:20,:)=sampleang(31:50,:);%每类二十个样本作为测试样本
trainhap=samplehap(1:30,:);
test(21:40,:)=samplehap(31:50,:);%
trainneu=sampleneu(1:30,:);
test(41:60,:)=sampleneu(31:50,:);%
trainsad=samplesad(1:30,:);
test(61:80,:)=samplesad(31:50,:);%
trainfear=samplefear(1:30,:);
test(81:100,:)=samplefear(31:50,:);%
%提取150个样本为训练样本，100个样本为预测样本
trainsample=[trainang;trainhap;trainneu;trainsad;trainfear];   %训练样本
 for i=1:30
   output(i)=1;
 end
 for i=31:60
   output(i)=2;
 end
 for i=61:90
   output(i)=3;
 end
 for i=91:120
   output(i)=4;
 end
 for i=121:150
   output(i)=5;
 end
 trainlabel=output';   %训练样本类别
for i=1:20
   output1(i)=1;
 end
 for i=21:40
   output1(i)=2;
 end
 for i=41:60
   output1(i)=3;
 end
 for i=61:80
   output1(i)=4;
 end
 for i=81:100
   output1(i)=5;
 end
 testlabel=output1';%测试样本类别
[trainpca, testpca] = pca(trainsample, test,5);
rate=knn(trainpca, testpca,7);
figure(1)
bar(rate./20,0.5);
set(gca,'XTickLabel',{'生气','高兴','中性','悲伤','害怕'});
ylabel('识别率');
xlabel('五种基本情感');

N=[30,30,30,30,30];
trainsample=[trainang;trainhap;trainneu;trainsad;trainfear];      %训练样本
testsample(1:20,:)=sampleang(31:50,:);%%每类二十个样本作为测试样本
testsample(21:40,:)=samplehap(31:50,:);%
testsample(41:60,:)=sampleneu(31:50,:);%
testsample(61:80,:)=samplesad(31:50,:);%
testsample(81:100,:)=samplefear(31:50,:);%
data=trainsample;
[trainlda, testlda] = lda(data, testsample, N, 4);

rate=knn(trainlda, testlda,7);
figure(2)
bar(rate./20,0.5);
set(gca,'XTickLabel',{'生气','高兴','中性','悲伤','害怕'});
ylabel('识别率');
xlabel('五种基本情感');
