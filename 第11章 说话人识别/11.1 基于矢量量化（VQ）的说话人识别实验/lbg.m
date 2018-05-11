function v=lbg(x,k)
%lbg：完成lbg均值聚类算法
% lbg(x,k) 对输入样本x，分成k类。其中，x为row*col矩阵，每一列为一个样本，
% 每个样本有row个元素。
% [v1 v2 v3 ...vk]=lbg(...)返回k个分类，其中vi为结构体，vi.num为该类
% 中含有元素个数，vi.ele(i)为第i个元素值，vi.mea为相应类别的均值

[row,col]=size(x);
%u=zeros(row,k);%每一列为一个中心值
epision=0.03;%选择epision参数
delta=0.01;
%u2=zeros(row,k);
%LBG算法产生k个中心
u=mean(x,2);%第一个聚类中心，总体均值
for i3=1:log2(k)
    u=[u*(1-epision),u*(1+epision)];%双倍
    %time=0;
    D=0;
    DD=1;
    while abs(D-DD)/DD>delta   %sum(abs(u2(:).^2-u(:).^2))>0.5&&(time<=80)   %u2~=u
        DD=D;
        for i=1:2^i3            %初始化
            v(i).num=0;
            v(i).ele=zeros(row,1);
        end
        for i=1:col %第i个样本
            distance=dis(u,x(:,i));%第i个样本到各个中心的距离
            [val,pos]=min(distance);
             v(pos).num=v(pos).num+1;%元素的数量加1
            if v(pos).num==1    %ele为空
                v(pos).ele=x(:,i);
            else
                v(pos).ele=[v(pos).ele,x(:,i)];
            end
        end
        for i=1:2^i3 
            u(:,i)=mean(v(i).ele,2);%新的均值中心
            for m=1:size(v(i).ele,2)
                D=D+sum((v(i).ele(m)-u(:,i)).^2);
            end
        end
    end
end
%u=u;
for i=1:k  %更新数值
    v(i).mea=u(:,i);
end