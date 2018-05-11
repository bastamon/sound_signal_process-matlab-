%实验要求四：比例法端点检测
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
overlap=wlen-inc;                       % 求重叠区长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数
mode=2;
if mode==1
    th1=1.2;
    th2=2;
    tlable='能零比';
else
     th1=0.05;
    th2=0.1;
    tlable='能熵比';
end
[voiceseg,vsl,SF,NF,Epara]=vad_pro(x,wnd,inc,NIS,th1,th2,mode);     %比例法
fn=length(SF);
frameTime=FrameTimeC(fn, wlen, inc, fs);% 计算各帧对应的时间
subplot 211; 
plot(time,x,'k'); hold on
title('语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 212; plot(frameTime,Epara,'k');  
ylim([min(Epara) max(Epara)])
title(tlable); xlabel('时间/s'); ylabel('幅度');
for k=1 : vsl                         
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 212
    line([frameTime(nx1) frameTime(nx1)],[min(Epara) max(Epara)],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[min(Epara) max(Epara)],'color','b','LineStyle','--');
end

