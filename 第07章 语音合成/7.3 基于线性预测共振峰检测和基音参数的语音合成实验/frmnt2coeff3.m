function [A,B]=frmnt2coeff3(f0,bw,fs)
R = exp(-pi*bw/fs);                               % 按式(10-5-17)计算极值的模值
theta = 2*pi*f0/fs;                               % 按式(10-5-16)计算极值的相角
poles = R.* exp(j*theta);                         % 构成复数极点
A = real(poly([poles,conj(poles)]));              % 按式(10-5-18)计算分母系数
B=abs(A(1)+A(2)*exp(j*theta)+A(3)*exp(j*2*theta));% 按式(10-5-19)计算b0


