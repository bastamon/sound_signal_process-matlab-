function y=pitfilterm1(x,vseg,vsl)

y=zeros(size(x));             % 初始化
for i=1 : vsl                 % 有段数据
    ixb=vseg(i).begin;        % 该段的开始位置
    ixe=vseg(i).end;          % 该段的结束位置
    u0=x(ixb:ixe);            % 取来一段数据
    y0=medfilt1(u0,5);        % 5点的中值滤波
    v0=linsmoothm(y0,5);      % 线性平滑 
    y(ixb:ixe)=v0;            % 赋值给y
end
