%自相关法端点检测函数
function [voiceseg,vsl,SF,NF,Rum]=vad_corr(y,wnd,inc,NIS,th1,th2)

x=enframe(y,wnd,inc)';             % 分帧
fn=size(x,2);                           % 求帧数
for k=2 : fn                            % 计算自相关函数
    u=x(:,k);
    ru=xcorr(u);
    Ru(k)=max(ru);
end
Rum=Ru/max(Ru);                       % 归一化
thredth=max(Rum(1:NIS));                % 计算阈值
T1=th1*thredth;
T2=th2*thredth;
[voiceseg,vsl,SF,NF]=vad_forw(Rum,T1,T2);