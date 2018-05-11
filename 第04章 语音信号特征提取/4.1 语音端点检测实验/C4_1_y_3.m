%实验要求三：谱熵法端点检测
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

th1=0.99;
th2=0.96;
[voiceseg,vsl,SF,NF,Enm]=vad_specEn(x,wnd,inc,NIS,th1,th2,fs);  % 谱熵法  
fn=length(SF);
frameTime=FrameTimeC(fn, wlen, inc, fs);% 计算各帧对应的时间
subplot 211; 
plot(time,x,'k'); hold on
title('语音波形');
ylabel('幅值'); axis([0 max(time) -1 1]);
subplot 212; plot(frameTime,Enm,'k');  
ylim([min(Enm) max(Enm)])
title('短时改进子带谱熵'); xlabel('时间/s'); ylabel('谱熵值');
for k=1 : vsl                         
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','LineStyle','--');
    subplot 212
    line([frameTime(nx1) frameTime(nx1)],[min(Enm) max(Enm)],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[min(Enm) max(Enm)],'color','b','LineStyle','--');
end

