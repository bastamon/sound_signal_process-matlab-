function y=st_energy(x)

ex=x.^2;                 %一帧内各样点的能量
y=sum(ex,2)  ;          %求每一帧能量
