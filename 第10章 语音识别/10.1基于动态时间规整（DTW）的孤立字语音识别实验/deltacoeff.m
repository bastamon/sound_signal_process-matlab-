function diff = deltacoeff(x)
%计算MFCC差分系数
[nr,nc]=size(x);
N=2;
diff=zeros(nr,nc);
for t=3:nr-2
    for n=1:N
    diff(t,:)=diff(t,:)+n*(x(t+n,:)-x(t-n,:));
    end
    diff(t,:)=diff(t,:)/10;       %10=2*(1^2+2^2)
end