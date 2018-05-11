%回声法语音隐藏
%说明：输入参数x是原始音频信号
%message是隐藏信息
%N为分段长度
%m0是隐藏信息为0时的延迟，m1是隐藏信息为1时的延迟
%a是衰减率
%输出x_embeded是含有隐藏信息的信号
function [ x_embeded ] = hide_EchoEmbed( x,message,N,m0,m1,a)
x_embeded = x;
nf = min(length(x)/N,length(message));       %段数
for i=1:nf
    if(message(i))
        for j=1:N
            if((i-1)*N+j>m1)     x_embeded((i-1)*N+j) = x((i-1)*N+j)+a*x((i-1)*N+j-m1);
            end
        end
    else
        for j=1:N
            if((i-1)*N+j>m0)     x_embeded((i-1)*N+j) = x((i-1)*N+j)+a*x((i-1)*N+j-m0);
            end
        end
    end
end

