function b=freq2mel(f)
%%实现线性频域到mel频域的转换
%输入参数：f为线性频域频率
%输出参数：b为mel频域频率
b=2595*log10(1+f/700);