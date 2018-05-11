function [x_embed,m_len]=hide_LSBEmbed(x,message,nBits)
% 说明：输入参数x是输入的语音数据；message是待嵌入的隐秘信息；
% nBits是每个样本嵌入的bit数。输出参数x_embed是嵌入隐秘信息后的语音；
% m_len是返回嵌入隐秘信息的样本长度。

% Step 1： 确定嵌入隐秘信息的样本长度
% 获取message长度,
len=length(message);
% 根据nBits，重新构成message
pads=mod(len,nBits);
if( pads ) 
    len=len+nBits-pads;
    message=[message,zeros(1,nBits-pads)];
end
m_len=len/nBits;
mess_n=reshape(message,m_len,nBits);

% Step 2： 对语音载体嵌入隐秘信息
for i=1:nBits
    for j=1:m_len
        % 在样本的第i位嵌入信息
        if(mess_n(j,i))
            x(j)=bitset(x(j),i);
        else
            x(j)=bitset(x(j),i,0);
        end
    end
end
x_embed=x;
    