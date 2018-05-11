%实验要求二：LMS降噪
close all;clear all; clc; 

[s, fs, bits] = wavread('C5_1_y.wav');           % 读入数据文件
s=s-mean(s);                                % 消除直流分量
s=s/max(abs(s));                        % 幅值归一
N=length(s);                                % 语音长度
time=(0:N-1)/fs;                        % 设置时间刻度
SNR=5;                                      % 设置信噪比
r1=awgn(s,SNR,'measured','db');
M=64;                                       % 设置Ｍ和mu
mu=0.001;  
itr=length(r1);
snr1=SNR_Calc(s,r1);                    % 计算初始信噪比
[y,W,e]=LMS(r1,s,M,mu,itr);
output=e/max(abs(e));                 	% LMS滤波输出
snr2=SNR_Calc(s,output);            % 计算滤波后的信噪比
snr=snr2-snr1;
SN1=snr1; SN2=snr2; SN3=snr;
fprintf('snr1=%5.4f   snr2=%5.4f    snr=%5.4f\n',snr1,snr2,snr);
% 作图
subplot 311; plot(time,s,'k'); ylabel('幅值') 
ylim([-1 1 ]); title('原始语音信号');
subplot 312; plot(time,r1,'k'); ylabel('幅值') 
ylim([-1 1 ]); title('带噪语音信号');
subplot 313; plot(time,output,'k'); 
ylim([-1 1 ]); title('LMS滤波输出语音信号');
xlabel('时间/s'); ylabel('幅值')
