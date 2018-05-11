function hmm = inithmm(obs, N, M)

K=length(obs);  %语音的样本数（此处为10）
% N=length(M)        %状态数（此处为4）
hmm.N=N;
hmm.M=M;           %每个状态的pdf数

%-------初始化初始状态概率pai
hmm.init=zeros(N,1);
hmm.init(1)=1;

%-------初始化状态转移概率矩阵A
hmm.trans=zeros(N,N);
for i=1:N-1
  hmm.trans(i,i)=0.5;
  hmm.trans(i,i+1)=0.5;
end
hmm.trans(N,N)=1;

% -------初始化输出观测值概率B（连续混合正态分布）
for k=1:K
 T=size(obs(k).fea,1);  
 obs(k).segment=floor([1:T/N:T T+1]);
end

for i=1:N
   vector=[];
   for k=1:K
       seg1=obs(k).segment(i);
       seg2=obs(k).segment(i+1)-1;
       vector=[vector;obs(k).fea(seg1:seg2,:)];
   end
   mix(i)=getmix(vector,M(i)); %调用getmix函数，返回结构体mix(i)
end

hmm.mix=mix;

%------------getmix函数的实现过程------
function mix=getmix(vector,M)

%计算每个成分的初始均值miu
[mean esp nn]=kmeans1(vector,M);

% 计算每个成分的协方差sigma
for j=1:M
    ind=find(j==nn);
    tmp=vector(ind,:);
    var(j,:)=std(tmp);
end

% 计算每个成分的权重w
weight=zeros(M,1);
for j=1:M
  for k=1:size(nn,1)  
    if nn(k)==j
        weight(j)=weight(j)+1;
    end
  end
end
weight=weight/sum(weight);

% 保存结果
mix.M=M;
mix.mean=mean;    
mix.var=var.^2;	
mix.weight=weight;	

