% 读入待识别语音
load rec_data.mat;
fprintf('开始识别\n');
j = 9;
rec_sph=rdata{j}{1}; % 随机选择一条待识别语音“9”
fprintf('该语音的真实值为%d\n',j);
rec_fea = mfcc(rec_sph);  % 特征提取

% 求出当前语音关于各数字hmm的p(X|M)
for i=1:10
  pxsm(i) = viterbi(hmm{i}, rec_fea); 
end
[d,n] = max(pxsm); % 判决，将该最大值对应的序号作为识别结果
fprintf('该语音识别结果为%d\n',n)
