function feature=featvector(filename)
[y,fs]=wavread(filename); 
L=length(y);
ys=y;
for i=1:(length(y)-1)
    if (abs(y(i))<1e-3)  %  剔除较小值，计算短时能量时使用  %
        ys(i)=ys(i+1);
        L=L-1;
    end
end 
y1=ys(1:L);
s=enframe(y,hamming(256),128); %  分帧加窗  %
s1=enframe(y1,hamming(256),128); 
[nframe,framesize]=size(s);  
[nframe1,framesize1]=size(s1);
E=zeros(1,nframe1);  
Z=zeros(1,nframe);
F=zeros(1,nframe);
for i=1:nframe
    Z(i)=sum(abs(sign(s(i,framesize:2)-s(i,framesize-1:1))))/2;  %  过零率  %
end
for i=1:nframe1
    E(i)=sum(s1(i,:).*s1(i,:)); %  短时能量  %
end
%  基音频率  %
N=2048;R=4;
for i=1:nframe
    k = 1:R:N/2; K = length(k);  %  N是FFT变换点数，R是乘的次数，f是采样频率  %
    X = fft (s(i,:), N); 
    X=abs(X);  %  对X做绝对值，取到幅度  %
    HPSx = X(k); 
    for r= R-1:-1:1
        HPSx = HPSx.*X (1:r:r*K);
    end
    [~,I]=max(HPSx);  %  取最大值点，I是对应下标  %
    F(i)=I/N*fs; %  基音频率  %
end
%  浊音帧差分基音  %
nf=1;
for i=1:(nframe-1)
    if(F(i)*F(i+1)~=0)
        dF(nf)=F(i)-F(i+1);
        nf=nf+1;
    end
end
%  0-250hz所占比例  %
[s2,f1,t1]=specgram(y1,256,fs);
sn=20*log10(abs(s2)+eps);
sn1=sn+min(sn(:));
n=round(length(f1)*250/max(f1(:)));
Eratio=sum(sum(sn1(1:n,:)))/sum(sn1(:));

%{
%  频谱幅度  %
out_gbvs=spGbvs(sn);  %  做显著图计算分割矩阵H  %
H=out_gbvs.master_map_resized;
H(H<0.5)=0;
H(H>=0.5)=1;
snew=sn.*H;  %  分割后的部分频谱图  %
row=size(snew,1);
col=size(snew,2);
ssnew=snew';
I=find(ssnew==0);
fa=ceil(I(1)/col);
fb=ceil(I(end)/col);
F1=f1(fb)-f1(fa);
%}

%  估计共振峰  %
[fm,~] = formant_get(y,fs);
Fm1=fm(:,1);
Fm2=fm(:,2);
Fm3=fm(:,3);
%  MFCC  %
MFCCs=melcepst(y,fs,'0d'); %  MFCC及其一阶差分系数  %


%%    特征向量构成    %%
%  短时能量E  %
dim_max=140;
feature=zeros(dim_max,1);
x=0;t=0;
for i=1:(nframe1-1)
    t=abs(E(i)-E(i+1))/(nframe1-1);
    x=x+t;
end
E_shimmer=x/mean(E);
x1=0;x2=0;x3=0;x4=0;
for i=1:nframe1
    t1=i*mean(E);t2=i*E(i); t3=i*i;t4=i;
    x1=x1+t1;x2=x2+t2;x3=x3+t3;x4=x4+t4;
end
x4=x4*x4/nframe1;
s1=x2-x1;s2=x3-x4;
E_Reg_coff=s1/s2;
x=0;
for i=1:nframe1
    t=E(i)-(mean(E)-s1/s2*x4/nframe1)-s1/s2*i;
    x=x+t^2/nframe1;
end
E_Sqr_Err=x;
feature(1:7,1)=[max(E);min(E);mean(E);var(E);E_shimmer;E_Reg_coff;E_Sqr_Err];%  短时能量相关特征  %

%  能量比  %
feature(8,1)=Eratio;

%  基音频率F  %
x=0;
for i=1:(nframe-1)
    t=abs(F(i)-F(i+1));
    x=x+t;
end
F_Jitter1=100*x/(mean(F)*(nframe-1));
x=0;
for i=2:(nframe-1)
    t=abs(2*F(i)-F(i+1)-F(i-1));
    x=x+t;
end
F_Jitter2=100*x/(mean(F)*(nframe-2));

%% 使F得最小值是有效（去除等值）
k=1;
for i=2:numel(F)
    if(F(i)==F(1))
        continue;
    end
    FF(k)= F(i);
    k=k+1;
 
end

feature(9:14,1)=[max(F);min(FF);mean(F);var(F);F_Jitter1;F_Jitter2];%  基音频率相关特征  %

%  浊音帧差分基音  %
feature(15:18,1)=[max(dF);min(dF);mean(dF);var(dF)];%  浊音帧差分基音  %

%  共振峰  %
x1=0;x2=0;x3=0;
for i=1:(numel(Fm1)-1)
    t1=abs(Fm1(i)-Fm1(i+1));
    t2=abs(Fm2(i)-Fm2(i+1));
    t3=abs(Fm3(i)-Fm3(i+1));
    x1=x1+t1;x2=x2+t2;x3=x3+t3;
end
Fm1_Jitter1=100*x1/(mean(Fm1)*(numel(Fm1)-1));%  前三个共振峰的一阶抖动  %
Fm2_Jitter1=100*x2/(mean(Fm2)*(numel(Fm1)-1));
Fm3_Jitter1=100*x3/(mean(Fm2)*(numel(Fm1)-1));
Fm2R=Fm2./(Fm2-Fm1);
nFm=[max(Fm1);min(Fm1);mean(Fm1);var(Fm1);Fm1_Jitter1;max(Fm2);min(Fm2);mean(Fm2);var(Fm2);Fm2_Jitter1;max(Fm3);min(Fm3);mean(Fm3);var(Fm3);Fm3_Jitter1;max(Fm2R);min(Fm2R);mean(Fm2R)];%  共振峰相关特征  %
feature(19:(size(nFm)+18),1)=nFm;%  20-37  %
% size(feature)
%  MFCCs & dMFCCs  %
for i=1:size(MFCCs,2)
    feature(37+4*(i-1):37+4*i-1,1)=[max(MFCCs(:,i));min(MFCCs(:,i));mean(MFCCs(:,i));var(MFCCs(:,i))];%  mel倒谱系数及其一阶差分相关特征  %
end




