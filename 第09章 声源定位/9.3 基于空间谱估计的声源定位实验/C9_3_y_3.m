%实验要求三：不同空间谱估计的声源定位算法比较
clc;
clear all;
close all;
set(0,'defaultaxesfontsize',9);            %设置字体大小
load s.mat;
wnd=256;
inc=128;

[Angle1]=Spectrum_Method('capon',s1,s2,wnd,inc,45);
subplot(311)
plot(Angle1,'*'),axis tight
title('Capon')
xlabel('帧数')
ylabel('角度/度')

[Angle2]=Spectrum_Method('music',s1,s2,wnd,inc,45);
subplot(312)
plot(Angle2,'*'),axis tight
title('Music')
xlabel('帧数')
ylabel('角度/度')

[Angle3]=Spectrum_Method('esprit',s1,s2,wnd,inc,45);
subplot(313)
plot(Angle3,'*'),axis tight
title('Esprit')
xlabel('帧数')
ylabel('角度/度')