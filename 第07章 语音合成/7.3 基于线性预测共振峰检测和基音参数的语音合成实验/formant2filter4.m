function [An,Bn]=formant2filter4(F0,Bw,fs)
F0(4)=3500; Bw(4)=100;
for k=1 : 4                        % 处理三个共振峰和一个固定峰值
    f0=F0(k); bw=Bw(k);            % 取来共振峰频率和带宽
    [A,B]=frmnt2coeff3(f0,bw,fs);  % 计算带通滤波器系数
    An(:,k)=A;                     % 存放在An和Bn中
    Bn(k)=B;
end
