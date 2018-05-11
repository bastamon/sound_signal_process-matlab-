%实验要求二：Boll的改进谱减法
clear all; clc; close all;

[xx,fs]=wavread('C5_2_y.wav');                   % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
SNR=10;                                 % 设置信噪比
signal=awgn(x,SNR,'measured','db');                % 叠加噪声
snr1=SNR_Calc(x,signal);            % 计算叠加噪声后的信噪比
N=length(x);                            % 信号长度
time=(0:N-1)/fs;                        % 设置时间刻度
IS=.15;                                 % % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 设置帧移为10ms
Gamma=1;                                %幅度加权（改进谱减法的参数）
Beta=.03;
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数
output=SpectralSubIm(signal,wlen,inc,NIS,Gamma,Beta);          % 调用SSBoll79函数做谱减
output=output/max(abs(output));
ol=length(output);                      % 把output补到与x等长
if ol<N
    output=[output; zeros(N-ol,1)];
end
snr2=SNR_Calc(x,output);            % 计算谱减后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);

% 作图
subplot 311; plot(time,x,'k'); grid; axis tight;
title('纯语音波形'); ylabel('幅值')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 313; plot(time,output,'k');grid; ylim([-1 1]);
title('谱减后波形'); ylabel('幅值'); xlabel('时间/s');