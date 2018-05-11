function frq = mel2frq(mel)
%MEL2FRQ  Convert Mel frequency scale to Hertz FRQ=(MEL)
%	frq = mel2frq(mel) converts a vector of Mel frequencies
%	to the corresponding real frequencies.
%	The Mel scale corresponds to the perceived pitch of a tone

%	The relationship between mel and frq is given by:
%
%	m = ln(1 + f/700) * 1000 / ln(1+1000/700)
%
%  	This means that m(1000) = 1000


frq=700*sign(mel).*(exp(abs(mel)/1127.01048)-1);
if ~nargout
    plot(mel,frq,'-x');
    xlabel(['Frequency (' xticksi 'Mel)']);
    ylabel(['Frequency (' yticksi 'Hz)']);
end
