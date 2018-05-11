%LPC内插法的共振峰估计
clear all; clc; close all;

fle='C4_3_y.wav';                            % 指定文件名
[x,fs]=wavread(fle);                        % 读入一帧语音信号 
u=filter([1 -.99],1,x);                     % 预加重
wlen=length(u);                             % 帧长
p=12;                                       % LPC阶数
freq=(0:256)*fs/512;                        % 频率刻度

[F,Bw,pp,U]=Formant_Interpolation(u,p,fs);          %LPC内插法求共振峰
plot(freq,U,'k');
title('声道传递函数功率谱曲线');
xlabel('频率/Hz'); ylabel('幅值');
ll=length(F);                             % 共振峰个数
for k=1 : ll
    line([F(k) F(k)],[0 pp(k)],'color','k','linestyle','-.');    
end
legend('功率谱','共振峰位置')
fprintf('F =%5.2f   %5.2f   %5.2f   %5.2f\n',F)
fprintf('Bw=%5.2f   %5.2f   %5.2f   %5.2f\n',Bw)
