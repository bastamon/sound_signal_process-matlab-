%**************************************************************************
%对语音信号进行预处理,得到分帧后的信号
%**************************************************************************
function Sw=pre(sound,samplerate)
% addpath('E:\xin\speechstuff\sysbatch\Voicebox');

%用短时能量对语音信号进行端点检测
% % % % % % % % % [begin,last]=voicemark(sound)
% % % % % % % % % sound=sound(fix((begin+(last-begin)/4)):fix((last-(last-begin)/4)));
% r=1;
%p:峰值对应的频率
%amp:峰值对应的幅度

%对语音信号进行预加重
%Y(z)/X(z)=H(z)=1-0.98z^(-1)---Y(z)/X(z)=H(z)=1-0.94z^(-1)
%预加重后的结果放在voice中
voice(1)=sound(1);
for t=2:1:length(sound)
    voice(t)=sound(t)-0.98*sound(t-1);
end

%对语音信号进行分帧处理。根据短时特性，帧长定为25ms,基于该实验采样率Fs=16kHz
%这就相应于每帧有400个信号样值
frame_length=0.025;                                         %%幀长 
point=samplerate*frame_length;
%为了使帧与帧之间平滑过渡，采用交叠分段的方法(帧移)
%暂定帧移与帧长的比值为10ms/25ms=0.4
frameinc=round(point*0.4);
%语音信号的帧数
Sw=enframe(voice,point,frameinc);

%hamming窗
for t=1:point
    hamming_window(t)=0.54-0.46*cos(2*pi*(t-1)/(point-1));
end

[x,y]=size(Sw);
for t=1:1:x
    for j=1:1:y
    Sw(t,j)=Sw(t,j)*hamming_window(j);
    end
end