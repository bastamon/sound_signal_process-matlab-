function frameout=filpframe(x,win,inc)

[nf,len]=size(x);
nx=(nf-1) *inc+len;                 %原信号长度
frameout=zeros(nx,1);
nwin=length(win);                   % 取窗长
if (nwin ~= 1)                           % 判断窗长是否为1，若为1，即表示没有设窗函数
    winx=repmat(win',nf,1);
    x=x./winx;                          % 除去加窗的影响
    x(find(isinf(x)))=0;                %去除除0得到的Inf
end

sig=zeros((nf-1)*inc+len,1);
for i=1:nf
    start=(i-1)*inc+1;    
    xn=x(i,:)';
    sig(start:start+len-1)=sig(start:start+len-1)+xn;
end
frameout=sig;
