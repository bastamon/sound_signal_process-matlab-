% 实验要求三：预加重功能测试
clc
clear all
close all
[s,fs]=wavread('C2_5_y_3.wav');
e=s(2000:2225);                                 %提取一段进行分析，容易看出变化
un=filter([1,-0.95],1,e);                       %预加重信号b=[1,-0.95];

%原始信号频谱
N=512;
pinlv=(0:1:N/2-1)*fs/N;
x=fft(e,N);
r1=abs(x);
t1=20*log10(r1);
signal=t1(1:N/2);

%预加重信号频谱
[h1,w1]=freqz([1,-0.95],1,256,fs);
pha=angle(h1);
H1=abs(h1);
r2=r1(1:N/2);
u=r2.*h1;
u2=abs(u);
signalPre=20*log10(u2);

figure(1);
subplot(211)
plot(e,'b*-')
ylim([-0.4,1])
hold on
plot(real(un),'ro-')
legend('原始语音信号','预加重后的语音信号')
title('原始语音信号和预加重后的语音信号');
xlabel('采样点');ylabel('幅度');
subplot(212);
plot(pinlv,signal,'g+-')
hold on
plot(pinlv,signalPre,'kx-')
legend('原始语音信号频谱','预加重后的语音信号频谱')
title('预加重前后的语音信号频谱');
xlabel('频率');ylabel('幅度/dB');

