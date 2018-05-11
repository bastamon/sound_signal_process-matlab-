function f=div_frame(input_voice,len,inc)
%函数：f=fra_div（len,inc,input_voice）
%参数说明：len：每帧的长度
%          inc:帧移动       inc<=len      若len==inc，则无交叠
%          input_voice  :读入文件数据，为n*1维数据
%函数功能：将x数据分成每帧长度len，矩形窗移动为inc的数据，其中f为返回数据，
%          每一行为一帧.

input_voice=input_voice(:);%转换为列向量
fh=fix(((size(input_voice,1)-len)/inc)+1);
f=zeros(fh+1,len);
i=1;n=1;
while i<=fh
    j=1;
    while j<=len
        f(i,j)=input_voice(n);
        j=j+1;
        n=n+1;
    end
    n=n-len+inc;
    i=i+1;
end

