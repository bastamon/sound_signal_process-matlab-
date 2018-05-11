%实验要求一：线性预测系数对比
clear all; clc; close all;

[x,fs]=wavread('C3_5_y.wav');    % 读入语音数据
L=240;                                      % 帧长
y=x(8001:8000+L);                   % 取一帧数据
p=12;                                       % LPC的阶数
ar1=lpc(y,p);                            % MATLAB自带函数进行线性预测变换
ar2=lpc_coeff(y,p);                  % 编写的函数进行线性预测变换
est_x1=filter([0 -ar1(2:end)],1,y);       % 用LPC求预测估算值
est_x2=filter([0 -ar2(2:end)],1,y);       % 用编写函数求预测估算值
err1=y-est_x1;                            % LPC的预测误差
err2=y-est_x2;                            % 编写函数的预测误差

subplot 321; plot(x,'k'); axis tight;
title('(a)元音/a/波形'); ylabel('幅值')
subplot 322; plot(y,'k'); xlim([0 L]); 
title('(b)一帧数据'); ylabel('幅值')
subplot 323; plot(est_x1,'k'); xlim([0 L]); 
title('(c)LPC预测值'); ylabel('幅值')
subplot 324; plot(est_x2,'k'); xlim([0 L]); 
title('(d)lpc\_coeff预测值'); ylabel('幅值')
subplot 325; plot(err1,'k'); xlim([0 L]); 
title('(e)LPC预测误差'); ylabel('幅值'); xlabel('样点')
subplot 326; plot(err2,'k'); xlim([0 L]); 
title('(f)lpc\_coeff预测误差'); ylabel('幅值'); xlabel('样点')









