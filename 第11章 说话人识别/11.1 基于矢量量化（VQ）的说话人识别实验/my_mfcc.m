function mfc=my_mfcc(x,fs)
%MY_MFCC:获取Speaker recognition的参数
%x:输入语音信号  fs：采样率
%mfc：十二个mfcc系数和一个能量 以及一阶和二阶差分 共36个参数 每一行为一帧数据
%clc,clear
%[x,fs]=audioread('wo6.wav');
N=256;p=24;
bank=mel_banks(p,N,fs,0,fs/2);
% 归一化mel滤波器组系数
bank=full(bank);
bank=bank/max(bank(:));

% 归一化倒谱提升窗口
w = 1 + 6 * sin(pi * [1:12] ./ 12);
w = w/max(w);

% 预加重滤波器
x=double(x);
x=filter([1 -0.9375],1,x);

% 语音信号分帧
sf=check_ter(x,N,128,10);

x=div_frame(x,N,128);
%sf=sp_ter(x,4,16);
%m=zeros(size(x,1),13);
m=zeros(1,13);
% 计算每帧的MFCC参数
for i=1:size(x,1)
    if sf(i)==1
        % j=j+1;
         y = x(i,:);
         y = y' .* hamming(N);
         energy=log(sum(y.^2)+eps);%能量
         y = abs(fft(y));
         y = y.^2+eps;
        c1=dct(log(bank * y));
        c2 = c1(2:13).*w';%取2~13个系数
        %m(i,:)=[c2;energy]';
        m1=[c2;energy]';
        %m1=c2';
        m=[m;m1];
    end
    
end

%差分系数
dm = zeros(size(m));
dmm= zeros(size(m));
for i=2:size(m,1)-1
  dm(i,:) = (m(i,:) - m(i-1,:));
end
for i=3:size(m,1)-2
  dmm(i,:) = (dm(i,:) - dm(i-1,:));
end
%dm = dm / 3;

%合并mfcc参数和一阶差分mfcc参数
mfc = [m dm dmm];
%去除首尾两帧，因为这两帧的一阶差分参数为0
mfc = mfc(3:size(m,1)-2,:);
%mfc=sum(mfc,1)/size(mfc,1);