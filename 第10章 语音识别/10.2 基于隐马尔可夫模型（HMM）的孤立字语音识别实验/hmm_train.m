clear all;
% 读入训练数据集tra_data.mat
load tra_data.mat;

N = 4;   % hmm的状态数
M = [3,3,3,3]; % 每个状态对应的混合模型成分数

for i = 1:length(tdata)  % 数字的循环
    fprintf('\n计算数字%d的mfcc特征参数\n',i);
    for k = 1:length(tdata{i})  % 样本数的循环
      obs(k).sph = tdata{i}{k};  % 数字i的第k个语音
      obs(k).fea = mfcc(obs(k).sph);  % 对语音提取mfcc特征参数
    end
    
    fprintf('\n训练数字%d的hmm\n',i);
    hmm_temp=inithmm(obs,N,M); %初始化hmm模型
    hmm{i}=baum_welch(hmm_temp,obs); %迭代更新hmm的各参数
end
fprintf('\n训练完成！\n');


