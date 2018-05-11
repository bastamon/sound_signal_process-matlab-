%对数频谱距离的端点检测函数
function [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad_LogSpec(signal,noise,NoiseCounter,NoiseMargin,Hangover)
% 设置缺省值
if nargin<4
    NoiseMargin=3;
end
if nargin<5
    Hangover=8;
end
if nargin<3
    NoiseCounter=0;
end
    
% 本帧语音幅值对数频谱和噪声对数频谱之差值
SpectralDist= 20*(log10(signal)-log10(noise));
SpectralDist(find(SpectralDist<0))=0;   % 寻找差值小于0值置为0
 
Dist=mean(SpectralDist);                % 用平均求出Dist
if (Dist < NoiseMargin)                 % Dist 是否小于 NoiseMargin
    NoiseFlag=1;                        % 是，NoiseFlag设为1
    NoiseCounter=NoiseCounter+1;        % NoiseCounter加1
else
    NoiseFlag=0;                        % 否，NoiseFlag设为0
    NoiseCounter=0;                     % NoiseCounter清零
end
 
% 是否NoiseCounter已超出无话段最小长度Hangover
if (NoiseCounter > Hangover)            % NoiseCounter大于Hangover
    SpeechFlag=0;                       % 是，SpeechFlag为0
else 
    SpeechFlag=1;                       % 否，SpeechFlag为1
end 
