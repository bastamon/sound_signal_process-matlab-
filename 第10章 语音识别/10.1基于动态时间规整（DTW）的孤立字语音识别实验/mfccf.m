function FMatrix=mfccf(num,s,Fs)
%计算并返回信号s的mfcc参数及其一阶和二阶差分参数
%参数说明： num 是mfcc系数数，Fs为采样频率

N=512;              % FFT 数
Tf=0.02;            %窗口的时长
n=Fs*Tf;            %每个窗口的长度
M=24;               %M为滤波器组数
l=length(s);        
Ts=0.01;            %帧移时长
FrameStep=Fs*Ts;    %帧移
a=1;
b=[1, -0.97];       %预加重处理的一阶FIR高通滤波器系数


noFrames=fix((l-n)/FrameStep)+1;  %帧数
FMatrix=zeros(noFrames-2, num); %倒谱系数初始矩阵，一阶差分的首尾2帧为0,
lifter=1:num;                   %倒谱加权初始矩阵
lifter=1+floor(num/2)*(sin(lifter*pi/num));%倒谱加权函数

if mean(abs(s)) > 0.01
    s=s/max(s);                     %初始化
end

%计算 MFCC 系数
for i=1:noFrames
    frame=s((i-1)*FrameStep+1:(i-1)*FrameStep+n);  %frame用于存储每一帧数据
    framef=filter(b,a,frame);   %预加重滤波器
    F=framef.*hamming(n);       %加汉明窗
    FFTo=fft(F,n);         %计算FFT
    melf=melbankm(M,N,Fs);      %计算mel滤波器组系数  
    halfn=1+floor(N/2);    
    spectr=log(melf*(abs(FFTo(1:halfn)).^2)+1e-22);%三角滤波器进行滤波加上1e-22防止进行对数运算后变成无穷
%%%%%%%%%%进行DCT变换%%%%%%%
c=zeros(1,num);
    for p=1:num
        for m=1:M
           c(p)=c(p)+spectr(m)*cos(p*(m-0.5)*pi/M);
        end
    end
    ncoeffs=c.*lifter;          %对MFCC参数进行倒谱加权
    FMatrix(i, :)=ncoeffs;     
end

%调用deltacoeff函数计算MFCC差分系数
d=deltacoeff(FMatrix);         %计算一阶差分系数
d1=deltacoeff(d);              %计算二阶差分系数
FMatrix=[FMatrix,d,d1];        %将三组数据作为特征向量
