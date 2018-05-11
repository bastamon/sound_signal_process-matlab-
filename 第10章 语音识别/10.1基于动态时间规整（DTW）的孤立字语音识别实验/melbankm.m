function H=melbankm(M,N,fs,fl,fh)
%Mel滤波器组
% 输入参数:	M 滤波器组数量
%		   N  FFT长度
%		   fs  采样频率
%		   fl -fh 为线性功率谱的有用频带(默认为0-0.5*fs)
%		   
%输出参数:	H返回滤波器组，每一行为一个滤波器
if nargin<4
    fl=0*fs;
    fh=0.5*fs;
end

%计算每个滤波器的中心频率
f=zeros(1,M+1);
for m=1:M+2
    f(m)=floor((N/fs)*mel2freq(freq2mel(fl)...
        +(m-1)*(freq2mel(fh)-freq2mel(fl))/(M+1)));
end
%求滤波器组H
c=floor(N/2)+1;
y=zeros(1,c);
H=zeros(M,c);
for m=2:M+1
    for k=1:c                   %由于fh最高为fs/2，那么最多需c位就能存储H
        if f(m-1)<=k&&k<=f(m)
            y(k)=(k-f(m-1))/(f(m)-f(m-1));
        elseif f(m)<=k&&k<=f(m+1)
            y(k)=(f(m+1)-k)/(f(m+1)-f(m));
        else
            y(k)=0;
        end
    end
    H(m,:)=y;
end
    