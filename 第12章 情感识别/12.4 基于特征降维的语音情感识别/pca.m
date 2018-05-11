function [trainpca, testpca] = pca(trainsample, test, ReducedDim)
%trainsample训练样本数据
%test测试样本数据
%ReducedDim：降维后特征维数
[pc,score,latent,tsquare] = princomp(trainsample); %PCA降维
tranMatrix = pc(:,1:ReducedDim); %转置矩阵
trainpca=trainsample*tranMatrix;%降维后训练样本数据
testpca=test*tranMatrix;%降维后测试样本数据