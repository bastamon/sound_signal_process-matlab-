%小波软阈值函数
function signal=Wavelet_Soft(s,jN,wname)
[c,l]=wavedec(s,jN,wname);
%高频分量的索引
first = cumsum(l)+1;
first1=first;
first = first(end-2:-1:1);
ld   = l(end-1:-1:2);
last = first+ld-1;
%--------------------------------------------------------------------------
%软阈值
cxdsoft=c;
for j=1:jN                                  %j是分解尺度
    flk = first(j):last(j);                 %flk是di在c中的索引
    thr(j)=sqrt(2*log((j+1)/j))*median(c(flk))/0.6745;
    for k=0:(length(flk)-1)             %k是位移尺度
        djk=c(first(j)+k);              %为了简化程序
        absdjk=abs(djk);
        thr1=thr(j);
        if absdjk<thr1
           djk=0;
       else
           djk=sign(djk)*(absdjk-thr1);   
       end  
       cxdsoft(first(j)+k)=djk;
   end             
end
signal=waverec(cxdsoft,l,wname);