% 实验要求二：带通滤波器设计
clear all; clc; close all;

fs=8000; fs2=fs/2;                      % 采样频率
Wp=[60 500]/fs2;                        % 滤波器通带
Ws=[20 1500]/fs2;                       % 滤波器阻带
Rp=1; Rs=40;                            % 通带的波纹和阻带的衰减
[n,Wn]=ellipord(Wp,Ws,Rp,Rs);           % 计算滤波器的阶数
[b,a]=ellip(n,Rp,Rs,Wn);                % 计算滤波器的系数
fprintf('b=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',b)
fprintf('a=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',a)

[db, mag, pha, grd,w]=freqz_m(b,a);     % 求取频率响应曲线
plot(w/pi*fs/2,db,'k');                 % 作图
grid; ylim([-90 10]);
xlabel('频率/Hz'); ylabel('幅值/dB');
title('椭圆带通滤波器频率响应曲线');

