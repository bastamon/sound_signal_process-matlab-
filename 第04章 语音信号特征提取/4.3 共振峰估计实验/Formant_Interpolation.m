%LPC内插法的共振峰估计函数
function [F,Bw,pp,U]=Formant_Interpolation(u,p,fs)
%pp             共振峰的幅值
%U               频谱曲线
%F               共振峰频率
%Bw            共振峰带宽
%u                一帧输入信号
%p                LPC阶数
%fs                采样频率
a=lpc(u,p);                                         % 求出LPC系数
U=lpcar2pf(a,255);                             % 由LPC系数求出频谱曲线
df=fs/512;                                         % 频率分辨率

[Val,Loc]=findpeaks(U);                     % 在U中寻找峰值
ll=length(Loc);                                  % 有几个峰值
for k=1 : ll
    m=Loc(k);                                     % 设置m-1,m和m+1
    m1=m-1; m2=m+1;
    p=Val(k);                                      % 设置H(m-1),H(m)和H(m+1)
    p1=U(m1); p2=U(m2);
    aa=(p1+p2)/2-p;                         
    bb=(p2-p1)/2;
    cc=p;                                           % 按式(4-34)计算
    dm=-bb/2/aa;                             % 按式(4-35)计算
    pp(k)=-bb*bb/4/aa+cc;              % 按式(4-37)计算
    m_new=m+dm;
    bf=-sqrt(bb*bb-4*aa*(cc-pp(k)/2))/aa;      % 按式(4-42)计算
    F(k)=(m_new-1)*df;                                  % 按式(4-36)计算
    Bw(k)=bf*df;                                            % 按式(4-43)计算
end





