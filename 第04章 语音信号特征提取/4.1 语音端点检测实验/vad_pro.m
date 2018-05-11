%比例法端点检测函数
function [voiceseg,vsl,SF,NF,Epara]=vad_pro(x,wnd,inc,NIS,th1,th2,mode)

y=enframe(x,wnd,inc)';             % 分帧
fn=size(y,2);                           % 求帧数
if length(wnd)==1
    wlen=wnd;               % 求出帧长
else
    wlen=length(wnd);
end
if mode==1
    aparam=2; bparam=1;                     % 设置参数
    etemp=sum(y.^2);                        % 计算能量
    etemp1=log10(1+etemp/aparam);           % 计算能量的对数值
    zcr=STZcr(x,wnd,inc);                          % 求过零点值
    Ecr=etemp1./(zcr+bparam);               % 计算能零比
    Epara=multimidfilter(Ecr,10);             % 平滑处理
    dth=mean(Epara(1:(NIS)));                % 阈值计算
    T1=1.2*dth;
    T2=2*dth;
else
     aparam=2;                                    % 设置参数
    for i=1:fn
        Sp = abs(fft(y(:,i)));                   % FFT变换取幅值
        Sp = Sp(1:wlen/2+1);	                 % 只取正频率部分
        Esum(i) = log10(1+sum(Sp.*Sp)/aparam);   % 计算对数能量值
        prob = Sp/(sum(Sp));		             % 计算概率
        H(i) = -sum(prob.*log(prob+eps));        % 求谱熵值
        Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));     % 计算能熵比
    end   
    Epara=multimidfilter(Ef,10);                   % 平滑滤波 
%     Epara=Ef;
    Me=max(Epara);                                 % Enm最大值
    eth=mean(Epara(1:NIS));                        % 初始均值eth
    Det=Me-eth;                                  % 求出值后设置阈值
    T1=th1*Det+eth;
    T2=th2*Det+eth;
end
[voiceseg,vsl,SF,NF]=vad_forw(Epara,T1,T2);% 能零比法的双门限端点检测