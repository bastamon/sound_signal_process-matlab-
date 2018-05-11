%消除线性趋势项函数
function [y,xtrend]=detrendN(x, fs, m)
x=x(:);                             % 把语音信号x转换为列数据
N=length(x);                    % 求出x的长度
t= (0: N-1)'/fs;                % 按x的长度和采样频率设置时间序列
a=polyfit(t, x, m);             % 用最小二乘法拟合语音信号x的多项式系数a
xtrend=polyval(a, t);       % 用系数a和时间序列t构成趋势项
y=x-xtrend;                     % 从语音信号x中清除趋势项