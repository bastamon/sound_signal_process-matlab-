%实验要求：基于神经网络的语音情感识别
clc 
close all
clear all
load A_fear fearVec;
load F_happiness hapVec;
load N_neutral neutralVec;
load T_sadness sadnessVec;
load W_anger angerVec;
 trainsample(1:30,1:140)=angerVec(:,1:30)';
 trainsample(31:60,1:140)=hapVec(:,1:30)';
 trainsample(61:90,1:140)=neutralVec(:,1:30)';
 trainsample(91:120,1:140)=sadnessVec(:,1:30)';
 trainsample(121:150,1:140)=fearVec(:,1:30)';
  trainsample(1:30,141)=1;
   trainsample(31:60,141)=2;
   trainsample(61:90,141)=3;
   trainsample(91:120,141)=4; 
   trainsample(121:150,141)=5;
   testsample(1:20,1:140)=angerVec(:,31:50)';
  testsample(21:40,1:140)=hapVec(:,31:50)';
 testsample(41:60,1:140)=neutralVec(:,31:50)';
  testsample(61:80,1:140)=sadnessVec(:,31:50)';
  testsample(81:100,1:140)=fearVec(:,31:50)';
  testsample(1:20,141)=1;
   testsample(21:40,141)=2;
    testsample(41:60,141)=3;
    testsample(61:80,141)=4; 
    testsample(81:100,141)=5;
  class=trainsample(:,141);
sum=bpnn(trainsample,testsample,class);
figure(1)
bar(sum,0.5);
set(gca,'XTickLabel',{'生气','高兴','中性','悲伤','害怕'});
ylabel('识别率');
xlabel('五种基本情感');

p_train=trainsample(:,1:140)';
t_train=trainsample(:,141)';
p_test=testsample(:,1:140)';
t_test=testsample(:,141)';
sumpnn=pnn(p_train,t_train,p_test,t_test);
figure(2)
bar(sumpnn,0.5);
set(gca,'XTickLabel',{'生气','高兴','中性','悲伤','害怕'});
ylabel('识别率');
xlabel('五种基本情感');
sumlvq=lvq(trainsample,testsample,class);

figure(3)
bar(sumlvq,0.5);
set(gca,'XTickLabel',{'生气','高兴','中性','悲伤','害怕'});
ylabel('识别率');
xlabel('五种基本情感');