%实验要求一：双门限法端点检测
clear all; clc; close all;

[x,fs]=wavread('C4_1_y.wav');                    % 读入数据文件
x=x/max(abs(x));                        % 幅度归一化
N=length(x);                            % 取信号长度
time=(0:N-1)/fs;                        % 计算时间
subplot 311
plot(time,x,'k');         
title('双门限法的端点检测');
ylabel('幅值'); axis([0 max(time) -1 1]); 
xlabel('时间/s');
wlen=200; inc=80;                       % 分帧参数
IS=0.1; overlap=wlen-inc;               % 设置IS
NIS=fix((IS*fs-wlen)/inc +1);           % 计算NIS
fn=fix((N-wlen)/inc)+1;                 % 求帧数
frameTime=FrameTimeC(fn, wlen, inc, fs);% 计算每帧对应的时间
[voiceseg,vsl,SF,NF,amp,zcr]=vad_TwoThr(x,wlen,inc,NIS);  % 端点检测
subplot 312
plot(frameTime,amp,'k');         
ylim([min(amp) max(amp)])
title('短时能量');
ylabel('幅值'); 
xlabel('时间/s');
subplot 313
plot(frameTime,zcr,'k');     
ylim([min(zcr) max(zcr)])
title('短时过零率');
ylabel('幅值'); 
xlabel('时间/s');
for k=1 : vsl                           % 画出起止点位置
    subplot 311
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','b','LineStyle','--');
    subplot 312
    line([frameTime(nx1) frameTime(nx1)],[min(amp) max(amp)],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[min(amp) max(amp)],'color','b','LineStyle','--');    
    subplot 313
    line([frameTime(nx1) frameTime(nx1)],[min(zcr) max(zcr)],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[min(zcr) max(zcr)],'color','b','LineStyle','--');    
end
