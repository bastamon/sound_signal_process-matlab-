function param=getparam(hmm,O)

%给定输出序列O, 计算前向概率alpha, 后向概率beta, 标定系数c, 及ksai,gama
%输入:
%  hmm -- HMM模型参数
%  O   -- n*d 观察序列(n:帧数，d:特征矢量个数)
%输出:
%  param -- 包含各种参数的结构

T=size(O,1);  %观测到的训练序列的帧数（长度）

init=hmm.init;  %初始概率(N×1)
trans=hmm.trans;  %转移概率（N×N）
mix=hmm.mix;  %高斯混合模型
N=hmm.N;     %状态数


%----------计算前向概率alpha--
alpha=zeros(T,N);
c=zeros(T,1);

%t=1
x=O(1,:);
for i=1:N
    alpha(1,i)=init(i)*mixture(mix(i),x);
end
%标定
c(1)=1/sum(alpha(1,:));
alpha(1,:)=c(1)*alpha(1,:);

%t=2~T
for t=2:T
  for i=1:N
      temp=0;
      for j=1:N
       temp=temp+alpha(t-1,j)*trans(j,i);
      end
      alpha(t,i)=temp*mixture(mix(i),O(t,:));
  end
  c(t)=1/sum(alpha(t,:));
  alpha(t,:)=c(t)*alpha(t,:);
end

%----------计算后向概率beta--
beta=zeros(T,N);

%t=T
for l=1:N
  beta(T,i)=c(T);
end

%t=T-1:1
for t=T-1:-1:1
  for i=1:N
    temp=0;
    for j=1:N
       temp=temp+beta(t+1,j)*trans(i,j)*mixture(mix(j),O(t+1,:)); 
    end
    beta(t,i)=temp;
  end
  beta(t,:)=beta(t,:)*c(t);
end

%-----------计算过渡概率ksai-------
ksai=zeros(T-1,N,N);
for t=1:T-1
   denom=sum(alpha(t,:).*beta(t,:));
   for i=1:N-1
       for j=i:i+1
           nom=alpha(t,i)*trans(i,j)*mixture(mix(j),O(t+1,:))*beta(t+1,j);
           ksai(t,i,j)=c(t)*nom/denom;%由于scaling,分母不能直接相加,需要除以c(t)
       end
   end  
end

%-----------计算混合输出概率:gama--------
gama=zeros(T,N,max(hmm.M));
for t=1:T
    pab=zeros(N,1);
    for j=1:N
        pab(j)=alpha(t,j)*beta(t,j);  
    end
    for j=1:N
        prob=zeros(mix(j).M,1);  %计算c(下标:jk)*N(0t,miu(jk),var(jk))
        for k=1:mix(j).M
            m=mix(j).mean(k,:);
            v=mix(j).var(k,:);
            prob(k)=mix(j).weight(k)*(2*pi*prod(v))^-0.5*exp(-0.5*(O(t,:)-m)./v*(O(t,:)-m)');
        end
        for k=1:mix(j).M
            gama(t,j,k)=(pab(j)/sum(pab))*(prob(k)/sum(prob));
        end
    end
end

%--------保存结果并返回-----
param.c=c;
param.alpha=alpha;
param.beta=beta;
param.ksai=ksai;
param.gama=gama;
