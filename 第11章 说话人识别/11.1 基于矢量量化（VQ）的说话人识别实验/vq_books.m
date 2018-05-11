clc,clear
%完成说话人识别的训练和匹配
k=8;
N=4;%N个说话人
for i=1:N
    s=['SX',num2str(i),'.wav'];
    [x,fs]=audioread(s);
    x=x/max(x);%归一化
    mel=my_mfcc(x,fs)';%每列为一个数据
    v=lbg(mel,k);
    u{i}=[v(1:k).mea];
end
save data.mat u