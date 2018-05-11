function [y] = linsmoothm(x,n)
if nargin< 2
    n=3;
end
win=hanning(n);                        % 用hanning窗
win=win/sum(win);                      % 归一化 
x=x(:)';                               % 把x转换为行序列

len=length(x);
y= zeros(len,1);                       % 初始化y
% 对x序列前后补n个数,以保证输出序列与x相同长
if mod(n, 2) ==0
    l=n/2;
    x = [ones(1,1)* x(1) x ones(1,l)* x(len)]';
else
    l=(n-1)/2;
    x = [ones(1,1)* x(1) x ones(1,l+1)* x(len)]';
end
% 线性平滑处理
for k=1:len
    y(k) = win'* x(k:k+ n- 1);
end


