%实验要求三：不同信噪比下的麦克风接收信号
clear all;
close all;
clc
%****************************************************%
[s,fs]=wavread('C9_1_y.wav');   
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
subplot(5,2,2),plot(s2,'k'),title('麦克风2 （原始）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,3),plot(s1_20db,'k'),title('麦克风1（SNR=20dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,4),plot(s2_20db,'k'),title('麦克风2（SNR=20dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,5),plot(s1_10db,'k'),title('麦克风1（SNR=10dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,6),plot(s2_10db,'k'),title('麦克风2（SNR=10dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,7),plot(s1_0db,'k'),title('麦克风1（SNR=0dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,8),plot(s2_0db,'k'),title('麦克风2 （SNR=0dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,9),plot(s1_m5db,'k'),title('麦克风1 （SNR=-5dB）'),xlabel('采样点'),ylabel('幅度');
subplot(5,2,10),plot(s2_m5db,'k'),title('麦克风2 （SNR=-5dB）'),xlabel('采样点'),ylabel('幅度');
save ('s.mat','s1','s2','s1_20db','s2_20db','s1_10db','s2_10db','s1_0db','s2_0db','s1_m5db','s2_m5db');


