%实验要求一：倒谱法共振峰估计
clear all; clc; close all;

waveFile='C4_3_y.wav';               % 设置文件名
[x, fs, nbits]=wavread(waveFile);                 % 读入一帧数据
u=filter([1 -.99],1,x);                                   % 预加重
wlen=length(u);                                          % 帧长
cepstL=6;                                                   % 倒频率上窗函数的宽度
wlen2=wlen/2;               
freq=(0:wlen2-1)*fs/wlen;                          % 计算频域的频率刻度
u2=u.*hamming(wlen);		                      % 信号加窗函数
U=fft(u2);                                                 % 按式(4-26)计算
U_abs=log(abs(U(1:wlen2)));                     % 按式(4-27)计算
 [Val,Loc,spect]=Formant_Cepst(u2,cepstL);       % 计算出共振峰频率
FRMNT=freq(Loc);                                 % 计算出共振峰频率
subplot(211)
plot(freq,U_abs,'k'); 
xlabel('频率/Hz'); ylabel('幅值/dB');
title('(a)信号对数谱X\_i(k)')
axis([0 4000 -6 2]); grid;
subplot(212)
plot(freq,spect,'k','linewidth',2); 
hold on
xlabel('频率/Hz'); ylabel('幅值/dB');
title('(b)包络线和共振峰值')
fprintf('%5.2f   %5.2f   %5.2f   %5.2f\n',FRMNT);
for k=1 : 4
    subplot(212)
    plot(freq(Loc(k)),Val(k),'kO','linewidth',2);
    line([freq(Loc(k)) freq(Loc(k))],[-6 Val(k)],'color','k',...
        'linestyle','-.','linewidth',2);
end
