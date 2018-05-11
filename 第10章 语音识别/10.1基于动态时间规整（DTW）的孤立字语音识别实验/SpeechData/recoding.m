%pr1_1.m语音采放与显示
fs=16000;                                   %采样频率
duration=2;                                %时间长度
n=duration*fs;
t=(1:n)/fs;
fprintf('Begin by pressing any key %gseconds:\n',duration);pause
fprintf('recording...\n');
y=wavrecord(n,fs);
fprintf('Finish\n');
fprintf('Press any key to play audio:\n');pause
wavplay(y,fs);
wavwrite(y,fs,'9');