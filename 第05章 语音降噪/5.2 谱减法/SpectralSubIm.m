function output=SpectralSubIm(signal,wind,inc,NIS,Gamma,Beta)

nwin=length(wind);
if (nwin == 1)              % 判断窗长是否为1，若为1，即表示没有设窗函数
   W = wind;               % 是，帧长=wind
   wnd=hamming(W);
else
   W = nwin;              % 否，帧长=窗长
   wnd=wind;
end
nfft=W;

y=enframe(signal,W,inc)';
Y=fft(y,nfft);
YPhase=angle(Y(1:fix(end/2)+1,:));          %含噪语音的相位
Y=abs(Y(1:fix(end/2)+1,:)).^Gamma;      %功率谱
numberOfFrames=size(Y,2);

N=mean(Y(:,1:NIS)')';                           %初始的能量谱均值D(k)
NRM=zeros(size(N));                           %噪声残余量最大值
NoiseCounter=0;
NoiseLength=9;                                  %噪声平滑因子


YS=Y;                                               %平均谱值
for i=2:(numberOfFrames-1)
    YS(:,i)=(Y(:,i-1)+Y(:,i)+Y(:,i+1))/3;
end

for i=1:numberOfFrames
    [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad_LogSpec(Y(:,i).^(1/Gamma),N.^(1/Gamma),NoiseCounter);       %基于频谱距离的VAD检测
    if SpeechFlag==0
        N=(NoiseLength*N+Y(:,i))/(NoiseLength+1);                               %更新并平滑噪声
        NRM=max(NRM,YS(:,i)-N);                                                          %更新最大的噪声残余
        X(:,i)=Beta*Y(:,i);
    else
        D=YS(:,i)-N;                                                                                 %谱减
        if i>1 && i<numberOfFrames                                                      %减少噪声残留项            
            for j=1:length(D)
                if D(j)<NRM(j)
                    D(j)=min([D(j) YS(j,i-1)-N(j) YS(j,i+1)-N(j)]);
                end
            end
        end
        X(:,i)=max(D,0);
    end
end
output=OverlapAdd2(X.^(1/Gamma),YPhase,W,inc);



