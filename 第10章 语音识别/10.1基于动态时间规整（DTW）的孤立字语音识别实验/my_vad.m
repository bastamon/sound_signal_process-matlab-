function trimmed_X = my_vad(x)
%端点检测；输入为录入语音，输出为有用信号

Ini = 0.1;          %初始静默时间
Ts = 0.01;          %窗的时长
Tsh = 0.005;        %帧移时长
Fs = 16000;         %采样频率
counter1 = 0;       %以下四个参数用来寻找起始点和结束点
counter2 = 0;
counter3 = 0;
counter4 = 0;
ZCRCountf = 0;      %用于存储过零率检测结果
ZCRCountb = 0;     
ZTh = 40;           %过零阈值
w_sam = fix(Ts*Fs);                   %窗口长度
o_sam = fix(Tsh*Fs);                  %帧移长度
lengthX = length(x);
segs = fix((lengthX-w_sam)/o_sam)+1;  %分帧数
sil = fix((Ini-Ts)/Tsh)+1;            %静默时间帧数
win = hamming(w_sam);

Limit = o_sam*(segs-1)+1;             %最后一帧的起始位置

FrmIndex = 1:o_sam:Limit;             %每一帧的起始位置
ZCR_Vector = zeros(1,segs);           %记录每一帧的过零点数
                                     
%短时过零点
for t = 1:segs
    ZCRCounter = 0; 
    nextIndex = (t-1)*o_sam+1;
    for r = nextIndex+1:(nextIndex+w_sam-1)
        if (x(r) >= 0) && (x(r-1) >= 0)
         
        elseif (x(r) > 0) && (x(r-1) < 0)
         ZCRCounter = ZCRCounter + 1;
        elseif (x(r) < 0) && (x(r-1) < 0)
         
        elseif (x(r) < 0) && (x(r-1) > 0)
         ZCRCounter = ZCRCounter + 1;
        end
    end
    ZCR_Vector(t) = ZCRCounter;
end

%短时平均幅度
Erg_Vector = zeros(1,segs);
for u = 1:segs
    nextIndex = (u-1)*o_sam+1;
    Energy = x(nextIndex:nextIndex+w_sam-1).*win;
    Erg_Vector(u) = sum(abs(Energy));
end

IMN = mean(Erg_Vector(1:sil));  %静默能量均值（噪声均值）
IMX = max(Erg_Vector);          %短时平均幅度的最大值
I1 = 0.03 * (IMX-IMN) + IMN;    %I1，I2为初始能量阈值
I2 = 4 * IMN;
ITL = 100*min(I1,I2);            %能量阈值下限,前面系数根据实际情况更改得到合适结果
ITU = 10* ITL;                  %能量阈值上限
IZC = mean(ZCR_Vector(1:sil));  
stdev = std(ZCR_Vector(1:sil)); %静默阶段过零率标准差

IZCT = min(ZTh,IZC+2*stdev);    %过零率阈值
indexi = zeros(1,lengthX);      
indexj = indexi;               
indexk = indexi;
indexl = indexi;

%搜寻超过能量阈值上限的部分
for i = 1:length(Erg_Vector)
    if (Erg_Vector(i) > ITU)
        counter1 = counter1 + 1;
        indexi(counter1) = i;
    end
end
ITUs = indexi(1);        %第一个能量超过阈值上限的帧

%搜寻能量超过能量下限的部分
for j = ITUs:-1:1
    if (Erg_Vector(j) < ITL)
        counter2 = counter2 + 1;
        indexj(counter2) = j;
    end
end
start = indexj(1)+1;    %第一级判决起始帧

Erg_Vectorf = fliplr(Erg_Vector);%将能量矩阵关于中心左右对称，如果是一行向量相当于逆序 

%重复上面过程相当于找结束帧
for k = 1:length(Erg_Vectorf)
    if (Erg_Vectorf(k) > ITU)
        counter3 = counter3 + 1;
        indexk(counter3) = k;
    end
end
ITUf = indexk(1);

for l = ITUf:-1:1
    if (Erg_Vectorf(l) < ITL)
        counter4 = counter4 + 1;
        indexl(counter4) = l;
    end
end

finish = length(Erg_Vector)-indexl(1)+1;%第一级判决结束帧
    
%从第一级判决起始帧开始进行第二判决（过零率）端点检测
   
BackSearch = min(start,25);
for m = start:-1:start-BackSearch+1
    rate = ZCR_Vector(m);
    if rate > IZCT
        ZCRCountb = ZCRCountb + 1;
        realstart = m;
    end
end
if ZCRCountb > 3
    start = realstart;         
                              
end

FwdSearch = min(length(Erg_Vector)-finish,25);
for n = finish+1:finish+FwdSearch
    rate = ZCR_Vector(n);
    if rate > IZCT
        ZCRCountf = ZCRCountf + 1;
        realfinish = n;
    end
end
if ZCRCountf > 3
    finish = realfinish;        
end

x_start = FrmIndex(start);      %最终的起始位置
x_finish = FrmIndex(finish-1);  %最终的结束位置
trimmed_X = x(x_start:x_finish); 