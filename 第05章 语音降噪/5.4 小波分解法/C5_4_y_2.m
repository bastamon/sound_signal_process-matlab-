%实验要求二：小波硬阈值语音降噪
clear all; clc; close all;

[xx, fs] = wavread('C5_4_y.wav');           % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
N=length(x);
%-------------------------加入指定强度的噪声---------------------------------
SNR=5;
s=awgn(x,SNR,'measured','db');               % 叠加噪声
wname='db7';

jN=6;  %分解的层数
snrs=20*log10(norm(x)/norm(s-x));
signal=Wavelet_Hard(s,jN,wname);
signal=signal/max(abs(signal));
snr1=SNR_Calc(x,s);            % 计算初始信噪比
snr2=SNR_Calc(x,signal);            % 计算降噪后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
% 作图
time=(0:N-1)/fs;                        % 设置时间
subplot 311; plot(time,x,'k'); grid; axis tight;
title('纯语音波形'); ylabel('幅值')
subplot 312; plot(time,s,'k'); grid; axis tight;
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 313; plot(time,signal,'k');grid;%hold on;
title('滤波后波形'); ylabel('幅值'); xlabel('时间/s');
%--------------------------------------------------------------------------
