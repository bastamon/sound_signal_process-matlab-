%回声法语音隐藏倒谱法提取隐藏信息
%说明：输入参数x是嵌入隐藏信息的信号
%N为分段长度
%m0是隐藏信息为0时的延迟，m1是隐藏信息为1时的延迟
%len是隐藏信息的长度
%输出message是提取出的隐藏信息
function [ message ] = hide_EchoExtract( x_embeded,N,m0,m1,len)
message = zeros(1,len);
for i=1:len
    x = x_embeded(((i-1)*N+1):(i*N));
    xwhat = rceps(x);
    if(xwhat(m0+1)>xwhat(m1+1))   
        message(1,i) =0;
    else message(1,i)=1;
    end
end

