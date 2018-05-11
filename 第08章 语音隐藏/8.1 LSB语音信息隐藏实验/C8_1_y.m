% 实验要求：LSB语音信息隐藏实验
clear all;
clc;
% 读取语音数据
[x_org,fs,bits]=wavread('C8_1_y.wav');
% 无符号化语音数据
if (bits==16)
   x=uint16((x_org+1)*2^(bits-1));
elseif (bits==8)
   x=uint8((x_org+1)*2^(bits-1));
end
% 载入隐秘数据 
load  'C8_1_y.DAT' -mat;
nBits=1;
% 嵌入隐秘信息
[x_embed,m_len]=hide_LSBEmbed(x,message,nBits);

% 提取隐秘信息
[message_rec]=hide_LSBExtract(x_embed,m_len,nBits);

% 结果分析与对比
% Step 1  波形分析
figure(1);
subplot(311);
plot(x);title('原始语音');
xlabel('采样点')
ylabel('幅度')
subplot(312);
plot(x_embed);title('嵌入隐秘信息语音');
xlabel('采样点')
ylabel('幅度')
subplot(313);
plot(x-x_embed);title('两者之差');
xlabel('采样点')
ylabel('幅度')
ylim([-10 10]);

% Step 2  恢复率分析
figure(2);
subplot(211);
imshow(reshape(message,m_mess,n_mess),[0 1]);
title('原始隐秘信息');
subplot(212);
len_mess=length(message);
message_rec=message(1:len_mess);
err_rate=sum(abs(message-message_rec))/len_mess;
imshow(reshape(message_rec,m_mess,n_mess),[0 1]);
s_title=sprintf('恢复的隐秘信息，错误率%.2f %%',err_rate);
title(s_title);


