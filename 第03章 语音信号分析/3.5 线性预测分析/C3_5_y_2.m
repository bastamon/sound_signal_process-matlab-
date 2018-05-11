%实验要求二：编程比较LPC预测系数的复频谱与FFT频谱
clear all; clc; close all;

[x,fs]=wavread('C3_5_y.wav');                    % 读入语音数据
L=240;                                                  	% 帧长
p=12;                                                       % LPC的阶数
y=x(8001:8000+L);                                   % 取一帧数据
ar=lpc(y,p);                                                % 线性预测变换
nfft=512;                                                   % FFT变换长度
W2=nfft/2;
m=1:W2+1;                                               % 正频率部分下标值
Y=fft(y,nfft);                                              % 计算信号y的FFT频谱
Y1=lpcff(ar,W2);                                        % 计算预测系数的频谱
% 作图
subplot 211; plot(y,'k');
title('(a)一帧语音信号的波形'); ylabel('幅值'); xlabel('(a)')
subplot 212; 
plot(m,20*log10(abs(Y(m))),'k','linewidth',1.5); 
line(m,20*log10(abs(Y1)),'color',[.6 .6 .6],'linewidth',2)
axis([0 W2+1 -30 25]); ylabel('幅值/db');
legend('FFT频谱','LPC谱',3); xlabel(['样点' 10 '(b)'])
title('(b)FFT频谱和LPC谱的比较');
