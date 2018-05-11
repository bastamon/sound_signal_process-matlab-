% 从LPC计算线性预测倒谱系数的函数
function lpcc=lpc_lpccm(ar,n_lpc,n_lpcc)          
lpcc=zeros(n_lpcc,1);
lpcc(1)=ar(1);                                    % 计算n=1的lpcc
for n=2:n_lpc                                     % 计算n=2,...,p的lpcc
    lpcc(n)=ar(n);
    for l=1:n-1
        lpcc(n)=lpcc(n)+ar(l)*lpcc(n-l)*(n-l)/n;
    end
end

for n=n_lpc+1:n_lpcc                              % 计算n>p的lpcc
    lpcc(n)=0;
    for l=1:n_lpc
        lpcc(n)=lpcc(n)+ar(l)*lpcc(n-l)*(n-l)/n;
    end
end
lpcc=-lpcc;