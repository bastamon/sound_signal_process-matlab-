%实验要求二：绘制声压级曲线
%编写函数实现式（2-4），要求可以输入任意非负响度级时，可得到该响度级对应的声压级曲线，并使用plot函数完成曲线的显示。
clc
clear all
phon=50;

[spl,freq]=iso226(phon);                    %计算声压级

figure(1)
semilogx(freq,spl,':','color','k')
axis([20,20000,-10,130])
title('Phon=50')
xlabel('频率(Hz)')
ylabel('声压级别(dB)')
set(gca,'ytick',-10:10:130)
grid on
box off