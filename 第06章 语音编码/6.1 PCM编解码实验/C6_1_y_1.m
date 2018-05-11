%实验要求一：PCM编解码实验
clear all;
close all;
[x fs numbits]= wavread('C6_1_y.wav');  
v=1;
xx=x/v;
sxx=floor(xx*4096);
y=pcm_encode(sxx);
yy=pcm_decode(y,v)';

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


