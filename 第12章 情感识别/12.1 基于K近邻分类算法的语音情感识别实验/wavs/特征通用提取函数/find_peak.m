%**************************************************************************
%从LPC谱中150-3400的范围内找出四个峰值
%**************************************************************************
function [p,b,amp]=find_peak(Sw,Fs,r)
% [a,Fs]=wavread('u_joe1.wav');
% l=length(a);
% Sw=a(l/2-128:l/2+128);
% r=1;
%求线性预测系数，p为阶数
p=14;
lpcc=lpc(Sw,p);

%当r<1时，计算出的为增强谱
for k=1:1:length(lpcc)
    lpcc(k)=lpcc(k)*r^k;
end


% wavplay(Sw,b);
 result=roots(lpcc);
 result=result(imag(result)>0.001); 
 theta=angle(result);
 fre=abs(theta)*Fs/(2*pi);
 a=polyval(lpcc,result);
  b1=-log(abs(result))*Fs/pi;
 [p,t]=sort(fre);
 
 for i=1:numel(t)
      b(i)=b1(t(i));
 end
        
 for i=1:1:length(p)
      amp(i)=abs(1/a(t(i)));
 end
%只取在150-3400范围内的值
 i=find(p<150);
 j=find(p>7000);
 if (isempty(i)) 
     i=0;
 end
 if(isempty(j))
     j=length(p)+1;
 end
 if (j(1)-i-1)>4
     p=p((i+1):(i+4))';
     b=b((i+1):(i+4));
     amp=amp((i+1):(i+4));
 else
     p=p((i+1):(j(1)-1))';
     b=b((i+1):(j(1)-1));
     amp=amp((i+1):(j(1)-1));
 end
%  %取前四个共振峰
%  p=p(1:4)';
%  amp=amp(1:4);