%实验要求：回声法语音信息隐藏实验
clc;
clear all;
close all;
[x,fs]=wavread('C8_2_y.wav');
message = zeros(1,100);
for i=1:100
    if (rand(1)>0.5)
        message(1,i)=1;
    else
        message(1,i)=0;
    end
end
N = 0.1*fs;
m0 = 0.4*N;
m1=0.2*N;
x_embeded=hide_EchoEmbed(x,message,N,m0,m1,0.7);
len  = min(length(message),length(x)/N);
mess = hide_EchoExtract( x_embeded,N,m0,m1,len);

figure;plot(x);title('原始语音信号');
figure;plot(x_embeded);title('含嵌入信息的语音信号');
figure;plot(mess,'*');title('提取的隐藏信息');grid on;