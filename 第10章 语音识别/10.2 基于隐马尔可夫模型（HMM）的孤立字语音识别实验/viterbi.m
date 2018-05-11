function [prob,q]=viterbi(hmm,O)
%Viterbi算法
%输入：
%hmm--hmm模型
%O--输入观察序列，T*D，T为帧数，D为向量维数
%输出：
%prob--输出概率
%q--状态序列

init=hmm.init; %初始概率
trans=hmm.trans; %转移概率
mix=hmm.mix;  %高斯混合
N=hmm.N;  %HMM的状态数
T=size(O,1); %语音帧数

%计算log(init)
ind1=find(init>0);
ind0=find(init<=0);
init(ind1)=log(init(ind1));
init(ind0)=-inf;

%计算log(trans);
ind1 = find(trans>0);
ind0 = find(trans<=0);
trans(ind0) = -inf;
trans(ind1) = log(trans(ind1));

%初始化
delta=zeros(T,N); %帧数×状态数
fai=zeros(T,N);
q=zeros(T,1);

%t=1;
for i=1:N
    delta(1,i)=init(i)+log(mixture(mix(i),O(1,:)));
end

%t=2:T
for t=2:T
    for j=1:N
        [delta(t,j),fai(t,j)]=max(delta(t-1,:)+trans(:,j)');
        delta(t,j)=delta(t,j)+log(mixture(mix(j),O(t,:)));
    end
end

%最终概率和最后节点
[prob q(T)]=max(delta(T,:));

%回溯最佳状态路径
for t=T-1:-1:1
    q(t)=fai(t+1,q(t+1));
end