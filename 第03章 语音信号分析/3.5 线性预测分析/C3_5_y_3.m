%实验要求三：编程比较LPCC
clear all; clc; close all;

[x,fs]=wavread('C3_5_y.wav');            % 读入语音数据
L=240;                                              % 帧长
p=12;                                               % LPC的阶数
y=x(8001:8000+L);                           % 取一帧数据
ar=lpc(y,p);                                       % 线性预测变换
lpcc1=lpc_lpccm(ar,p,p);
lpcc2=rceps(ar); 

subplot 211; plot(lpcc1(1:2:end),'k');
title('(a)线性预测系数求LPCC'); ylabel('幅值'); xlabel(['样点' ])
subplot 212; plot(lpcc2(1:p/2),'k');
title('(b)直接求LPCC'); ylabel('幅值'); xlabel(['样点' ])
