%实验要求二：自相关法端点检测
clear all; clc; close all;
IS=0.25;                                % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 求帧移

[xx,fs]=wavread('C4_1_y');                   % 读入数据
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
N=length(x);                            % 取信号长度
time=(0:N-1)/fs;                        % 设置时间
wnd=hamming(wlen);                      % 设置窗函数
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

% y=enframe(x,wnd,inc)';             % 分帧
% fn=size(y,2);                           % 求帧数
th1=1.1;
th2=1.3;
[voiceseg,vsl,SF,NF,Rum]=vad_corr(x,wnd,inc,NIS,th1,th2);% 自相关函数的端点检测
fn=length(SF);
frameTime=FrameTimeC(fn, wlen, inc, fs);% 计算各帧对应的时间
% 作图
subplot 211; plot(time,x,'k');
title('纯语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 212; plot(frameTime,Rum,'k');
title('短时自相关函数'); axis([0 max(time) 0 1]);
xlabel('时间/s'); ylabel('幅值'); 
for k=1 : vsl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    subplot 211; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 212; 
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
end



