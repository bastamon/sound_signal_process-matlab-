%实验要求一：倒谱计算与显示
clear all; clc; close all;
[y,fs]=wavread('C3_4_y_1.wav');
y=y(1:1000);
N=1024;                                                       % 采样频率和FFT的长度
len=length(y);
time=(0:len-1)/fs;                                         % 时间刻度
figure(1), subplot 311; plot(time,y,'k');           % 画出信号波形
title('(a)信号波形'); axis([0 max(time) -1 1]);
ylabel('幅值'); xlabel(['时间/s' 10]); grid;

nn=1:N/2; ff=(nn-1)*fs/N;                       % 计算频率刻度
z=Nrceps(y);                                            %求取倒谱
figure(1), subplot 312; plot(time,z,'k');       % 画出倒谱图
title('(b)信号倒谱图'); axis([0 time(512) -0.2 0.2]); grid; 
ylabel('幅值'); xlabel(['倒频率/s' 10]);

yc=cceps(y);
yn=icceps(yc);
figure(1), subplot 313; plot(time,yn,'k');     % 画出倒谱图
title('(c)恢复信号'); axis([0 max(time) -1 1]);
ylabel('幅值'); xlabel(['时间/s' 10]); grid;     