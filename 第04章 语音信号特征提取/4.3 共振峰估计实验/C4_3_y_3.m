% LPC求根法的共振峰估计
clear all; clc; close all;

fle='C4_3_y.wav';                            % 指定文件名
[xx,fs]=wavread(fle);                       % 读入一帧语音信号
u=filter([1 -.99],1,xx);                    % 预加重
wlen=length(u);                             % 帧长
p=12;                                       % LPC阶数
n_frmnt=4;                                  % 取四个共振峰
freq=(0:256)*fs/512;                        % 频率刻度
df=fs/512;                                  % 频率分辨率

[F,Bw,U]=Formant_Root(u,p,fs,n_frmnt);
plot(freq,U,'k');
title('声道传递函数功率谱曲线');
xlabel('频率/Hz'); ylabel('幅值/dB');
p1=length(F);                              % 在共振峰处画线
m=floor(F/df);
pp=U(m);                                    %共振峰幅度
for k=1 : p1
    line([F(k) F(k)],[-5 pp(k)],'color','k','linestyle','-.');
end
legend('功率谱','共振峰位置')
fprintf('F0=%5.2f   %5.2f   %5.2f   %5.2f\n',F);
fprintf('Bw=%5.2f   %5.2f   %5.2f   %5.2f\n',Bw);

