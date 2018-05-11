function output=SpectralSub(signal,wlen,inc,NIS,a,b)
wnd=hamming(wlen);                      % 设置窗函数
N=length(signal);                       % 计算信号长度

y=enframe(signal,wnd,inc)';             % 分帧
fn=size(y,2);                           % 求帧数

y_fft = fft(y);                         % FFT
y_a = abs(y_fft);                       % 求取幅值
y_phase=angle(y_fft);                   % 求取相位角
y_a2=y_a.^2;                            % 求能量
Nt=mean(y_a2(:,1:NIS),2);               % 计算噪声段平均能量
nl2=wlen/2+1;                           % 求出正频率的区间

for i = 1:fn;                           % 进行谱减
    for k= 1:nl2
        if y_a2(k,i)>a*Nt(k)
            temp(k) = y_a2(k,i) - a*Nt(k);
        else
            temp(k)=b*y_a2(k,i);
        end
        U(k)=sqrt(temp(k));             % 把能量开方得幅值
    end
    X(:,i)=U;
end;
output=OverlapAdd2(X,y_phase(1:nl2,:),wlen,inc);   % 合成谱减后的语音
Nout=length(output);                    % 把谱减后的数据长度补足与输入等长
if Nout>N
    output=output(1:N);
elseif Nout<N
    output=[output; zeros(N-Nout,1)];
end
output=output/max(abs(output));         % 幅值归一