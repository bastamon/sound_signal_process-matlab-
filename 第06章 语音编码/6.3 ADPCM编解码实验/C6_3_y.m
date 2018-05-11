%实验要求：ADPCM编解码实验
clear all;
clc
close all;
[x,fs,numbits]= wavread('C6_3_y.wav'); 

sign_bit=2;                                     %两位ADPCM算法
ss=adpcm_encoder(x,sign_bit);
yy=adpcm_decoder(ss,sign_bit)';

nq=sum((x-yy).*(x-yy))/length(x);
sq=mean(yy.^2);
snr=(sq/nq);
t=(1:length(x))/fs;
subplot(211)
plot(t,x/max(abs(x)))
axis tight
title('(a)编码前语音')
xlabel('时间/s')
ylabel('幅度')
subplot(212)
plot(t,yy/max(abs(yy)))
axis tight
title('(b)解码后语音')
xlabel('时间/s')
ylabel('幅度')
snrq=10*log10(mean(snr))


