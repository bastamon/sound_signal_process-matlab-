function [trainlda, testlda] = lda(data, testsample, N, reduced_dim)
% 输入参数
% data：m*n的原始训练数据，m为样本个数，n为维数
% testsample：测试数据
% N：各个类别的样本总数，与data中的数据对应
% reduced_dim：新的数据维数
% 输出参数
% trainlda：经过LDA处理后的训练样本数据
% testlda：经过LDA处理后的测试样本数据
C=length(N);
dim=size(data',1);% 计算每类样本在data中的起始、终止行数
pos=zeros(C,2);
for i=1:C
    START=1;
    if i>1
        START=START+sum(N(1:i-1));
    end
    END=sum(N(1:i));
    pos(i,:)=[START END];
end% 每类样本均值
UI=[];
for i=1:C
    if pos(i,1)==pos(i,2)
        % pos(i,1)==pos(i,2)时，mean函数不能工作
        UI=[UI;data(pos(i,1),:)];
    else
        UI=[UI;mean(data(pos(i,1):pos(i,2),:))];
    end
end
% 总体均值
U=mean(data);% 类间散度矩阵
SB=zeros(dim,dim);
for i=1:C
    SB=SB+N(i)*(UI(i,:)-U)'*(UI(i,:)-U);
end% 类内散度矩阵
SW=zeros(dim,dim);
for i=1:C
    for j=pos(i,1):pos(i,2)
        SW=SW+(data(j,:)-UI(i,:))'*(data(j,:)-UI(i,:));
    end
end% 该部分可以要，也可以不要
SW=SW/sum(N);
SB=SB/sum(N);% 计算特征值与特征向量
matrix=pinv(SW)*SB;
[V,D]=eig(matrix);
condition=dim-reduced_dim+1:dim;
V=V(:,condition);% 根据新的特征向量，将数据映射到新空间
trainlda=data*V;
testlda=testsample*V;