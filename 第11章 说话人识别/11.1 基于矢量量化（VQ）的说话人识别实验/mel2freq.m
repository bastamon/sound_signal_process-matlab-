function f=mel2freq(mel)
%MEL2FREQ:Hz为单位的频率到Mel为单位的频率转化
%见mel2freq

f=700*(exp(mel/1125)-1);