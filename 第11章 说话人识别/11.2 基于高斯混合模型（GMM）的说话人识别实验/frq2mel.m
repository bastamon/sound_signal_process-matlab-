function mel = frq2mel(frq)
%FRQ2ERB  Convert Hertz to Mel frequency scale MEL=(FRQ)
%	mel = frq2mel(frq) converts a vector of frequencies (in Hz)
%	to the corresponding values on the Mel scale which corresponds
%	to the perceived pitch of a tone

%	The relationship between mel and frq is given by:
%
%	m = ln(1 + f/700) * 1000 / ln(1+1000/700)
%
%  	This means that m(1000) = 1000
%

mel = sign(frq).*log(1+abs(frq)/700)*1127.01048;
if ~nargout
    plot(frq,mel,'-x');
    xlabel(['Frequency (' xticksi 'Hz)']);
    ylabel(['Frequency (' yticksi 'Mel)']);
end
