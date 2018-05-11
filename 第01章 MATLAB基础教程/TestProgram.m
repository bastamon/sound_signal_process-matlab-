clc
clear all
%***************1.正弦波****************%
fs =100;                                            %设定采样频率
N =128;
n =0:N -1;
t = n/ fs;
f0 =10;                                             %设定正弦信号频率
%生成正弦信号
x = sin(2*pi*f0*t);
figure(1);
subplot(231);
plot(t,x); %作正弦信号的时域波形
xlabel('时间/ s');
ylabel('幅值');
title('时域波形');
grid;
%进行FFT 变换并做频谱图
y = fft(x,N);                                       %进行FFT 变换
mag = abs(y);                                   %求幅值
f = (0:length(y) -1)'*fs/ length(y);        %进行对应的频率转换
subplot(232);
plot(f,mag);                                        %作频谱图
axis([0,100,0,80]);
xlabel('频率/ Hz');
ylabel('幅值');
title('幅频谱图');
grid;
%求均方根谱
sq = abs(y);
subplot(233);
plot(f,sq);
xlabel('频率/ Hz');
ylabel('均方根谱');
title('均方根谱');
grid;
%求功率谱
power = sq.^2;
subplot(234);
plot(f,power);
xlabel('频率/ Hz');
ylabel('功率谱');
title('功率谱');
grid;
%求对数谱
ln = log(sq);
subplot(235);
plot(f,ln);
xlabel('频率/ Hz');
ylabel('对数谱');
title('对数谱');
grid;
%用IFFT 恢复原始信号
xifft = ifft(y);
magx = real(xifft);
ti = [0:length(xifft)-1] / fs;
subplot(236);
plot(ti,magx);
xlabel('时间/ s');
ylabel('幅值');
title('IFFT 后的信号波形');
grid;
%****************2.白噪声****************%
fs =50;                                              %设定采样频率
t = -5:0.1:5;
x = rand(1,100);
figure(2);
subplot(231);
plot(t(1:100),x);                               %作白噪声的时域波形
xlabel('时间(s)');
ylabel('幅值');
title('时域波形');
grid;
%进行FFT 变换并做频谱图
y = fft(x);                                     %进行FFT 变换
mag = abs(y);                               %求幅值
f = (0:length(y) -1)'*fs/ length(y); %进行对应的频率转换
subplot(232);
plot(f,mag);                                    %作频谱图
xlabel('频率/ Hz');
ylabel('幅值');
title('幅频谱图');
grid;
%求均方根谱
sq = abs(y);
subplot(233);
plot(f,sq);
xlabel('频率/ Hz');
ylabel('均方根谱');
title('均方根谱');
grid;
%求功率谱
power = sq.^2;
subplot(234);
plot(f,power);
xlabel('频率/ Hz');
ylabel('功率谱');
title('功率谱');
grid;
%求对数谱
ln = log(sq);
subplot(235);
plot(f,ln);
xlabel('频率/ Hz');
ylabel('对数谱');
title('对数谱');
grid;
%用IFFT 恢复原始信号
xifft = ifft(y);
magx = real(xifft);
ti = [0:length(xifft)-1] / fs;
subplot(236);
plot(ti,magx);
xlabel('时间/ s');
ylabel('幅值');
title('IFFT 后的信号波形');
grid;