%求预测系数ar的复频谱
function ff=lpcff(ar,np)

[nf,p1]=size(ar);
if nargin<2 np=p1-1; end
ff=(fft(ar.',2*np+2).').^(-1);
ff=ff(1:length(ff)/2);

