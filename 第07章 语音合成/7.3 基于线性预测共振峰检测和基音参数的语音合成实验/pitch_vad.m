% 用于基音周期估计的端点检测函数
function [voiceseg,vosl,SF,Ef]=pitch_vad(x,wnd,inc,T1,miniL)
if nargin<5, miniL=10; end
y=enframe(x,wnd,inc)';             % 分帧
fn=size(y,2);                           % 求帧数
if length(wnd)==1
    wlen=wnd;               % 求出帧长
else
    wlen=length(wnd);
end

for i=1:fn
    Sp = abs(fft(y(:,i)));                    % FFT取幅值
    Sp = Sp(1:wlen/2+1);	                  % 只取正频率部分
    Esum(i) = sum(Sp.*Sp);                    % 计算能量值
    prob = Sp/(sum(Sp));	                  % 计算概率
    H(i) = -sum(prob.*log(prob+eps));         % 求谱熵值
end
hindex=find(H<0.1);
H(hindex)=max(H);
Ef=sqrt(1 + abs(Esum./H));                    % 计算能熵比
Ef=Ef/max(Ef);                                % 归一化

zindex=find(Ef>=T1);                          % 寻找Ef中大于T1的部分
zseg=findSegment(zindex);                     % 给出端点检测各段的信息
zsl=length(zseg);                             % 给出段数
j=0;
SF=zeros(1,fn);
for k=1 : zsl                                 % 在大于T1中剔除小于miniL的部分
    if zseg(k).duration>=miniL
        j=j+1;
        in1=zseg(k).begin;
        in2=zseg(k).end;
        voiceseg(j).begin=in1;
        voiceseg(j).end=in2;
        voiceseg(j).duration=zseg(k).duration;
        SF(in1:in2)=1;                        % 设置SF
    end
end
vosl=length(voiceseg);                        % 有话段的段数 





