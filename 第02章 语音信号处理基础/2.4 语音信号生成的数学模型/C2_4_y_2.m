%实验要求二：根据共振峰频率绘制二阶谐振曲线
clc
clear all
close all

f = [500 1500 2500];
sampleRate = 8000;
pitch = 100; 
f1=f(1);f2=f(2);f3=f(3);
%冲激函数
yt=zeros(1,8000);
yt(1)=1;

if f1 > 0
        cft = f1/sampleRate;
        bw = 50;
        q = f1/bw;
        rho = exp(-pi * cft / q);
        theta = 2 * pi * cft * sqrt(1-1/(4 * q*q));
        a2 = -2*rho*cos(theta);
        a3 = rho*rho;
        y=filter([1+a2+a3],[1,a2,a3],yt);
end;
figure
N=length(y);
fn=(0:N-1)*sampleRate/N;
fftg=fft(y);
disg=20*log10(abs(fftg));
plot(fn(1:N/2+1),disg(1:N/2+1))
% line([0 sampleRate/2],[0 0])
xlabel('频率/Hz')
ylabel('幅度/dB')
title('(a)第一共振峰的二阶谐振器')

%  根据指定的共振峰频率和带宽(50Hz)建模语音信号中的共振峰
% 第二共振峰
if f2 > 0
        cft = f2/sampleRate;
        bw = 50;
        q = f2/bw;
        rho = exp(-pi * cft / q);
        theta = 2 * pi * cft * sqrt(1-1/(4 * q*q));
        a2 = -2*rho*cos(theta);
        a3 = rho*rho;
        y=filter([1+a2+a3],[1,a2,a3],y);
end;
figure
N=length(y);
fn=(0:N-1)*sampleRate/N;
fftg=fft(y);
disg=20*log10(abs(fftg));
plot(fn(1:N/2+1),disg(1:N/2+1))
% line([0 sampleRate/2],[0 0])
xlabel('频率/Hz')
ylabel('幅度/dB')
title('(b)第二共振峰的二阶谐振器')

%  根据指定的共振峰频率和带宽(50Hz)建模语音信号中的共振峰
% 第三共振峰
if f3 > 0
        cft = f3/sampleRate;
        bw = 50;
        q = f3/bw;
        rho = exp(-pi * cft / q);
        theta = 2 * pi * cft * sqrt(1-1/(4 * q*q));
        a2 = -2*rho*cos(theta);
        a3 = rho*rho;
        y=filter([1+a2+a3],[1,a2,a3],y);
end;
figure
N=length(y);
fn=(0:N-1)*sampleRate/N;
fftg=fft(y);
disg=20*log10(abs(fftg));
plot(fn(1:N/2+1),disg(1:N/2+1))
% line([0 sampleRate/2],[0 0])
xlabel('频率/Hz')
ylabel('幅度/dB')
title('(c)第三共振峰的二阶谐振器')