%LMS函数
function [yn,W,en]=LMS(xn,dn,M,mu,itr)
% LMS(Least Mean Squre)算法
% 输入参数:
%     xn   输入的信号序列      (列向量)
%     dn   所期望的响应序列    (列向量)
%     M    滤波器的阶数        (标量)
%     mu   收敛因子(步长)      (标量)     要求大于0,小于xn的相关矩阵最大特征值的倒数    
%     itr  迭代次数            (标量)     默认为xn的长度,M<itr<length(xn)
% 输出参数:
%     W    滤波器的权值矩阵     (矩阵)
%          大小为M x itr,
%     en   误差序列(itr x 1)    (列向量)  
%     yn   实际输出序列             (列向量)
% 参数个数必须为4个或5个
if nargin == 4                 % 4个时递归迭代的次数为xn的长度 
    itr = length(xn);
elseif nargin == 5             % 5个时满足M<itr<length(xn)
    if itr>length(xn) | itr<M
        error('迭代次数过大或过小!');
    end
else
    error('请检查输入参数的个数!');
end
% 初始化参数
en = zeros(itr,1);             % 误差序列,en(k)表示第k次迭代时预期输出与实际输入的误差
W  = zeros(M,itr);             % 每一行代表一个加权参量,每一列代表-次迭代,初始为0
% 迭代计算
for k = M:itr                  % 第k次迭代
    x = xn(k:-1:k-M+1);        % 滤波器M个抽头的输入
    y = W(:,k-1).' * x;        % 滤波器的输出
    en(k) = dn(k) - y ;        % 第k次迭代的误差
    % 滤波器权值计算的迭代式
    W(:,k) = W(:,k-1) + 2*mu*en(k)*x;
end
% 求最优时滤波器的输出序列
yn = inf * ones(size(xn));
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
    yn(k) = W(:,end).'* x;
end
