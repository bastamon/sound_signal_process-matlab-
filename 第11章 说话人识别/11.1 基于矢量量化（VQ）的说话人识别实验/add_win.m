function f=add_win(input_frame,win_stype)
%函数：f=add_win（input_frame,win）
%参数说明：input_frame:输入帧
%          win:窗类型，rect,hamming,hanning
%          f：返回加窗帧，为行向量
%函数功能：对输入信号加窗

fra=input_frame(:);
len=length(fra);
switch win_stype
    case 'rect'
        win=ones(len,1);
    case 'hamming'
        win=hamming(len);
    case 'hanning'
        win=hanning(len);
    otherwise
        error('wrong win_type')
        return
end
f=(fra.*win)';
        
        