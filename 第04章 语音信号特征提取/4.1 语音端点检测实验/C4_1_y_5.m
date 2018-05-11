%实验要求五：基于对数频谱距离的端点检测
clear all; clc; close all;

IS=0.25;                                % 设置前导无话段长度
wlen=200;                               % 设置帧长为25ms
inc=80;                                 % 求帧移
SNR=10;                                 % 设置信噪比

[xx,fs]=wavread('C4_1_y.wav');                   % 读入数据
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
N=length(x);                            % 取信号长度
time=(0:N-1)/fs;                        % 设置时间
signal=awgn(x,SNR,'measured','db');                % 叠加噪声

wnd=hamming(wlen);                      % 设置窗函数
overlap=wlen-inc;                       % 求重叠区长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

y=enframe(signal,wnd,inc)';             % 分帧
fn=size(y,2);                           % 求帧数
frameTime=FrameTimeC(fn, wlen, inc, fs);% 计算各帧对应的时间

Y=fft(y);                               % FFT变换
Y=abs(Y(1:fix(wlen/2)+1,:));            % 计算正频率幅值
N=mean(Y(:,1:NIS),2);                   % 计算前导无话段噪声区平均频谱
NoiseCounter=0;

for i=1:fn, 
    if i<=NIS                           % 在前导无话段中设置为NF=1,SF=0
        SpeechFlag=0;
        NoiseCounter=100;
        SF(i)=0;
        NF(i)=1;
    else                                % 检测每帧计算对数频谱距离
        [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad_LogSpec(Y(:,i),N,NoiseCounter,2.5,8);   
        SF(i)=SpeechFlag;
        NF(i)=NoiseFlag;
        D(i)=Dist;
    end
end
sindex=find(SF==1);                     % 从SF中寻找出端点的参数完成端点检测
voiceseg=findSegment(sindex);
vosl=length(voiceseg);
% 作图
subplot 311; plot(time,x,'k'); 
title('纯语音波形');
ylabel('幅值'); ylim([-1 1]);
subplot 312; plot(time,signal,'k');
title(['带噪语音 SNR=' num2str(SNR) '(dB)'])
ylabel('幅值'); ylim([-1.2 1.2]);
subplot 313; plot(frameTime,D,'k'); 
xlabel('时间/s'); ylabel('幅值'); 
title('对数频谱距离'); ylim([0 max(D)]);

for k=1 : vosl                           % 标出语音端点
    nx1=voiceseg(k).begin; nx2=voiceseg(k).end;
    fprintf('%4d   %4d   %4d\n',k,nx1,nx2);
    subplot 311
    line([frameTime(nx1) frameTime(nx1)],[-1 1],'color','r','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1 1],'color','b','linestyle','--');
    subplot 313
    line([frameTime(nx1) frameTime(nx1)],[0 max(D)],'color','r','linestyle','-');
    line([frameTime(nx2) frameTime(nx2)],[0 max(D)],'color','b','linestyle','--');
end
