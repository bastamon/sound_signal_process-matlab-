%倒谱法共振峰估计函数
function [Val,Loc,spect]=Formant_Cepst(u,cepstL)
%Val            共振峰的幅值
%Loc            共振峰的位置
%spect          包络线
%u                一帧输入信号
%cepstL        倒频率上窗函数的宽度
U=fft(u);                                                 % 按式(4-26)计算
wlen2=length(u)/2;                                          % 帧长
U_abs=log(abs(U(1:wlen2)));                     
Cepst=ifft(U_abs);                                    % 按式(4-27)计算
cepst=zeros(1,wlen2);           
cepst(1:cepstL)=Cepst(1:cepstL);              % 按式(4-28)计算
cepst(end-cepstL+2:end)=Cepst(end-cepstL+2:end);
spect=real(fft(cepst));                               % 按式(4-30)计算
[Val,Loc]=findpeaks(spect);                      % 寻找峰值





