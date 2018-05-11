function dis=dis(u,xi)
%DIS:计算欧式距离
% dis=dis(u,xi):计算xi到u的各个列向量的欧式距离，返回到dis中
% u的行数和向量xi的维数必须一致

if isvector(xi)&&(size(u,1)~=length(xi))
    error('xi必须为向量且维数必须等于u的行数')
end
k=size(u,2);
xi=xi(:);
dis=zeros(1,k);
for i=1:k
    ui=u(:,i);
    dis(i)=sum((xi-ui).^2);
end