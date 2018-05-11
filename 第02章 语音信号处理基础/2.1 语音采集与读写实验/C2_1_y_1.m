%语音采集与读写实验
fs=16000;                                   %采样频率
duration=2;                                %时间长度
n=duration*fs;
t=(1:n)/fs;
fprintf('Begin by pressing any key %gseconds:\n',duration);pause
fprintf('recording...\n');
y=wavrecord(n,fs,'double');
ymax=max(abs(y));                         %归一化
y=y/ymax;
fprintf('Finish\n');
fprintf('Press any key to play audio:\n');pause
wavplay(y,fs);
wavwrite(y,fs,'C2_1_y');
figure(1);
axis([0 2 -1 1]);
plot(t,y);
xlabel('time/s');
ylabel('amplitude');