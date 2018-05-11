clear all;
close all;
ncoeff = 12;          %MFCC参数阶数
N = 10;               %10个数字
fs=16000;             %采样频率                
duration2 = 2;        %录音时长
k = 3;                %训练样本的人数

speech = audiorecorder(fs,16,1);
disp('Press any key to start 2 seconds of speech recording...'); 
pause
disp('Recording speech...'); 
recordblocking(speech,duration2)             % duration*fs 为采样点数 
speechIn=getaudiodata(speech);
disp('Finished recording.');
disp('System is trying to recognize what you have spoken...');
speechIn = my_vad(speechIn);                    %端点检测 
rMatrix1 = mfccf(ncoeff,speechIn,fs);            %采用MFCC系数作为特征矢量
rMatrix = CMN(rMatrix1);                         %归一化处理                    

Sco = DTWScores(rMatrix,N);                      %计算DTW值
[SortedScores,EIndex] = sort(Sco,2);             %按行递增排序，并返回对应的原始次序
Nbr = EIndex(:,1:2)                              %得到每个模板匹配的2个最低值对应的次序

[Modal,Freq] = mode(Nbr(:));                      %返回出现频率最高的数Modal及其出现频率Freq

Word = char('zero','One','Two','Three','Four','Five','Six','Seven','Eight','Nine'); 
if mean(abs(speechIn)) < 0.01
    fprintf('No microphone connected or you have not said anything.\n');
elseif (Freq <2)                                %频率太低不确定
    fprintf('The word you have said could not be properly recognised.\n');
else
    fprintf('You have just said %s.\n',Word(Modal,:)); 
end

