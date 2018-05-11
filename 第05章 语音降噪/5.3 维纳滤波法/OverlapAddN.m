function ReconstructedSignal=OverlapAddN(XNEW,yphase,wnd,ShiftLen);
if length(wnd)>1
    windowLen=length(wnd);
else
    windowLen=wnd;
end
if nargin<2
    yphase=angle(XNEW);
end
if nargin<3
    windowLen=size(XNEW,1)*2;
end
if nargin<4
    ShiftLen=windowLen/2;
end

[FreqRes FrameNum]=size(XNEW);

Spec=XNEW.*exp(j*yphase);

if mod(windowLen,2) %if FreqResol is odd
    Spec=[Spec;flipud(conj(Spec(2:end,:)))];
else
    Spec=[Spec;flipud(conj(Spec(2:end-1,:)))];
end
SpecIFFT=real(ifft(Spec,windowLen));
ReconstructedSignal=filpframe(SpecIFFT',wnd,ShiftLen);

