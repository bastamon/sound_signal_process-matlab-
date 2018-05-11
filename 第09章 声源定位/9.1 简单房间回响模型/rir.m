function [h]=rir(fs, mic, n, r, rm, src);
%     房间脉冲响应
%     fs    采样频率
%     mic 麦克风坐标（行向量）  
%     n     虚拟声源个数 (2*n+1)^3 
%     r 	墙壁反射系数（-1<R<1）
%     rm   房间尺寸（行向量）
%     src   声源坐标（行向量）
%
%     h     房间脉冲响应

nn=[-n:1:n];                                          
rms=nn+0.5-0.5*(-1).^nn;                    
srcs=(-1).^(nn);                                    
xi=[srcs*src(1)+rms*rm(1)-mic(1)];      % 式（9-2）
yj=[srcs*src(2)+rms*rm(2)-mic(2)];      % 式（9-3）
zk=[srcs*src(3)+rms*rm(3)-mic(3)];      %式（9-4）

[i,j,k]=meshgrid(xi,yj,zk);                         % convert vectors to 3D matrices
d=sqrt(i.^2+j.^2+k.^2);                         % 式（9-5）
time=round(fs*d/343)+1;                     % 式（9-6）
              
[e,f,g]=meshgrid(nn, nn, nn);                  % convert vectors to 3D matrices
c=r.^(abs(e)+abs(f)+abs(g));                    % 式（9-9）
e=c./d;                                                   % 式（9-10）

h=full(sparse(time(:),1,e(:)));                     % 式（9-11）

