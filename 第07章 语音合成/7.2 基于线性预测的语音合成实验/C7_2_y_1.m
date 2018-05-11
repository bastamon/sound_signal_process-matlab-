%实验要求一：基于线性预测系数和预测误差的语音合成实验
clear all; clc; close all;

[x, fs, bits] = wavread('C7_2_y.wav');           % 读入数据文件
x=x-mean(x);                            % 消除直流分量
x=x/max(abs(x));                        % 幅值归一
xl=length(x);                           % 数据长度
time=(0:xl-1)/fs;                       % 计算出时间刻度
p=12;                                   % LPC的阶数为12
wlen=200; inc=80;                       % 帧长和帧移
msoverlap = wlen - inc;                 % 每帧重叠部分的长度
y=enframe(x,wlen,inc)';                 % 分帧
fn=size(y,2);                           % 取帧数
% 语音分析:求每一帧的LPC系数和预测误差
for i=1 : fn                            
    u=y(:,i);                           % 取来一帧
    A=lpc(u,p);                         % LPC求得系数
    aCoeff(:,i)=A;                      % 存放在aCoeff数组中
    errSig = filter(A,1,u);             % 计算预测误差序列
    resid(:,i) = errSig;                % 存放在resid数组中
end
% 语音合成:求每一帧的合成语音叠接成连续语音信号
for i=1:fn                              
    A = aCoeff(:,i);                    % 取得该帧的预测系数
    residFrame = resid(:,i);            % 取得该帧的预测误差
    synFrame(i,:) = filter(1, A', residFrame); % 预测误差激励,合成语音
end;
outspeech=Filpframe_OverlapS(synFrame,wlen,inc);
ol=length(outspeech);
if ol<xl                                % 把outspeech补零,使与x等长
    outspeech=[outspeech zeros(1,xl-ol)];
else
    outspeech=outspeech(1:xl);
end

% 作图
subplot 211; plot(time,x,'k');
xlabel(['时间/s']); ylabel('幅值'); ylim([-1 1.1]);
title('(a)原始语音信号')
subplot 212; plot(time,outspeech,'k');
xlabel(['时间/s' ]); ylabel('幅值'); ylim([-1 1.1]);
title('(b)合成的语音信号')


