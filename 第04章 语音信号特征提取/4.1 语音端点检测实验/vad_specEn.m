%谱熵法端点检测函数
function [voiceseg,vsl,SF,NF,Enm]=vad_specEn(x,wnd,inc,NIS,th1,th2,fs)

y=enframe(x,wnd,inc)';             % 分帧
fn=size(y,2);                           % 求帧数
if length(wnd)==1
    wlen=wnd;               % 求出帧长
else
    wlen=length(wnd);
end
df=fs/wlen;                             % 求出FFT后频率分辨率
fx1=fix(250/df)+1; fx2=fix(3500/df)+1;  % 找出250Hz和3500Hz的位置
km=floor(wlen/8);                       % 计算出子带个数
K=0.5;                                  % 常数K
for i=1:fn
    A=abs(fft(y(:,i)));                 % 取来一帧数据FFT后取幅值
    E=zeros(wlen/2+1,1);            
    E(fx1+1:fx2-1)=A(fx1+1:fx2-1);      % 只取250～3500Hz之间的分量
    E=E.*E;                             % 计算能量
    P1=E/sum(E);                        % 幅值归一化
    index=find(P1>=0.9);                % 寻找是否有分量的概率大于0.9
    if ~isempty(index), E(index)=0; end % 若有,该分量置0
    for m=1:km                          % 计算子带能量
        Eb(m)=sum(E(4*m-3:4*m));
    end
    prob=(Eb+K)/sum(Eb+K);              % 计算子带概率
    Hb(i) = -sum(prob.*log(prob+eps));  % 计算子带谱熵
end   
Enm=multimidfilter(Hb,10);              % 平滑处理
Me=min(Enm);                            % 设置阈值
eth=mean(Enm(1:NIS));
Det=eth-Me;
T1=th1*Det+Me;
T2=th2*Det+Me;

[voiceseg,vsl,SF,NF]=vad_revr(Enm,T1,T2);