function [cost] = myDTW(F,R)
%输入参数：F为模板MFCC参数矩阵，R为当前语音MFCC参数矩阵
%输出参数：cost为最佳匹配距离

[r1,c1]=size(F);         %模板的维度
[r2,c2]=size(R);         %当前语音维度
distance = zeros(r1,r2);
for n=1:r1
    for m=1:r2
        FR=F(n,:)-R(m,:);
        FR=FR.^2;
        distance(n,m)=sqrt(sum(FR))/c1;     %采用欧氏距离
    end
end

D = zeros(r1+1,r2+1);   
D(1,:) = inf;        
D(:,1) = inf;          
D(1,1) = 0;
D(2:(r1+1), 2:(r2+1)) = distance;


%寻找整个过程的最短匹配距离
for i = 1:r1; 
 for j = 1:r2;
   [dmin] = min([D(i, j), D(i, j+1), D(i+1, j)]);
   D(i+1,j+1) = D(i+1,j+1)+dmin;
 end
end

cost = D(r1+1,r2+1);    %返回最终距离

