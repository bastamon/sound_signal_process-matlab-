%实验要求二：单声源双麦克风的房间冲激响应实验
clear all;
close all;
fs=8000;                                                                    %采样频率
path_length = 256;                                                      %路径长度
mic1=[0.9 1.5 1.5];                                                       %麦克风1位置
mic2=[1.7 1.5 1.5];                                                           %麦克风2位置
n=12;                                                                          %虚拟源个数
r=0.25;                                                                          %反射系数
c=340;                                                                          %声速
rm=[4 4 3];                                                                   %房间尺寸
src=[2.1 2.5 1.5];                                                           %声源位置
h=rir(fs, mic1, n, r, rm, src);
h1=h(1:path_length);

h=rir(fs, mic2, n, r, rm, src);
h2=h(1:path_length);
figure(1);
subplot(2,1,1), plot(h1),axis([1,path_length,-1,1]);
ylabel('幅度')
xlabel('点数')
title('麦克风1的冲激响应')
subplot(2,1,2), plot(h2),axis([1,path_length,-1,1]);
ylabel('幅度')
xlabel('点数')
title('麦克风2的冲激响应')
save ('h.mat', 'h1', 'h2');

