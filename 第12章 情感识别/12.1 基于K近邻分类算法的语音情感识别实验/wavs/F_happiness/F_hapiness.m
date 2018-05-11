%% 提取该文件夹下的语音文件的特征
clc 
clear all
close all

wavefilename = '*.wav';
dr = dir(wavefilename);
hapVec=zeros(140,length(dr));
for i = 1:length( dr )
    disp(i)
    disp(dr(i).name);
    hapVec(:,i)=featvector(dr(i).name);%利用函数featvector提取特征
end
disp(length(dr));
for i=1:size(hapVec,1)
    hapVec(i,:)=mapzo(hapVec(i,:));   %利用函数mapzo进行归一化
end
save F_happiness hapVec;