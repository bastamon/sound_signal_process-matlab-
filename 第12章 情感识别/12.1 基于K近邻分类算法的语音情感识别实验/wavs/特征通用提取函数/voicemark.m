% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 对语音信号进行端点检测
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [begin,last]=voicemark(speech)
%归一化处理 双声道处理，提取一个声道
%确定帧长framelength
%framelength=0.025;
point=400;
c=max(abs(speech));
speech=speech/c;

%计算帧数
n=floor(length(speech)/point);  
enframe=zeros(point,n);

%分帧，每一帧400个点
for i=1:n;
 for j=1:point;
   enframe(j,i)=speech(j+(i-1)*point);
 end
end

%计算每一帧的短时能量
for i=1:n;   
  energy_short(i)=sum(enframe(:,i).^2);
end

%短时能量归一化
a=max(energy_short);
energy_short=energy_short/a;

%寻找语音起点
for i=1:n;   
  if energy_short(i)>0.2 break;  
  end
end
frame_begin=i;
begin=(i-1)*point+1;

%寻找语音终点
for i=n:-1:1;   
  if energy_short(i)>0.2 break; 
  end
end

last=i*point;
% if last>length(speech)
%     last=length(speech);
% end