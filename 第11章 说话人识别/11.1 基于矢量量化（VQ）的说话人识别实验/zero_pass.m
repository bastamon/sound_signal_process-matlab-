function f=zero_pass(x)
%calculate the zero_passing ratio of x 
%原型：f=zcro(x)
%参数说明： x：输入矩阵，每一行为一帧数据
%          f：返回列矩阵，第i个数为x中第i帧的过零率
[row col]=size(x);
f=zeros(row,1);
for i=1:row
    for j=1:col-1
        if x(i,j)*x(i,j+1)<0;
            f(i)=f(i)+1;
        end
    end
end
