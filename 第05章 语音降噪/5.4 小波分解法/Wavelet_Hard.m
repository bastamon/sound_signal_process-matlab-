%小波硬阈值函数
function signal=Wavelet_Hard(s,jN,wname)
[c,l]=wavedec(s,jN,wname);
%高频分量的索引
first = cumsum(l)+1;
first1=first;
first = first(end-2:-1:1);
ld   = l(end-1:-1:2);
last = first+ld-1;
%--------------------------------------------------------------------------
%硬阈值
cxdhard=c;
for j=1:jN                                      %j是分解尺度
    flk = first(j):last(j);                      %flk是di在c中的索引
    thr(j)=sqrt(2*log((j+1)/j))*median(c(flk))/0.6745;
    for k=0:(length(flk)-1)                 %k是位移尺度
        djk2=c(first(j)+k);
        absdjk=abs(djk2);
        thr1=thr(j);
        %阈值处理
       if absdjk<thr1
           djk2=0;
       end 
            cxdhard(first(j)+k)=djk2;
   end             
end
signal=waverec(cxdhard,l,wname);