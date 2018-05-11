clc,clear

N=4;%N为人数;
M=4;%M为每个人待识别样本数
len=5;
load data.mat u;

for iii=1:len
    iii;
for i=1:M
    Dstu=zeros(N,1);
    s=['TX',num2str(iii),'_',num2str(i),'.wav'];
    [x,fs]=audioread(s);
    mel=my_mfcc(x,fs)';%测试数据特征
 
    for ii=1:N   %与第ii个人匹配
        for jj=1:size(mel,2) %测试语音第jj个特征向量
            distance=dis(u{ii},mel(:,jj));
            Dstu(ii)=min(distance)+Dstu(ii);
        end
    end
    [val,pos]=min(Dstu);
    if val/size(mel,2)>=81
        fprintf('测试者不是系统内人\n')
    else
        fprintf('测试者为SX%d\n',pos)
    end
end
end
