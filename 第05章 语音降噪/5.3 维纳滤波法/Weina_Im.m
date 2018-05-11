% --------------------------------------------------------------------------------------------------------------
% 维纳滤波enhancement=Weina_Im(y_fft,framesize,framenum,length);
% MS估计噪声功率谱, D-D法估计先验概率, 不需要估计纯净信号功率
% y_fft：分帧语音的FFT变换，
% framesize：帧长
% framenum：总帧数，
% length：语音长度
% enhancement：增强后的语音
% --------------------------------------------------------------------------------------------------------------

function enhancement=Weina_Im(x,wind,inc,NIS,alpha)
    Length=length(x);
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
    y_fft2=y_a.^2;                            % 求能量
    noise=mean(y_fft2(:,1:NIS),2);               % 计算噪声段平均能量
   
    snr_x_q=0.96;                                    %前一帧先验信噪比，初始值设为0.96
    for i=1:framenum
         Mag_y=y_a(:,i);                          
         snr_h=y_fft2(:,i)./noise;%(:,i);                   %计算后验信噪比
         snr_x=alpha.*snr_x_q+(1-alpha).*max(snr_h-1,0);        %先验信噪比,利用"D-D"法  ,framesize*1
         Hw=snr_x./(1+snr_x);                             %维纳滤波
         M=Mag_y.*Hw;                                     %维纳后的幅度值
         Mn=M.*exp(1i.*y_phase(:,i));                       %插入相位
         snr_x_q=M.^2./noise;%(:,i);                        %更新估计的前一帧先验信噪比
         signal(:,i)=real(ifft(Mn));
    end
enhancement=filpframe(signal',wnd,inc);

    

    
    
    
    
    
     