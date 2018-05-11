%% 提取该文件夹下的语音文件的特征
clc 
clear all
close all

wavefilename = '*.wav';
dr = dir(wavefilename);
angerVec=zeros(140,length(dr));
for i = 1:length( dr )
    disp(dr(i).name);
    angerVec(:,i)=featvector(dr(i).name);%利用函数featvector提取特征
end
disp(length(dr));
for i=1:size(angerVec,1)
    angerVec(i,:)=mapzo(angerVec(i,:));   %利用函数mapzo进行归一化
end
save W_anger angerVec;