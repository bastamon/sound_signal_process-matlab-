%思考题三：卷积函数
function a=my_conv(b,c)
bs=size(b);
cs=size(c);
i=any(bs-cs);
if i
    error('error')
end
i=any(~(bs-1));
if ~i
    error('error')
end
ko=0;
if bs(1)>bs(2)
    b=b';
    c=c';
    ko=1;
end
bs=size(b);
cs=size(c);
ss=2*bs(2)-1;
a=zeros(1,ss);
for i=1:cs(2)
q=zeros(1,i-1);
p=zeros(1,ss-cs(2)+1-i);
ba=[q,c,p];
ma=b(i)*ba;
a=a+ma;
end
if ko
    a=a';
end
end 