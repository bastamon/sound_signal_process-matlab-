%基于比例重叠相加法的信号还原函数
function frameout=Filpframe_LinearA(x,win,inc)

[nf,len]=size(x);
nx=(nf-1) *inc+len;                 %原信号长度
frameout=zeros(nx,1);
nwin=length(win);                   % 取窗长
overlap=nwin-inc;                         % 重叠长度
tempr1=(0:overlap-1)'/overlap;            % 斜三角窗函数w1
tempr2=(overlap-1:-1:0)'/overlap;         % 斜三角窗函数w2
if (nwin ~= 1)                           % 判断窗长是否为1，若为1，即表示没有设窗函数
    winx=repmat(win',nf,1);
    x=x./winx;                          % 除去加窗的影响
    x(find(isinf(x)))=0;                %去除除0得到的Inf
end

for i=1:nf
    xn=x(i,:)';
    if i==1                           % 若为第1帧
        frameout=x(i,:)';            % 不需要重叠相加,保留合成数据
    else
        M=length(frameout);             % 按线性比例重叠相加处理合成数据
        frameout=[frameout(1:M-overlap); frameout(M-overlap+1:M).*tempr2+xn(1:overlap).*tempr1; xn(overlap+1:nwin)];
    end
end

