function fmel=freq2mel(freq)
%FREA2MEL:Hz为单位的频率到Mel为单位的频率转化
%见mel2freq

fmel=1125*log(1+freq/700);