%实验要求二：基于先验信噪比的维纳滤波算法语音降噪
clear all; clc; close all;

[xx, fs] = wavread('C5_3_y.wav');           % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
IS=0.25;                                % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 设置帧移为10ms
SNR=5;                                  % 设置信噪比SNR
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数
alpha=0.95;

signal=awgn(x,SNR,'measured','db');               % 叠加噪声
output=Weina_Im(x,wlen,inc,NIS,alpha) ;
output=output/max(abs(output));
len=min(length(output),length(x));
x=x(1:len);
signal=signal(1:len);
output=output(1:len);

snr1=SNR_Calc(x,signal);            % 计算初始信噪比
snr2=SNR_Calc(x,output);            % 计算降噪后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);

% 作图
time=(0:len-1)/fs;                        % 设置时间
subplot 311; plot(time,x,'k'); grid; axis tight;
title('纯语音波形'); ylabel('幅值')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 313; plot(time,output,'k');grid;%hold on;
title('滤波后波形'); ylabel('幅值'); xlabel('时间/s');



        
