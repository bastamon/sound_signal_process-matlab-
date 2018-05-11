%线性预测法基音周期检测函数
function [voiceseg,vsl,SF,Ef,period]=pitch_Lpc(x,wnd,inc,T1,fs,p,miniL)
if nargin<7, miniL=10; end
if length(wnd)==1
    wlen=wnd;               % 求出帧长
else
    wlen=length(wnd);
end
y  = enframe(x,wnd,inc)';                  % 分帧
[voiceseg,vsl,SF,Ef]=pitch_vad(x,wnd,inc,T1,miniL);   % 基音的端点检测
fn=length(SF);
lmin=fix(fs/500);                           % 基音周期的最小值
lmax=fix(fs/60);                            % 基音周期的最大值
period=zeros(1,fn);                         % 基音周期初始化
for k=1:fn 
    if SF(k)==1                             % 是否在有话帧中
        u=y(:,k).*hamming(wlen);            % 取来一帧数据加窗函数
        ar = lpc(u,p);                      % 计算LPC系数
        z = filter([0 -ar(2:end)],1,u);     % 一帧数据LPC逆滤波输出
        E = u - z;                          % 预测误差
        xx=fft(E);                          % FFT
        a=2*log(abs(xx)+eps);               % 取模值和对数
        b=ifft(a);                          % 求取倒谱 
        [R(k),Lc(k)]=max(b(lmin:lmax));     % 在Pmin～Pmax区间寻找最大值
        period(k)=Lc(k)+lmin-1;             % 给出基音周期
    end
end