% 实验要求二：语音信号变调实验
clear all; clc; close all;

[xx,fs]=wavread('C7_4_y.wav');                     % 读取文件
xx=xx-mean(xx);                           % 去除直流分量
x=xx/max(abs(xx));                        % 幅值归一化
lx=length(x);                             % 数据长度
time=(0:lx-1)/fs;                         % 求出对应的时间序列
wlen=240;                                 % 设定帧长
inc=80;                                   % 设定帧移的长度  
overlap=wlen-inc;                         % 重叠长度
tempr1=(0:overlap-1)'/overlap;            % 斜三角窗函数w1
tempr2=(overlap-1:-1:0)'/overlap;         % 斜三角窗函数w2
n2=1:wlen/2+1;                            % 正频率的下标值
X=enframe(x,wlen,inc)';                   % 按照参数进行分帧
fn=size(X,2);                             % 总帧数
T1=0.1; r2=0.5;                           % 端点检测参数
miniL=10;                                 % 有话段最短帧数
mnlong=5;                                 % 元音主体最短帧数
ThrC=[10 15];                             % 阈值
p=12;                                     % LPC阶次
frameTime=FrameTimeC(fn,wlen,inc,fs);     % 计算每帧的时间刻度
in=input('请输入基音频率升降的倍数:','s');  % 输入基音频率增降比例
rate=str2num(in);

for i=1 : fn                              % 求取每帧的预测系数和增益
    u=X(:,i);
    [ar,g]=lpc(u,p);
    AR_coeff(:,i)=ar;
    Gain(i)=g;
end

% 基音检测
[voiceseg,vosl,SF,Ef,period]=pitch_Ceps(x,wlen,inc,T1,fs); %基于倒谱法的基音周期检测
Dpitch=pitfilterm1(period,voiceseg,vosl);       % 对T0进行平滑处理求出基音周期T0

if rate>1, sign=-1; else sign=1; end
lmin=floor(fs/450);                       % 基音周期的最小值
lmax=floor(fs/60);                        % 基音周期的最大值
deltaOMG = sign*100*2*pi/fs;              % 根值顺时针或逆时针旋转量dθ
Dpitchm=Dpitch/rate;                      % 增减后的基音周期
% Dfreqm=Dfreq*rate;                        % 增减后的基音频率

tal=0;                                    % 初始化
zint=zeros(p,1); 
for i=1 : fn
    a=AR_coeff(:,i);                      % 取得本帧的AR系数
    sigma=sqrt(Gain(i));                  % 取得本帧的增益系数

    if SF(i)==0                           % 无话帧
        excitation=randn(wlen,1);         % 产生白噪声
        [synt_frame,zint]=filter(sigma,a,excitation,zint);
    else                                  % 有话帧
        PT=floor(Dpitchm(i));             % 把周期值变为整数
        if PT<lmin, PT=lmin; end          % 判断修改后的周期值有否超限
        if PT>lmax, PT=lmax; end
        ft=roots(a);                      % 对预测系数求根
        ft1=ft;
%增加共振峰频率，实轴上方的根顺时针转，下方的根逆时针转，求出新的根值
        for k=1 : p
            if imag(ft(k))>0, 
                ft1(k) = ft(k)*exp(j*deltaOMG);
	        elseif imag(ft(k))<0 
                ft1(k) = ft(k)*exp(-j*deltaOMG);
	        end
        end
        ai=poly(ft1);                     % 由新的根值重新组成预测系数

        exc_syn1 =zeros(wlen+tal,1);      % 初始化脉冲发生区
        exc_syn1(mod(1:tal+wlen,PT)==0)=1;% 在基音周期的位置产生脉冲，幅值为1
        exc_syn2=exc_syn1(tal+1:tal+inc); % 计算帧移inc区间内的脉冲个数
        index=find(exc_syn2==1);
        excitation=exc_syn1(tal+1:tal+wlen);% 这一帧的激励脉冲源
        
        if isempty(index)                 % 帧移inc区间内没有脉冲
            tal=tal+inc;                  % 计算下一帧的前导零点
        else                              % 帧移inc区间内有脉冲
            eal=length(index);            % 计算脉冲个数
            tal=inc-index(eal);           % 计算下一帧的前导零点
        end
        gain=sigma/sqrt(1/PT);            % 增益
        [synt_frame,zint]=filter(gain,ai,excitation,zint);%用激励脉冲合成语音
    end
    
    if i==1                               % 若为第1帧
            output=synt_frame;            % 不需要重叠相加,保留合成数据
        else
            M=length(output);             % 重叠部分的处理
            output=[output(1:M-overlap); output(M-overlap+1:M).*tempr1+...
                synt_frame(1:overlap).*tempr2; synt_frame(overlap+1:wlen)];
        end
end
output(find(isnan(output)))=0;
ol=length(output);                        % 把输出output延长至与输入信号xx等长
if ol<lx
    output1=[output; zeros(lx-ol,1)];
else
    output1=output(1:lx);
end
bn=[0.964775   -3.858862   5.788174   -3.858862   0.964775]; % 滤波器系数
an=[1.000000   -3.928040   5.786934   -3.789685   0.930791];
output=filter(bn,an,output1);             % 高通滤波
output=output/max(abs(output));           % 幅值归一化

subplot 211; plot(time,x,'k'); title('原始语音波形'); 
axis([0 max(time) -1 1]); xlabel('时间/s'); ylabel('幅值')
subplot 212; plot(time,output,'k');  title('合成语音波形');
xlim([0 max(time)]); xlabel('时间/s'); ylabel('幅值')


