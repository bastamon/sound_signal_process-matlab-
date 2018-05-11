%实验要求一：消除线性趋势项
clear all; clc; close all;
[x,fs,nbit]=wavread('C2_5_y_1.wav');     % 读入语音文件
len=length(x);
n=0.5:0.3/(len-1):0.8;                      %设置线性曲线
x=x+n';                                         %叠加线性趋势线
t=(0:length(x)-1)/fs;                       % 设置时间
y=detrend(x);                               % 消除线性趋势项
y=y/max(abs(y));                          % 幅值归一化
subplot 211; plot(t,x,'k');               % 画出带有趋势项的语音信号x
title('带趋势项的语音信号');
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(t,y,'k');               % 画出消除趋势项的语音信号y
xlabel('时间/s'); ylabel('幅值');
title('消除趋势项的语音信号');

%消除多项式趋势项
clear all; clc; 
[x,fs,nbit]=wavread('C2_5_y_1.wav');         % 读入C2_5_y_1.wav文件
len=length(x);
n=0:1/(len-1):1;
nn=n.^2-0.5;
x=x+nn';
[y,xtrend]=detrendN(x, fs, 2);          % 调用detrendN消除趋势项
t=(0:length(x)-1)/fs;                        % 设置时间
figure
subplot 211; plot(t,x,'k');                 % 画出带有趋势项的语音信号x
line(t,xtrend,'color','r','linewidth',2); % 画出趋势项曲线
ylim([-1.5 1]);
title('带趋势项的语音信号');
legend('带趋势项的语音信号','趋势项信号',4)
xlabel('时间/s'); ylabel('幅值');
subplot 212; plot(t,y,'k');               % 画出消除趋势项的语音信号y
xlabel('时间/s'); ylabel('幅值');
title('消除趋势项的语音信号');


