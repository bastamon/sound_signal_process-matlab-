function [message_rec]=hide_LSBExtract(x_embed,m_len,nBits)
% 说明：
% x_embed是输入的嵌入隐秘信息后的语音；
% m_len是嵌入的隐秘信息的样本长度，
% nBits是每个样本嵌入的bit数。
% 输出参数message_rec是重构得到的隐秘信息序列。

message_rec=zeros(m_len,nBits);
for i=1:nBits
    for j=1:m_len
        message_rec(j,i)=bitget(x_embed(j),i);
     end
end
% Reshape message_rec
message_rec=message_rec(:).';