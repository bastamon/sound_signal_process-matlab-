function sumpnn=pnn(p_train,t_train,p_test,t_test)
%pnn:概率神经网络
%输入参数：
% p_train：训练样本数据
% t_train：训练样本类别标签
% p_test：测试样本数据
% t_test：测试样本类别标签
% 输出参数：
% sumpnn：五种基本情感识别率
%% 将期望类别转换为向量
t_train_temp=t_train;
t_train=ind2vec(t_train);

%% 使用newpnn函数建立PNN SPREAD选取为1.5
Spread=1.5;
net=newpnn(p_train,t_train,Spread)

%% 网络预测未知数据效果
Y2=sim(net,p_test);
Y2c=vec2ind(Y2)
sumpnn=[0 0 0 0 0]; %每类情感正确识别个数
%统计识别正确样本数 
for i=1:20
    if Y2c(i)==1
        sumpnn(1)=sumpnn(1)+1;
    end
end
for i=21:40
    if Y2c(i)==2
        sumpnn(2)=sumpnn(2)+1;
    end
end
for i=41:60
    if Y2c(i)==3
        sumpnn(3)=sumpnn(3)+1;
    end
end
for i=61:80
    if Y2c(i)==4
        sumpnn(4)=sumpnn(4)+1;
    end
end
for i=81:100
    if Y2c(i)==5
        sumpnn(5)=sumpnn(5)+1;
    end
end
sumpnn=sumpnn./20;