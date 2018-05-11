function cc=mfcc(x)

%%-------准备工作-------------
%归一化mel滤波器组系数(24个窗)
bank=melbankm2(24,256,8000,0,0.5,'m'); 
bank=full(bank);
bank=bank/max(bank(:));

%DCT系数，12(欲求的mfcc个数)×24
for k=1:12
 n=0:23;
 dctcoef(k,:)=cos(pi*k*(2*n+1)/(2*24));
end

%归一化的倒谱提升窗口
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);

%--------提取特征-------------
%预加重滤波器
xx=double(x);
xx=filter([1 -0.9375],1,xx);

%语音信号分帧
xx=enframe(x,256,80);

%计算每帧的MFCC参数
for i=1:size(xx,1)
  y=xx(i,:);
  s=y'.*hamming(256);
  t=abs(fft(s));
  t=t.^2;
  c1=log(bank*t(1:129)); 
  c1=dctcoef*c1;
  c2=c1.*w';
  m(i,:)=c2';
end

%差分系数
dtm=zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;

%合并成帧数×24的特征向量矩阵
cc=[m dtm];
cc=cc(3:size(m,1)-2,:);