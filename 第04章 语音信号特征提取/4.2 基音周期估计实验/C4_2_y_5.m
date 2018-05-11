% 实验要求五：线性预测法进行基音周期检测
clc; close all; clear all;

wlen=320; inc=80;              % 分帧的帧长和帧移
T1=0.05;                       % 设置基音端点检测的参数
p=12;                           % 设置线性预测阶数
[x,fs]=wavread('C4_2_y.wav');                        % 读入wav文件
x=x-mean(x);                                % 消去直流分量
x=x/max(abs(x));                            % 幅值归一化

[voiceseg,vosl,SF,Ef,period]=pitch_Lpc(x,wlen,inc,T1,fs,p); %基于线性预测法的基音周期检测

fn=length(SF);
time = (0 : length(x)-1)/fs;                % 计算时间坐标
frameTime = FrameTimeC(fn, wlen, inc, fs);  % 计算各帧对应的时间坐标
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); grid;  ylabel('幅值'); xlabel('时间/s');
subplot 212; hold on
plot(frameTime,period,'k'); 
axis([0 max(time) 0 150]); title('线性预测法基音检测'); 
ylabel('样点数'); xlabel('时间/s'); grid; 
for k=1 : vosl
    nx1=voiceseg(k).begin;
    nx2=voiceseg(k).end;
    nxl=voiceseg(k).duration;
    fprintf('%4d   %4d   %4d   %4d\n',k,nx1,nx2,nxl);
    subplot 211
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','linestyle','--');
    subplot 212
    line([frameTime(nx1) frameTime(nx1)],[0 150],'color','r','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 150],'color','b','linestyle','--');
end