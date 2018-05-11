%LPC求根法的共振峰估计函数
function [F,Bw,U]=Formant_Root(u,p,fs,n_frmnt)
%U        频谱曲线
%F               共振峰频率
%Bw            共振峰带宽
%u                一帧输入信号
%p                LPC阶数
%fs                采样频率
%n_frmnt      共振峰个数
a=lpc(u,p);                                 % 求出LPC系数
U=lpcar2pf(a,255);                          % 由LPC系数求出功率谱曲线
df=fs/512;                                  % 频率分辨率

const=fs/(2*pi);                            % 常数  
rts=roots(a);                               % 求根
k=1;                                        % 初始化
yf = [];
bandw=[];
for i=1:length(a)-1                     
    re=real(rts(i));                        % 取根之实部
    im=imag(rts(i));                        % 取根之虚部
    formn=const*atan2(im,re);               
    bw=-2*const*log(abs(rts(i)));           % 按(4-46)计算带宽
    
    if formn>150 & bw <700 & formn<fs/2     % 满足条件方能成共振峰和带宽
        yf(k)=formn;
        bandw(k)=bw;
        k=k+1;
    end
end

[y, ind]=sort(yf);                          % 排序
bw=bandw(ind);
F = zeros(1,n_frmnt);                      % 初始化
Bw = zeros(1,n_frmnt); 
F(1:min(n_frmnt,length(y))) = y(1:min(n_frmnt,length(y)));   % 输出最多四个
Bw(1:min(n_frmnt,length(y))) = bw(1:min(n_frmnt,length(y))); % 输出最多四个
Bw = Bw(:);