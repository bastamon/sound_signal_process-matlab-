%-----------------------------------------------------------------------
%逐帧提取共振峰
%-----------------------------------------------------------------------
function [formant_frame,bw_frame]=formant_get(speech,samplerate)
M=160;%帧移
%[speech,samplerate]=wavread('e.wav');
[begin,last]=voicemark(speech);
%提取共振峰频率和带宽
[s,s_bw,s_amp]=pick_peak(speech,samplerate);
%对频率和带宽进行平滑
[formant_frame,bw_frame]=smoothing(s,s_bw);

%%开始对共振峰进行处理，静音段置0
%------------首先判断分帧后哪些帧是非静音段
frame_num=size(formant_frame,1);
frame_begin=0;%起始帧
frame_last=0;%结束帧
%%%%%确定起始帧
for i=1:frame_num
    if begin<=(i-1)*M+1
        break;
    end
    frame_begin=frame_begin+1;
end
%%%%%确定结束帧
for i=1:frame_num
    if last<=(i-1)*M+1
        break;
    end
    frame_last=frame_last+1;
end
%根据起始帧和结束帧对共振峰数据进行处理
for i=1:frame_begin-1
    formant_frame(i,:)=zeros(1,4);
end
for i=frame_last:frame_num
    formant_frame(i,:)=zeros(1,4);
end
 frame_last=frame_last-1;
 formant_frame = formant_frame(frame_begin:frame_last,:);
%------------------------------------------------------------