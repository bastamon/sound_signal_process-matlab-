%  实验要求三：倒谱法基音周期检测
clc; close all; clear all;
wlen=320; inc=80;              % 分帧的帧长和帧移
T1=0.05;                       % 设置基音端点检测的参数
[x,fs]=wavread('C4_2_y.wav');                        % 读入wav文件
x=x-mean(x);                                % 消去直流分量
x=x/max(abs(x));                            % 幅值归一化

[voiceseg,vosl,SF,Ef,period]=pitch_Ceps(x,wlen,inc,T1,fs); %基于倒谱法的基音周期检测

fn=length(SF);
time = (0 : length(x)-1)/fs;                % 计算时间坐标
frameTime = FrameTimeC(fn, wlen, inc, fs);  % 计算各帧对应的时间坐标
% 作图
subplot 211, plot(time,x,'k');  title('语音信号')
axis([0 max(time) -1 1]); ylabel('幅值');
subplot 212; plot(frameTime,period,'k');
xlim([0 max(time)]); title('倒谱法基音周期检测'); 
xlabel('时间/s'); ylabel('样点数');
for k=1 : vosl                              % 标出有话段
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
