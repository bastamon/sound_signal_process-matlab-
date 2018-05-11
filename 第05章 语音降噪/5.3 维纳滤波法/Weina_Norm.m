% --------------------------------------------------------------------------------------------------------------
% 维纳滤波 enhanced=Weina_Norm(x,wind,inc,NIS,alpha,beta)
% MS估计噪声功率谱,需要估计纯净信号功率Ps
% x:输入语音信号
% framesize:帧长
% overlap:帧重叠长度
% NIS：无声帧帧数
% alpha,beta:抑制参数
% ---------------------------------------------------------------------------------------------------------------
 %%
function enhanced=Weina_Norm(x,wind,inc,NIS,alpha,beta)
    nwin=length(wind);           % 取窗长
    if (nwin == 1)              % 判断窗长是否为1，若为1，即表示没有设窗函数
       framesize= wind;               % 是，帧长=win
       wnd=hamming(framesize);                      % 设置窗函数
    else
       framesize = nwin;              % 否，帧长=窗长
       wnd=wind;
    end
    
    y=enframe(x,wnd,inc)';             % 分帧
    framenum=size(y,2);                           % 求帧数
    y_fft = fft(y);                         % FFT
    y_a = abs(y_fft);                       % 求取幅值
    y_phase=angle(y_fft);                   % 求取相位角
    y_a2=y_a.^2;                            % 求能量
    noise=mean(y_a2(:,1:NIS),2);               % 计算噪声段平均能量
    signal=zeros(framesize,1);
    for i=1:framenum
         frame=y(:,i);                                 %取一帧数据
         y_fft=fft(frame);                 %对信号帧y_ham进行短时傅立叶变换,得到频域信号y_fft
         y_fft2=abs(y_fft).^2;     %计算频域信号y_fft每帧的功率谱y_w
     
         %带噪语音谱减去噪声谱
         for k=1:framesize
                if   abs( y_fft2(k) )  >=alpha*noise(k)%(k,i)
                      signal(k)=y_fft2(k)-alpha*noise(k);%(k,i);
                      if signal(k)<0
                          signal(k)=0;
                      end
                else
                      signal(k)=beta*noise(k);%*0.01;
                end
                
         end
         %计算H(W)
         Hw=( signal./(signal+1*noise) ).^1 ;
         %维纳滤波器输出
         yw(:,i)=Hw.*y_fft;
         yt(:,i)=ifft(yw(:,i));
    end
  %采用相位，反而信噪比低
    enhanced=filpframe(yt',wnd,inc);



  
  
  
  
  
  