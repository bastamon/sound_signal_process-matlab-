%实验要求：时延估计算法对比实验
clear all;
close all;
clc
load s.mat;
s1=s1_10db(:)';             %变为行向量
s2=s2_10db(:)';             %变为行向量
wnd=512;
inc=256;

[delay]=GCC_Method('standard',s1,s2,wnd,inc);
subplot(411)
plot(delay-wnd,'*')
ylim([0,12])
title('标准GCC')
xlabel('帧数')
ylabel('延时/点')

[delay]=GCC_Method('phat',s1,s2,wnd,inc);
subplot(412)
plot(delay-wnd,'*')
ylim([0,12])
title('Phat-GCC')
xlabel('帧数')
ylabel('延时/点')

[delay]=GCC_Method('scot',s1,s2,wnd,inc);
subplot(413)
plot(delay-wnd,'*')
ylim([0,12])
title('Scot-GCC')
xlabel('帧数')
ylabel('延时/点')

[delay]=GCC_Method('ml',s1,s2,wnd,inc);
 subplot(414)
plot(delay-wnd,'*')
ylim([0,12])
title('Ml-GCC')
xlabel('帧数')
ylabel('延时/点')


    
