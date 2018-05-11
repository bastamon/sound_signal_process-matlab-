function [G] = GCC_Method(m,s1,s2,wnd,inc)
% m            预白化滤波器类型：'standard','roth','scot','phat','ml'
%s1,s2         两个输入信号
% Fs           采样频率 (Hz)
% wnd        窗函数或帧长
% inc           帧移
%
% G            估计的时延值

N=wnd;
wnd=hamming(N);
x=enframe(s1,wnd,inc);
y=enframe(s2,wnd,inc);
n_frame=size(x,1);

switch lower(m)
    case 'standard'
        % 标准GCC
    for i=1:n_frame
        x = s1(i:i+N);
        y = s2(i:i+N);
        X=fft(x,2*N-1);
        Y=fft(y,2*N-1);
        Sxy=X.*conj(Y);
        gain=1;
        Cxy=fftshift(ifft(Sxy.*gain));
        [Gvalue(i),G(i)]=max(Cxy);%求出最大值max,及最大值所在的位置（第几行）location;
    end;
    
    case 'roth'
        % Roth filter
    for i=1:n_frame
        x = s1(i:i+N);
        y = s2(i:i+N);
        X=fft(x,2*N-1);
        Y=fft(y,2*N-1);
        Sxy=X.*conj(Y);
        Sxx=X.*conj(X);
        gain=1./abs(Sxx);
        Cxy=fftshift(ifft(Sxy.*gain));
        [Gvalue(i),G(i)]=max(Cxy);%求出最大值max,及最大值所在的位置（第几行）location;
    end;

    case 'scot'
        % Smoothed Coherence Transform (SCOT)
    for i=1:n_frame
        x = s1(i:i+N);
        y = s2(i:i+N);
        X=fft(x,2*N-1);
        Y=fft(y,2*N-1);
        Sxy=X.*conj(Y);
        Sxx=X.*conj(X);
        Syy=Y.*conj(Y);
        gain=1./sqrt(Sxx.*Syy);
        Cxy=fftshift(ifft(Sxy.*gain));
        [Gvalue(i),G(i)]=max(Cxy);%求出最大值max,及最大值所在的位置（第几行）location;
    end;
    
    case 'phat'
        % Phase Transform (PHAT)
    for i=1:n_frame
        x = s1(i:i+N);
        y = s2(i:i+N);
        X=fft(x,2*N-1);
        Y=fft(y,2*N-1);
        Sxy=X.*conj(Y);
        gain=1./abs(Sxy);
        Cxy=fftshift(ifft(Sxy.*gain));
        [Gvalue(i),G(i)]=max(Cxy);%求出最大值max,及最大值所在的位置（第几行）location;
    end;

    case 'ml'
        % 最大似然加权函数
    for i=1:n_frame
        x = s1(i:i+N);
        y = s2(i:i+N);
        X=fft(x,2*N-1);
        Y=fft(y,2*N-1);
        Sxy=X.*conj(Y);
        Sxx=X.*conj(X);
        Syy=Y.*conj(Y);
        Zxy=(Sxy.*Sxy)/(Sxx.*Syy);
        gain=(1./abs(Sxy)).*((Zxy.^2)./(1-Zxy.^2));
        Cxy=fftshift(ifft(Sxy.*gain));
        [Gvalue(i),G(i)]=max(Cxy);%求出最大值max,及最大值所在的位置（第几行）location;
    end;        
    otherwise error('Method not defined...');
end


