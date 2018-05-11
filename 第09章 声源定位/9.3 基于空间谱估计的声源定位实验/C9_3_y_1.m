%实验要求一：基于阵列流形矩阵的信号显示
clear all;
close all;
clc
%****************************************************%
M=2;                                %阵元数目
theta0=30;                          %声源到达方向
p=1;                                 %声源个数
lamda=1.6;                        %波长
d=lamda/2;                       %阵元间距
a=[0:1:M-1];
a_theta0=exp(j*pi*2*d/lamda*sin(theta0*pi/180)*a);%第一阵列流型矢量
%****************************************************%
[s,fs]=wavread('C9_3_y.wav');   
s=s/max(abs(s));
sound_length = 6400;
%装载房间冲激响应
load h.mat;            
%麦克风1的信号
s1=conv(s,h1);
s1=s1(1:sound_length);
%麦克风2的信号
s2=conv(s,h2);
s2=s2(1:sound_length);
%****************************************************%
s1=s1*a_theta0(1);                  %叠加角度信息
s2=s2*a_theta0(2);
%****************************************************%
%添加白噪声
%SNR=20dB
s1_20db = awgn(s1,20,'measured','db');
s2_20db = awgn(s2,20,'measured','db');
%SNR=10dB
s1_10db = awgn(s1,10,'measured','db');
s2_10db = awgn(s2,10,'measured','db');
%SNR=0dB
s1_0db = awgn(s1,0,'measured','db');
s2_0db = awgn(s2,0,'measured','db');
%SNR=-5dB
s1_m5db = awgn(s1,-5,'measured','db');
s2_m5db = awgn(s2,-5,'measured','db');
figure(1);
%显示原始输入语音信号波形
subplot(5,2,1),plot(s1,'k'),title('麦克风1（原始）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,2),plot(abs(s2),'k'),title('麦克风2 （原始）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,3),plot(s1_20db,'k'),title('麦克风1（SNR=20dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,4),plot(abs(s2_20db),'k'),title('麦克风2（SNR=20dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,5),plot(s1_10db,'k'),title('麦克风1（SNR=10dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,6),plot(abs(s2_10db),'k'),title('麦克风2（SNR=10dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,7),plot(s1_0db,'k'),title('麦克风1（SNR=0dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,8),plot(abs(s2_0db),'k'),title('麦克风2 （SNR=0dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,9),plot(s1_m5db,'k'),title('麦克风1 （SNR=-5dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,10),plot(abs(s2_m5db),'k'),title('麦克风2 （SNR=-5dB）'),xlabel('采样点'),ylabel('幅度');
save ('s.mat','s1','s2','s1_20db','s2_20db','s1_10db','s2_10db','s1_0db','s2_0db','s1_m5db','s2_m5db');


