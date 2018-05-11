%实验要求一：谱减法语音降噪
clear all; clc; close all;

[xx, fs] = wavread('C5_2_y.wav');           % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化

IS=0.25;                                % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 设置帧移为10ms
SNR=5;                                  % 设置信噪比SNR
N=length(x);                            % 信号长度
time=(0:N-1)/fs;                        % 设置时间

signal=awgn(x,SNR,'measured','db');               % 叠加噪声
snr1=SNR_Calc(x,signal);            % 计算初始信噪比
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

a=4; b=0.001;                           % 设置参数a和b
output=SpectralSub(signal,wlen,inc,NIS,a,b);% 谱减
snr2=SNR_Calc(x,output);            % 计算谱减后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);

% 作图
subplot 311; plot(time,x,'k'); grid; axis tight;
title('纯语音波形'); ylabel('幅值')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 313; plot(time,output,'k');grid;%hold on;
title('谱减后波形'); ylabel('幅值'); xlabel('时间/s');



        
