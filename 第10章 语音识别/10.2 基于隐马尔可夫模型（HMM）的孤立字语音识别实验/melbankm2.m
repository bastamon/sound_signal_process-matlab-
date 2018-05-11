function [x,mn,mx]=melbankm2(p,n,fs,fl,fh,w)
%MELBANKM determine matrix for a mel-spaced filterbank [X,MN,MX]=(P,N,FS,FL,FH,W)
%
% Inputs:	p   number of filters in filterbank
%		n   length of fft
%		fs  sample rate in Hz
%		fl  low end of the lowest filter as a fraction of fs (default = 0)
%		fh  high end of highest filter as a fraction of fs (default = 0.5)
%		w   any sensible combination of the following:
%		      't'  triangular shaped filters in mel domain (default)
%		      'n'  hanning shaped filters in mel domain
%		      'm'  hamming shaped filters in mel domain
%
%		      'z'  highest and lowest filters taper down to zero (default)
%		      'y'  lowest filter remains at 1 down to 0 frequency and
%			   highest filter remains at 1 up to nyquist freqency
%
%		       If 'ty' or 'ny' is specified, the total power in the fft is preserved.
%
% Outputs:	x     a sparse matrix containing the filterbank amplitudes
%		      If x is the only output argument then size(x)=[p,1+floor(n/2)]
%		      otherwise size(x)=[p,mx-mn+1]
%		mn   the lowest fft bin with a non-zero coefficient
%		mx   the highest fft bin with a non-zero coefficient
%
% Usage:	f=fft(s);			f=fft(s);
%		x=melbankm(p,n,fs);		[x,na,nb]=melbankm(p,n,fs);
%		n2=1+floor(n/2);		z=log(x*(f(na:nb)).*conj(f(na:nb)));
%		z=log(x*abs(f(1:n2)).^2);
%		c=dct(z); c(1)=[];
%
% To plot filterbanks e.g.	plot(melbankm(20,256,8000)')
%


%      Copyright (C) Mike Brookes 1997
%
%      Last modified Tue May 12 16:15:28 1998
%
%   VOICEBOX home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You can obtain a copy of the GNU General Public License from
%   ftp://prep.ai.mit.edu/pub/gnu/COPYING-2.0 or by writing to
%   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 6
  w='tz';
  if nargin < 5
    fh=0.5;
    if nargin < 4
      fl=0;
    end
  end
end
f0=700/fs;
fn2=floor(n/2);
lr=log((f0+fh)/(f0+fl))/(p+1);
% convert to fft bin numbers with 0 for DC term
bl=n*((f0+fl)*exp([0 1 p p+1]*lr)-f0);
b2=ceil(bl(2));
b3=floor(bl(3));
if any(w=='y')
  pf=log((f0+(b2:b3)/n)/(f0+fl))/lr;
  fp=floor(pf);
  r=[ones(1,b2) fp fp+1 p*ones(1,fn2-b3)];
  c=[1:b3+1 b2+1:fn2+1];
  v=2*[0.5 ones(1,b2-1) 1-pf+fp pf-fp ones(1,fn2-b3-1) 0.5];
  mn=1;
  mx=fn2+1;
else
  b1=floor(bl(1))+1;
  b4=min(fn2,ceil(bl(4)))-1;
  pf=log((f0+(b1:b4)/n)/(f0+fl))/lr;
  fp=floor(pf);
  pm=pf-fp;
  k2=b2-b1+1;
  k3=b3-b1+1;
  k4=b4-b1+1;
  r=[fp(k2:k4) 1+fp(1:k3)];
  c=[k2:k4 1:k3];
  v=2*[1-pm(k2:k4) pm(1:k3)];
  mn=b1+1;
  mx=b4+1;
end
if any(w=='n')
  v=1-cos(v*pi/2);
elseif any(w=='m')
  v=1-0.92/1.08*cos(v*pi/2);
end
if nargout > 1
  x=sparse(r,c,v);
else
  x=sparse(r,c+mn-1,v,p,1+fn2);
end
