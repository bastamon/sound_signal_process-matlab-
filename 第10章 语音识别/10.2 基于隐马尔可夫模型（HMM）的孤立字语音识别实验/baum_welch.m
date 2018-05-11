function hmm=baum_welch(hmm,obs)

mix=hmm.mix; %高斯混合模型
N=hmm.N; %HMM的状态数
K=length(obs); %训练数据样本数
SIZE=size(obs(1).fea,2); %特征矢量的个数

for loop = 1:40
   % ----计算前向, 后向概率矩阵
   for k=1:K
     param(k)=getparam(hmm,obs(k).fea);
   end

   %----重估转移概率矩阵A
   for i=1:N-1
     demon=0;
     for k=1:K  
        tmp=param(k).ksai(:,i,:);
        demon=demon+sum(tmp(:)); %对时间t，j求和
     end
     for j=i:i+1  
        nom=0;
        for k=1:K  
            tmp=param(k).ksai(:,i,j);
            nom=nom+sum(tmp(:));  %对时间t求和
        end
        hmm.trans(i,j)=nom/demon;
     end
   end

   %----重估输出观测值概率B
   for j=1:N %状态循环
     for l=1:hmm.M(j) %混合高斯的数目
        %计算各混合成分的均值和协方差矩阵
        nommean=zeros(1,SIZE);
        nomvar=zeros(1,SIZE);
        denom=0;
        for k=1:K  %训练数目的循环
           T=size(obs(k).fea,1);  %帧数
           for t=1:T   %帧数（时间）的遍历
             x=obs(k).fea(t,:);
             nommean=nommean+param(k).gama(t,j,l)*x;
             nomvar=nomvar+param(k).gama(t,j,l)*(x-mix(j).mean(l,:)).^2;
             denom=denom+param(k).gama(t,j,l);
           end
        end
        hmm.mix(j).mean(l,:)=nommean/denom;
        hmm.mix(j).var(l,:)=nomvar/denom;
   
        %计算各混合成分的权重
        nom=0;
        denom=0;
        for k=1:K
          tmp=param(k).gama(:,j,l);
          nom=nom+sum(tmp(:));
          tmp=param(k).gama(:,j,:);
          denom=denom+sum(tmp(:));
        end
        hmm.mix(j).weight(l)=nom/denom;
     end
   end   
      
end
  




