%实验要求：基于线性预测共振峰检测和基音参数的语音合成
clear all; clc; close all;

[xx,fs]=wavread('C7_3_y.wav');                     % 读取文件
xx=xx-mean(xx);                           % 去除直流分量
x1=xx/max(abs(xx));                       % 归一化
x=filter([1 -.99],1,x1);                  % 预加重
N=length(x);                              % 数据长度
time=(0:N-1)/fs;                          % 信号的时间刻度
wlen=240;                                 % 帧长
inc=80;                                   % 帧移
overlap=wlen-inc;                         % 重叠长度
tempr1=(0:overlap-1)'/overlap;            % 斜三角窗函数w1
tempr2=(overlap-1:-1:0)'/overlap;         % 斜三角窗函数w2
n2=1:wlen/2+1;                            % 正频率的下标值
wind=hamming(wlen);                       % 窗函数
X=enframe(x,wlen,inc)';                   % 分帧
fn=size(X,2);                             % 帧数
Etemp=sum(X.*X);                          % 计算每帧的能量
Etemp=Etemp/max(Etemp);                   % 能量归一化
T1=0.1; r2=0.5;                           % 端点检测参数
miniL=10;                                 % 有话段最短帧数
mnlong=5;                                 % 元音主体最短帧数
ThrC=[10 15];                             % 阈值
p=12;                                     % LPC阶次
frameTime=FrameTimeC(fn,wlen,inc,fs);     % 计算每帧的时间刻度
Doption=0;                                

% 用主体-延伸法基音检测
[voiceseg,vosl,SF,Ef,period]=pitch_Ceps(x,wlen,inc,T1,fs); %基于倒谱法的基音周期检测
Dpitch=pitfilterm1(period,voiceseg,vosl);       % 对T0进行平滑处理求出基音周期T0

%% 共振峰提取
for i=1:length(SF)
    [Frmt(:,i),Bw(:,i),U(:,i)]=Formant_Root(X(:,i),p,fs,3);
end
%% 语音合成
zint=zeros(2,4);                          % 初始化
tal=0;
for i=1 : fn
    yf=Frmt(:,i);                         % 取来i帧的三个共振峰频率和带宽
    bw=Bw(:,i);
    [an,bn]=formant2filter4(yf,bw,fs);    % 转换成四个二阶滤波器系数
    synt_frame=zeros(wlen,1);
    
    if SF(i)==0                           % 无话帧
        excitation=randn(wlen,1);         % 产生白噪声
        for k=1 : 4                       % 对四个滤波器并联输入
            An=an(:,k);
            Bn=bn(k);
            [out(:,k),zint(:,k)]=filter(Bn(1),An,excitation,zint(:,k));
            synt_frame=synt_frame+out(:,k); % 四个滤波器输出叠加在一起
        end
    else                                  % 有话帧
        PT=round(Dpitch(i));              % 取周期值
        exc_syn1 =zeros(wlen+tal,1);      % 初始化脉冲发生区
        exc_syn1(mod(1:tal+wlen,PT)==0)=1;% 在基音周期的位置产生脉冲，幅值为1
        exc_syn2=exc_syn1(tal+1:tal+inc); % 计算帧移inc区间内的脉冲个数
        index=find(exc_syn2==1);
        excitation=exc_syn1(tal+1:tal+wlen);% 这一帧的激励脉冲源
        
        if isempty(index)                 % 帧移inc区间内没有脉冲
            tal=tal+inc;                  % 计算下一帧的前导零点
        else                              % 帧移inc区间内有脉冲
            eal=length(index);            % 计算有几个脉冲
            tal=inc-index(eal);           % 计算下一帧的前导零点
        end
        for k=1 : 4                       % 对四个滤波器并联输入
            An=an(:,k);
            Bn=bn(k);
            [out(:,k),zint(:,k)]=filter(Bn(1),An,excitation,zint(:,k));
            synt_frame=synt_frame+out(:,k); % 四个滤波器输出叠加在一起
        end
    end
    Et=sum(synt_frame.*synt_frame);       % 用能量归正合成语音
    rt=Etemp(i)/Et;
    synt_frame=sqrt(rt)*synt_frame;
        if i==1                           % 若为第1帧
            output=synt_frame;            % 不需要重叠相加,保留合成数据
        else
            M=length(output);             % 按线性比例重叠相加处理合成数据
            output=[output(1:M-overlap); output(M-overlap+1:M).*tempr2+...
                synt_frame(1:overlap).*tempr1; synt_frame(overlap+1:wlen)];
        end
end
ol=length(output);                        % 把输出output延长至与输入信号xx等长
if ol<N
    output=[output; zeros(N-ol,1)];
end
% 合成语音通过带通滤波器
out1=output;
out2=filter(1,[1 -0.99],out1);
b=[0.964775   -3.858862   5.788174   -3.858862   0.964775];
a=[1.000000   -3.928040   5.786934   -3.789685   0.930791];
output=filter(b,a,out2);
output=output/max(abs(output));

subplot 211; plot(time,x1,'k'); title('原始语音波形');
axis([0 max(time) -1 1.1]); xlabel('时间/s'); ylabel('幅值')
subplot 212; plot(time,output,'k');  title('合成语音波形');
axis([0 max(time) -1 1.1]); xlabel('时间/s'); ylabel('幅值')

