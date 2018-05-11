%实验要求：线谱对转换实验
clear all; clc; close all;

[x,fs]=wavread('C3_6_y.wav');          
x=x/max(abs(x));              % 幅值归一化
time=(0:length(x)-1)/fs;      % 求出对应的时间序列
N=200;                              % 设定帧长
M=80;                               % 设定帧移的长度  
xn=enframe(x,N,M)';           % 按照参数进行分帧
s=xn(:,100);                        % 取分帧后的笫100帧进行分析

p=12;                               % 设预测阶次
num=256;                        % 设定频谱的点数
a2 =lpc(s,p);                       % 利用信号处理工具箱中的函数lpc求预测系数a2
Hw=lpcff(a2,num-1);        % 调用lpcar2ff函数从预测系数a求出LP谱Hw
Hw_abs=abs(Hw);               % 取Hw的模值
lsf=lpctolsf(a2);                   % 调用ar2lsf函数把ar系数转换的lsf参数
P_w=lsf(1:2:end);               % 用lsf求出P和Q对应的频率，单位为弧度
Q_w=lsf(2:2:end);
P_f=P_w*fs/2/pi;              % 转换成单位为Hz
Q_f=Q_w*fs/2/pi;

subplot 211; plot(s,'k');     % 画出一帧信号的波形
title('(a)语音信号C3\_6\_y.wav的一帧波形图 ');
xlabel(['样点值' 10 ]); ylabel('幅值')    
freq=(0:num-1)*fs/512;          % 计算频域的频率序列
m=1:num;
K=length(Q_w);

ar=lsftolpc(lsf);                       % 调用lsf2ar函数把lsf转换成预测系数ar 
Hw1=lpcff(ar,num-1);            % 调用lpcar2ff函数,从预测系数ar求出LP谱Hw1
Hw1_abs=abs(Hw1);
subplot 212;                            % 把Hw和Hw1画在一个图中
hline1 = plot(freq,20*log10(Hw_abs(m)/max(Hw_abs)),'k','LineWidth',2); 
hline2 = line(freq+1,20*log10(Hw1_abs(m)/max(Hw1_abs)),...
    'LineWidth',5,'Color',[.6 .6 .6]);
set(gca,'Children',[hline1 hline2]);
axis([0 fs/2 -35 5]);
title('(b)语音信号的LPC谱和线谱对还原LPC的频谱 ');
xlabel(['频率/Hz' 10]); ylabel('幅值')    
for k=1 : K                   % 把P_f和Q_f也在图中用垂直线标出
    line([Q_f(k) Q_f(k)],[-35 5],'color','k','Linestyle','--');
    line([P_f(k) P_f(k)],[-35 5],'color','k','Linestyle','-');
end
for k= 1 : p+1                % 显示预测系数a2和ar，对两者进行比较
    fprintf('%4d   %5.6f   %5.6f\n',k,a2(k),ar(k));
end
