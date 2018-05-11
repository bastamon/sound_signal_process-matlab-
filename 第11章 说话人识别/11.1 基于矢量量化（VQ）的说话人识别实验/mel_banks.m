function H=mel_banks(p,N,fs,fl,fh)
%MEL_BANKS：计算mel滤波器组
% p:mel 滤波阶数   N：fft点数  fs：采样频率
% H：为返回的滤波器组，每一行为一个滤波器
for m=1:p+2
    f(m)=(N/fs)*mel2freq(freq2mel(fl)+(m-1)*(freq2mel(fh)...
        -freq2mel(fl))/(p+1));
end
y=zeros(1,N);
H=zeros(p,N);
for m=2:p+1
    for k=1:N
        if f(m-1)<=k&&k<=f(m)
            y(k)=(k-f(m-1))/(f(m)-f(m-1));
        elseif f(m)<k&&k<=f(m+1)
            y(k)=(f(m+1)-k)/(f(m+1)-f(m));
        else
            y(k)=0;
        end  
    end
     H(m-1,:)=y;
end